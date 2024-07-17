//
//  CheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 2/19/24.
//
// TODO: 버전, 셀 저장, 셀 값 해제 문제
import UIKit
import SnapKit
import Alamofire
import RealmSwift

class CheckListViewController: BaseViewController {
    
    // 체크리스트 정보
    var version: Int
    var imjangId: Int
    var isEditMode: Bool = false // 수정 모드 여부
    var allCategory: [String] = [] // 카테고리
    var checkListCategories: [CheckListCategory] = [] // 카테고리별 질문
    var savedCheckListItems: [CheckListAnswer] = [] // 저장되어 있던 체크리스트 항목
    var checkListItems: [CheckListAnswer] = [] // 저장될 체크리스트 항목
    
    init(imjangId: Int, version: Int) {
        self.imjangId = imjangId
        self.version = version
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.frame.size.height = $0.contentSize.height
    }
    
    override func viewDidLoad() {
        addCheckListModel()
        super.viewDidLoad()
        view.backgroundColor = .white
        setTableView()
        addSubViews()
        setupLayout()
        registerCell()
        setCheckInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedParentScroll), name: NSNotification.Name("didStoppedParentScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditModeChange(_:)), name: Notification.Name("EditModeChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditButtonTappedNotification), name: NSNotification.Name("EditButtonTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReloadTableView), name: NSNotification.Name("ReloadTableView"), object: nil)
    }
    
    private func setCheckInfo() {
        showCheckList {
            self.filterVersionAndCategory() { [weak self] categories in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addSubViews() {
        view.addSubview(tableView)
    }
        
    func setupLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(698)
        }
    }
    
    func registerCell() {
        tableView.register(NotEnteredCalendarTableViewCell.self, forCellReuseIdentifier: NotEnteredCalendarTableViewCell.identifier)
        tableView.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
        tableView.register(ExpandedScoreTableViewCell.self, forCellReuseIdentifier: ExpandedScoreTableViewCell.identifier)
        tableView.register(ExpandedCalendarTableViewCell.self, forCellReuseIdentifier: ExpandedCalendarTableViewCell.identifier)
        tableView.register(ExpandedTextFieldTableViewCell.self, forCellReuseIdentifier: ExpandedTextFieldTableViewCell.identifier)
        tableView.register(ExpandedDropdownTableViewCell.self, forCellReuseIdentifier: ExpandedDropdownTableViewCell.identifier)
    }
    
    // -MARK: DB 관리
    func addCheckListModel() {
        // Realm 데이터베이스 추가
        do {
            let realm = try Realm()
            
            // CheckListItem가 존재하지 않을 때만 추가
            if realm.objects(CheckListItem.self).isEmpty {
                try realm.write {
                    realm.add(items)
                    realm.add(oneRoomItems)
                    addOptionData()
                    print("CheckListItem이 성공적으로 생성되었습니다.")
                }
            } else {
                print("CheckListItem이 이미 존재합니다.")
            }
            mappingOption()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        } catch let error as NSError {
            print("DB 추가 실패: \(error.localizedDescription)")
            print("에러: \(error)")
        }
    }
    
    // -MARK: 버전 조회
    func filterVersionAndCategory(completion: @escaping ([CheckListItem]) -> Void) {
        do {
            let realm = try Realm()
            var result = realm.objects(CheckListItem.self)
            
            print("조회한 체크리스트 버전: \(version)")
            result = result.filter("version == \(version)")
            
            let checkListItems = Array(result)
            
            var uniqueCategories = [String]()
            for item in checkListItems {
                if !allCategory.contains(item.category) {
                    allCategory.append(item.category)
                }
            }

            for category in allCategory {
                // 해당 카테고리에 해당하는 항목들을 필터링하여
                let categoryItems = checkListItems.filter { $0.category == category }
                // checkListCategories에 추가
                self.checkListCategories.append(CheckListCategory(category: category, checkListitem: categoryItems, isExpanded: false))
            }
            completion(checkListItems)
        } catch {
            print("Realm 데이터베이스에 접근할 수 없음: \(error)")
            completion([])
        }
    }
    
    // -MARK: API 요청(체크리스트 조회)
    func showCheckList(completion: @escaping () -> Void) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[QuestionAnswerDto]>.self, api: .showChecklist(imjangId: imjangId)) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                guard let response = response else { return }
                // 이미 추가된 questionId를 추적하기 위한 Set
                var addedQuestionIds = Set<Int>()
                
                if let categoryItem = response.result {
                    for item in categoryItem {
                        // 이미 추가된 questionId인 경우
                        if addedQuestionIds.contains(item.questionId) {
                            continue
                        }
                        
                        // CheckListAnswer 객체를 생성하여 배열에 추가
                        let checkListAnswer = CheckListAnswer(imjangId: self.imjangId,
                                                              questionId: item.questionId,
                                                              answer: item.answer,
                                                              isSelected: true)
                        
                        savedCheckListItems.append(checkListAnswer)
                        checkListItems.append(checkListAnswer)
                        
                        // 추가된 questionId를 Set에 추가
                        addedQuestionIds.insert(item.questionId)
                    }
                }
                print("------저장된 체크리스트 조회------")
                for checkListItem in checkListItems {
                    print(checkListItem)
                }
                completion()
            } else {
                guard let error = error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        // 토큰 재발급 API 호출
        let url = JuinjangAPI.regenerateToken.endpoint
        AF.request(url, method: .post).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let responseDict = value as? [String: Any],
                   let newToken = responseDict["newToken"] as? String {
                    UserDefaultManager.shared.accessToken = newToken
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }

    
    // MARK: - API 요청
    func saveAnswer() {
        let token = UserDefaultManager.shared.accessToken
        print("토큰값 \(token)")

        // 저장된 체크리스트 불러오기
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[QuestionAnswerDto]>.self, api: .showChecklist(imjangId: imjangId)) { [weak self] response, error in
            guard let self = self else { return }
            guard let checkListResponse = response else {
                print("실패: \(error?.localizedDescription ?? "error")")
                return
            }

            let checkListItems = self.checkListItems
            var savedQuestionIds = Set<Int>()
            var uniqueItems = [CheckListAnswer]()
            
            // 서버에서 불러온 questionId 목록
            var existingItems = [Int: CheckListAnswer]()
            if let categoryItem = checkListResponse.result {
                for item in categoryItem {
                    existingItems[item.questionId] = CheckListAnswer(imjangId: imjangId, questionId: item.questionId, answer: item.answer, isSelected: true)
                }
            }

            // 최근에 추가된 항목만 유지하고 중복된 항목 제거
            for item in checkListItems.reversed() {
                if !savedQuestionIds.contains(item.questionId) {
                    savedQuestionIds.insert(item.questionId)
                    uniqueItems.insert(item, at: 0) // 최근 항목을 배열의 첫 부분에 추가
                } else {
                    // 중복된 항목은 제거
                    if let index = uniqueItems.firstIndex(where: { $0.questionId == item.questionId }) {
                        uniqueItems.remove(at: index)
                    }
                }
            }

            self.checkListItems = uniqueItems

            // 유효한 값만 필터링
            let validCheckListItems = checkListItems.filter { item in
                if let answer = item.answer as? String {
                    return !answer.isEmpty
                } else {
                    return true
                }
            }

            print("----- 체크리스트 저장할 항목 -----")
            for checkListItem in validCheckListItems {
                print(checkListItem)
            }

            // 저장할 항목과 수정할 항목 분리
            var saveItems = [CheckListAnswer]()
            var modifyItems = [CheckListAnswer]()

            for item in validCheckListItems {
                if let existingItem = existingItems[item.questionId] {
                    if existingItem.answer != item.answer {
                        modifyItems.append(item)
                    }
                } else {
                    saveItems.append(item)
                }
            }

            // 저장 요청 처리
            if !saveItems.isEmpty {
                self.saveChecklist(items: saveItems, token: token)
            }

            // 수정 요청 처리
            if !modifyItems.isEmpty {
                self.modifyChecklist(items: modifyItems, token: token)
            }
        }
    }

    // 체크리스트 저장
    private func saveChecklist(items: [CheckListAnswer], token: String) {
        self.requestChecklist(with: .post, items: items, token: token)
    }

    // 체크리스트 수정
    private func modifyChecklist(items: [CheckListAnswer], token: String) {
        self.requestChecklist(with: .patch, items: items, token: token)
    }

    // 체크리스트 API
    private func requestChecklist(with method: HTTPMethod, items: [CheckListAnswer], token: String) {
        let parameters = items.map { item -> [String: Any?] in
            var answerValue: Any? = item.answer
            if let answer = item.answer as? String, answer == "NaN" || answer.isEmpty {
                answerValue = NSNull()
            }
            return [
                "questionId": item.questionId,
                "answer": answerValue
            ]
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON Data: \(jsonString)")
            }

            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]

            var request: URLRequest
            if method == .post {
                request = URLRequest(url: JuinjangAPI.saveChecklist(imjangId: self.imjangId).endpoint)
            } else if method == .patch {
                request = URLRequest(url: JuinjangAPI.modifyChecklist(imjangId: self.imjangId).endpoint)
            } else {
                return
            }

            request.httpMethod = method.rawValue
            request.headers = headers
            request.httpBody = jsonData

            AF.request(request)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print("체크리스트 \(method == .post ? "저장" : "수정") 처리 성공")
                        print(value)
                        self.showCheckList(completion: {})
                    case .failure(let error):
                        print("체크리스트 \(method == .post ? "저장" : "수정") 처리 실패")
                        if let data = response.data,
                           let errorMessage = String(data: data, encoding: .utf8) {
                            print("서버 응답 에러 메시지: \(errorMessage)")
                            // 토큰 관련 에러 처리
                            if response.response?.statusCode == 401 {
                                self.refreshToken { success in
                                    if success {
                                        self.requestChecklist(with: method, items: items, token: UserDefaultManager.shared.accessToken ?? "")
                                    } else {
                                        print("토큰 만료")
                                    }
                                }
                            }
                        } else {
                            print("에러: \(error.localizedDescription)")
                        }
                    }
                }
        } catch {
            print("encoding 에러: \(error)")
        }
    }
    
    // 키보드 내리기
    func hideKeyboardWhenTappedArround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleEditModeChange(_ notification: Notification) {
        if let isEditMode = notification.object as? Bool {
            print("isEditMode 상태: \(isEditMode)")
            self.isEditMode = isEditMode
            filterVersionAndCategory() { [weak self] result in
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func handleEditButtonTappedNotification() {
        saveAnswer()
    }
    
    @objc func didStoppedParentScroll() {
        DispatchQueue.main.async {
            self.tableView.isScrollEnabled = true
        }
    }
    
    @objc func ReloadTableView() {
        isEditMode = false
        // 확장 셀 닫기
        for i in 0..<checkListCategories.count {
            checkListCategories[i].isExpanded = false
        }
        tableView.reloadData()
        // 스크롤의 제일 위로 이동
         if tableView.numberOfSections > 0, tableView.numberOfRows(inSection: 0) > 0 {
             tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
         }
        NotificationCenter.default.post(name: NSNotification.Name("ScrollToTop"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CheckListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.tableView else { return }
        
        let offset = scrollView.contentOffset.y
        
        // 스크롤이 맨 위에 있을 때만 tableView의 스크롤을 비활성화
        if offset <= 0 {
            if tableView.isScrollEnabled {
                tableView.isScrollEnabled = false
                NotificationCenter.default.post(name: NSNotification.Name("didStoppedChildScroll"), object: nil)
            }
        } else {
            if !tableView.isScrollEnabled {
                tableView.isScrollEnabled = true
            }
        }
    }
}

extension CheckListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isEditMode ? allCategory.count + 1 : allCategory.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !isEditMode {
            return 1
        } else {
            let adjustedSection = isEditMode ? section - 1 : section
            if adjustedSection < 0 || adjustedSection >= checkListCategories.count {
                return 0
            }
            
            if checkListCategories[adjustedSection].isExpanded {
                return 1 + checkListCategories[adjustedSection].checkListitem.count
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEditMode {
            if indexPath.row == 0 {
                let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
                let items = self.checkListCategories[indexPath.section - 1]
                cell.configure(category: items)
                let arrowImage = items.isExpanded ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
                cell.expandButton.setImage(arrowImage, for: .normal)
                
                return cell
            } else {
                let category = checkListCategories[indexPath.section - 1]
                let questionDto = category.checkListitem[indexPath.row - 1]
                let questionId = questionDto.questionId
                
                switch questionDto.answerType {
                case 0:
                    // ScoreItem
                    let cell: ExpandedScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as! ExpandedScoreTableViewCell
                    
                    // 수정모드 진입 시 셀 UI 설정
                    cell.editModeConfigure(with: questionDto, at: indexPath)
                    
                    // 임시로 저장한 값에 대한 셀 UI 설정
                    for item in checkListItems {
                        if questionId == item.questionId {
                            cell.savedEditModeConfigure(with: item.answer, at: indexPath)
                        }
                    }
                    
                    cell.scoreSelectionHandler = { [weak self] score in
                        if let self = self {
                            print("Selected Score: \(score)")
                            
                            // 현재 questionId에 대한 기존 답변이 있는지 확인
                            if let index = self.checkListItems.firstIndex(where: { $0.questionId == questionId }) {
                                let existingAnswer = self.checkListItems[index]
                                if existingAnswer.answer == score {
                                    // 선택 취소하는 경우
                                    self.checkListItems.remove(at: index)
                                    print("\(questionId)번에 해당하는 답변 삭제")
                                } else {
                                    // 선택 수정하는 경우
                                    let updatedAnswer = CheckListAnswer(imjangId: existingAnswer.imjangId, questionId: existingAnswer.questionId, answer: score, isSelected: true)
                                    self.checkListItems[index] = updatedAnswer
                                    print("\(questionId)번에 해당하는 답변 수정")
                                }
                            } else {
                                // 기존 답변이 없는 경우 답변을 생성하여 배열에 추가
                                let answerItem = CheckListAnswer(imjangId: self.imjangId, questionId: questionId, answer: score, isSelected: true)
                                self.checkListItems.append(answerItem)
                                print("\(questionId)번에 해당하는 답변 생성")
                            }
//                            print(checkListItems)
                        }
                    }

                    for button in [cell.answerButton1, cell.answerButton2, cell.answerButton3, cell.answerButton4, cell.answerButton5] {
                        button.isEnabled = true
                        button.setImage(UIImage(named: "answer\(button.tag)"), for: .normal)
                    }

                    return cell
                case 1:
                    // SelectionItem
                    let cell: ExpandedDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as! ExpandedDropdownTableViewCell

                    cell.editModeConfigure(with: questionDto, at: indexPath)
                    
                    // 임시로 저장한 값
                    for item in checkListItems {
                        if questionId == item.questionId {
                            if let optionsForQuestion = questionOptions[questionId] {
                                cell.savedEditModeConfigure(with: item.answer, with: optionsForQuestion, at: indexPath)
                            }
                        }
                    }
                                
                    cell.optionSelectionHandler = { [weak self] option in
                        if let self = self {
                            print("Selected Option: \(option)")
                            
                            // 현재 questionId에 대한 기존 답변이 있는지 확인
                            if let index = self.checkListItems.firstIndex(where: { $0.questionId == questionId }) {
                                let existingAnswer = self.checkListItems[index]
                                if option == "선택안함" {
                                    // 선택 취소하는 경우
                                    self.checkListItems.remove(at: index)
                                    print("\(questionId)번에 해당하는 답변 삭제")
                                } else if existingAnswer.answer != option {
                                    // 선택 수정하는 경우
                                    let updatedAnswer = CheckListAnswer(imjangId: existingAnswer.imjangId, questionId: existingAnswer.questionId, answer: option, isSelected: true)
                                    self.checkListItems[index] = updatedAnswer
                                    print("\(questionId)번에 해당하는 답변 수정")
                                }
                            } else {
                                if option != "선택안함" {
                                    // 기존 답변이 없는 경우 답변을 생성하여 배열에 추가
                                    let answerItem = CheckListAnswer(imjangId: self.imjangId, questionId: questionId, answer: option, isSelected: true)
                                    self.checkListItems.append(answerItem)
                                    print("\(questionId)번에 해당하는 답변 생성")
                                }
                            }
//                            print(checkListItems)
                        }
                    }

                    cell.itemButton.isUserInteractionEnabled = true
                    cell.itemPickerView.isUserInteractionEnabled = true
                    
                    return cell
                case 2:
                    // InputItem
                    let cell: ExpandedTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as! ExpandedTextFieldTableViewCell
                    
                    cell.editModeConfigure(with: questionDto, at: indexPath)
                    
                    // 임시로 저장한 값
                    for item in checkListItems {
                        if questionId == item.questionId {
                            cell.savedEditModeConfigure(with: item.answer, at: indexPath)
                        }
                    }
                    
                    cell.textSelectionHandler = { [weak self] text in
                        if let self = self {
                            print("Selected text: \(text)")
                            
                            // 현재 questionId에 대한 기존 답변이 있는지 확인
                            if let index = self.checkListItems.firstIndex(where: { $0.questionId == questionId }) {
                                let existingAnswer = self.checkListItems[index]
                                if text == "" {
                                    // 답변 삭제하는 경우
                                    self.checkListItems.remove(at: index)
                                    print("\(questionId)번에 해당하는 답변 삭제")
                                } else if existingAnswer.answer != text {
                                    // 답변 수정하는 경우
                                    let updatedAnswer = CheckListAnswer(imjangId: existingAnswer.imjangId, questionId: existingAnswer.questionId, answer: text, isSelected: true)
                                    self.checkListItems[index] = updatedAnswer
                                    print("\(questionId)번에 해당하는 답변 수정")
                                }
                            } else {
                                // 기존 답변이 없는 경우 답변을 생성하여 배열에 추가
                                let answerItem = CheckListAnswer(imjangId: imjangId, questionId: questionId, answer: text, isSelected: true)
                                self.checkListItems.append(answerItem)
                                print("\(questionId)번에 해당하는 답변 생성")
                            }
//                            print(checkListItems)
                        }
                    }

                    cell.answerTextField.isEnabled = true
                    
                    return cell
                case 3:
                    // CalendarItem
                    let cell: ExpandedCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as! ExpandedCalendarTableViewCell

                    cell.editModeConfigure(with: questionDto,  at: indexPath)
                    
                    // 임시로 저장한 값
                    for item in checkListItems {
                        if questionId == item.questionId {
                            cell.savedEditModeConfigure(with: item.answer, at: indexPath)
                        }
                    }
                    
                    cell.dateSelectionHandler = { [weak self] date in
                        if let self = self {
                            print("Selected Date: \(date)")
                            
                            // 현재 questionId에 대한 기존 답변이 있는지 확인
                            if let index = self.checkListItems.firstIndex(where: { $0.questionId == questionId }) {
                                let existingAnswer = self.checkListItems[index]
                                
                                if existingAnswer.answer == date {
                                    // 선택 취소하는 경우
                                    self.checkListItems.remove(at: index)
                                    print("\(questionId)번에 해당하는 답변 삭제")
                                } else {
                                    // 선택 수정하는 경우
                                    let updatedAnswer = CheckListAnswer(imjangId: existingAnswer.imjangId, questionId: existingAnswer.questionId, answer: date, isSelected: true)
                                    self.checkListItems[index] = updatedAnswer
                                    print("\(questionId)번에 해당하는 답변 수정")
                                }
                            } else {
                                // 기존 답변이 없는 경우 답변을 생성하여 배열에 추가
                                let answerItem = CheckListAnswer(imjangId: imjangId, questionId: questionId, answer: date, isSelected: true)
                                self.checkListItems.append(answerItem)
                                print("\(questionId)번에 해당하는 답변 생성")
                            }
//                            print(checkListItems)
                        }
                    }
                    
                    return cell
                default:
                    fatalError("찾을 수 없는 답변 형태: \(questionDto.answerType)")
                }
            }
        } else {
            if indexPath.section == 0 && !isEditMode {
                // 기한 카테고리 섹션 셀 (NotEnteredCalendarTableViewCell)
                let cell: NotEnteredCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: NotEnteredCalendarTableViewCell.identifier, for: indexPath) as! NotEnteredCalendarTableViewCell
                
                cell.viewModeConfigure(at: indexPath)
                // 임장용일 때 달력형 질문에 대한 답변 표시
                if version == 0 {
                    for item in checkListItems {
                        var date: [(Int, String)] = [(1, ""), (2, "")]
                        if item.questionId == 1 {
                            date[0].1 = item.answer
                        } else if item.questionId == 2 {
                            date[1].1 = item.answer
                        }
                        cell.savedViewModeConfigure(with: item.imjangId, with: date, at: indexPath)
                    }
                // 원룸용일 때 달력형 질문에 대한 답변 표시
                } else if version == 1 {
                    for item in checkListItems {
                        var date: [(Int, String)] = [(59, ""), (60, "")]
                        if item.questionId == 59 {
                            date[0].1 = item.answer
                        } else if item.questionId == 60 {
                            date[1].1 = item.answer
                        }
                        cell.savedViewModeConfigure(with: item.imjangId, with: date, at: indexPath)
                    }
                }
                
                return cell
            } else {
                // 나머지 섹션 셀
                let adjustedSection = isEditMode ? indexPath.section - 1 : indexPath.section
                let category = checkListCategories[adjustedSection]
                
                if indexPath.row == 0 {
                    let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
    
                    cell.configure(category: category)
                
                    let arrowImage = category.isExpanded ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
                    cell.expandButton.setImage(arrowImage, for: .normal)
                    
                    return cell
                } else {
                    let questionDto = category.checkListitem[indexPath.row - 1]
                    let questionId = questionDto.questionId
                    
                    switch questionDto.answerType {
                    case 0:
                        // ScoreItem
                        let cell: ExpandedScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as! ExpandedScoreTableViewCell
                        
                        cell.viewModeConfigure(with: questionDto, at: indexPath)
                        
                        for saveItem in checkListItems {
                            if questionId == saveItem.questionId {
                                cell.savedViewModeConfigure(with: saveItem.answer, at: indexPath)
                            }
                        }
                        return cell
                    case 1:
                        // SelectionItem
                        let cell: ExpandedDropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as! ExpandedDropdownTableViewCell
                        
                        cell.viewModeConfigure(with: questionDto, at: indexPath)
                        
                        for item in checkListItems {
                            if questionId == item.questionId {
                                if let optionsForQuestion = questionOptions[questionId] {
                                    // 해당 질문에 대한 옵션을 사용하여 작업 수행
                                    cell.savedViewModeConfigure(with: item.answer, with: optionsForQuestion, at: indexPath)
                                } else {
                                    // 해당 질문에 대한 옵션이 없을 경우 처리
                                    print("해당 질문에 대한 옵션이 없습니다.")
                                }
                            }
                        }
                        return cell
                    case 2:
                        // InputItem
                        let cell: ExpandedTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as! ExpandedTextFieldTableViewCell

                        cell.viewModeConfigure(with: questionDto, at: indexPath)
                        
                        for item in checkListItems {
                            if questionId == item.questionId {
                                cell.savedViewModeConfigure(with: item.answer, at: indexPath)
                            }
                        }
                        return cell
                    case 3:
                        // CalendarItem
                        let cell: ExpandedCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as! ExpandedCalendarTableViewCell
                        
                        return cell
                    default:
                        fatalError("찾을 수 없는 답변 형태: \(questionDto.answerType)")
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let adjustedSection = isEditMode ? indexPath.section - 1 : indexPath.section
            checkListCategories[adjustedSection].isExpanded.toggle()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 0 else {
            // 카테고리 셀의 높이
            return 63
        }
        
        let adjustedSection = isEditMode ? indexPath.section - 1 : indexPath.section
        guard adjustedSection >= 0 && adjustedSection < checkListCategories.count else {
            return UITableView.automaticDimension
        }
        
        let category = checkListCategories[adjustedSection]
        guard indexPath.row - 1 < category.checkListitem.count else {
            return UITableView.automaticDimension
        }
        
        let questionDto = category.checkListitem[indexPath.row - 1]
        
        switch questionDto.answerType {
        case 0, 2: // ScoreItem, InputItem
            return 98
        case 1: // SelectionItem
            return 114
        case 3: // CalendarItem
            return isEditMode ? 480 : 0
        default:
            return UITableView.automaticDimension
        }
    }
}
