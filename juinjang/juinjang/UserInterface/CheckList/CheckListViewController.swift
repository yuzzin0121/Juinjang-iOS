//
//  CheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/20/24.
//

import UIKit
import SnapKit

class CheckListViewController: UIViewController {
    var imjangId: Int? = nil
    var calendarItems: [String: (inputDate: Date, isSelected: Bool)] = [:]
    var scoreItems: [String: (score: String, isSelected: Bool)] = [:]
    var inputItems: [String: (inputAnswer: String, isSelected: Bool)] = [:]
    var selectionItems: [String: (option: String, isSelected: Bool)] = [:]
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    var imjangId: Int? {
        didSet {
            print("체크리스트\(imjangId)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews()
        setupLayout()
        registerCell()
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedParentScroll), name: NSNotification.Name("didStoppedParentScroll"), object: nil)
    }
    
    @objc
    func didStoppedParentScroll() {
        DispatchQueue.main.async {
            self.tableView.isScrollEnabled = true
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
    
    func addSubViews() {
        view.addSubview(tableView)
    }
    
    func setupLayout() {
        // 테이블 뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview()
            $0.height.equalTo(698)
        }
    }
    
    private func registerCell() {
        tableView.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
        tableView.register(ExpandedScoreTableViewCell.self, forCellReuseIdentifier: ExpandedScoreTableViewCell.identifier)
        tableView.register(ExpandedCalendarTableViewCell.self, forCellReuseIdentifier: ExpandedCalendarTableViewCell.identifier)
        tableView.register(ExpandedTextFieldTableViewCell.self, forCellReuseIdentifier: ExpandedTextFieldTableViewCell.identifier)
        tableView.register(ExpandedDropdownTableViewCell.self, forCellReuseIdentifier: ExpandedDropdownTableViewCell.identifier)
    }
    
    // -MARK: API 요청
    func responseQuestion() {
        guard let imjangId = imjangId else { return }
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<CheckListResponseDto>.self, api: .checklist) { response, error in
            if error == nil {
                guard let checkListResponseDto = response?.result else { return }
                print(checkListResponseDto)
                self.setData(checkListResponseDto: checkListResponseDto)
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

    func setData(checkListResponseDto: CheckListResponseDto) {
        var categories: [Category] = []

        for questionDto in checkListResponseDto.questionDtos {
            let categoryId = questionDto.category
            let category: String
            let image: UIImage

            if categoryId == 0 {
                category = "기한"
                image = UIImage(named: "deadline-item")!
            } else if categoryId == 1 {
                category = "입지여건"
                image = UIImage(named: "location-conditions-item")!
            } else if categoryId == 2 {
               category = "공용공간"
               image = UIImage(named: "public-space-item")!
            } else if categoryId == 3 {
               category = "실내"
               image = UIImage(named: "indoor-item")!
            } else {
               print("존재하지 않는 CategoryId: \(categoryId)")
               continue
            }

            var newCategory = Category(image: image, name: category, items: [], isExpanded: false)
            categories.append(newCategory)

            for optionItem in checkListResponseDto.questionDtos {
                let questionItem = createQuestionItem(questionDto: optionItem)
                newCategory.items.append(questionItem)
            }
        }
    }

    func setData(checkListResponseDto: BaseResponse<[CheckListResponseDto]>) {
        guard let result = checkListResponseDto.result else {
             print("결과가 존재하지 않음.")
             return
         }

        var categories: [Category] = []

        for categoryResult in result {
            let categoryId = categoryResult.category
            let category: String
            let image: UIImage?

            if categoryId == 0 {
                category = "기한"
                image = UIImage(named: "deadline-item")
            } else if categoryId == 1 {
                category = "입지여건"
                image = UIImage(named: "location-conditions-item")
            } else if categoryId == 2 {
                category = "공용공간"
                image = UIImage(named: "public-space-item")
            } else if categoryId == 3 {
                category = "실내"
                image = UIImage(named: "indoor-item")
            } else {
                print("존재하지 않는 CategoryId: \(categoryId)")
                continue
            }

            // 옵셔널 바인딩을 사용하여 image가 nil이 아닌지 확인
            guard let validImage = image else {
                print("이미지 로드 실패")
                continue
            }

            // 이미지가 성공적으로 로드되었다면 Category 생성
            var newCategory = Category(image: validImage, name: category, items: [], isExpanded: false)
            categories.append(newCategory)

            // 카테고리 내의 QuestionDto 기반 체크리스트 항목 생성
            for questionDto in categoryResult.questionDtos {
                let questionItem = createQuestionItem(questionDto: questionDto)
                newCategory.items.append(questionItem)
            }
        }
//    func setData(CheckListResponseDto: BaseResponse<[CheckListResponseDto]>) {
//        guard let result = CheckListResponseDto.result else {
//             print("결과가 존재하지 않음.")
//             return
//         }
//        
//        var categories: [Category] = []
//        
//        for questionDto in result {
//            let categoryId = questionDto.category
//            let category: String
//            let image: UIImage?
//            
//            if categoryId == 0 {
//                category = "기한"
//                image = UIImage(named: "deadline-item")
//            } else if categoryId == 1 {
//                category = "입지여건"
//                image = UIImage(named: "location-conditions-item")
//            } else if categoryId == 2 {
//                category = "공용공간"
//                image = UIImage(named: "public-space-item")
//            } else if categoryId == 3 {
//                category = "실내"
//                image = UIImage(named: "indoor-item")
//            } else {
//                print("존재하지 않는 CategoryId: \(categoryId)")
//                continue
//            }
//            
//            // 옵셔널 바인딩을 사용하여 image가 nil이 아닌지 확인
//            guard let validImage = image else {
//                print("이미지 로드 실패")
//                continue
//            }
//            
//            // 이미지가 성공적으로 로드되었다면 Category 생성
//            var newCategory = Category(image: validImage, name: category, items: [], isExpanded: false)
//            categories.append(newCategory)
//            
//            // QuestionDto 기반 체크리스트 항목 생성
//            let questionItem = createQuestionItem(questionDto: questionDto)
//            
//            // 항목을 카테고리 목록에 추가
//            newCategory.items.append(questionItem)
//        }
    }
    
    func createQuestionItem(questionDto: QuestionDto) -> Item {
        switch questionDto.answerType {
        // 달력, 점수형, 텍스트필드, 드롭다운 형태
        case 0:
            return CalendarItem(content: questionDto.question, inputDate: Date(), isSelected: false)
        case 1:
            return ScoreItem(content: questionDto.question)
        case 2:
            return InputItem(content: questionDto.question)
        case 3:
            let options = questionDto.options.map { optionDto in
                OptionItem(image: nil, option: optionDto.optionValue)
            }
            return SelectionItem(content: questionDto.question, options: options)
        default:
            fatalError("찾을 수 없는 답변 형태: \(questionDto.answerType)")
        }
    }
}

extension CheckListViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            let offset = scrollView.contentOffset.y

            // 스크롤이 맨 위에 있을 때만 tableView의 스크롤을 비활성화
            if offset <= 0 {
                tableView.isScrollEnabled = false
                NotificationCenter.default.post(name: NSNotification.Name("didStoppedChildScroll"), object: nil)
            } else {
                tableView.isScrollEnabled = true
            }
        }
    }
 
    // section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    // row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories[section].isExpanded {
            return 1 + categories[section].items.count // section이 확장된 경우, 카테고리 셀과 확장된 항목들이 나타남
        } else {
            return 1 // section이 확장되지 않은 경우, 카테고리 셀만 나타남
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as? CategoryItemTableViewCell else { return UITableViewCell() }
            
            let category = categories[indexPath.section]
            cell.categoryImage.image = categories[indexPath.section].image
            cell.categoryLabel.text = categories[indexPath.section].name
            
            // section 확장 유무에 따라서 화살표 이미지 변경
            let arrowImage = category.isExpanded ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
            cell.expandButton.setImage(arrowImage, for: .normal)
            
            let itemcell = ExpandedDropdownTableViewCell()
            itemcell.itemPickerView.isUserInteractionEnabled = true
            
            return cell
            
        } else {
            // 카테고리 셀 클릭 시 펼쳐질 셀
            let category = categories[indexPath.section]
            
            if let calendarItem = category.items[indexPath.row - 1] as? CalendarItem {
                // CalendarItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as? ExpandedCalendarTableViewCell else { return UITableViewCell() }
                cell.contentLabel.text = calendarItem.content
                cell.configure(with: calendarItem, at: indexPath)
                
//                // 데이터 모델에서 저장된 값으로 셀 구성
                let contentKey = calendarItem.content
                cell.backgroundColor = cell.calendarItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                // 셀이 선택된 경우 클로저 호출
                cell.selectionHandler = { [weak self, weak cell] selectedDate in
                    print("Selected Date in TableView:", selectedDate)
                    self?.calendarItems.updateValue((selectedDate, true), forKey: contentKey)
                }
                
                cell.calendarItems = calendarItems
                print("calendarItems 데이터", calendarItems)
                return cell
            } else if let scoreItem = category.items[indexPath.row - 1] as? ScoreItem {
                // ScoreItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as? ExpandedScoreTableViewCell else { return UITableViewCell() }
                
                cell.contentLabel.text = scoreItem.content
                cell.configure(with: scoreItem, at: indexPath)
//                cell.score = scoreItem.score
                
                // 데이터 모델에서 저장된 값으로 셀 구성
                let contentKey = scoreItem.content
                cell.backgroundColor = cell.scoreItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                // 셀이 선택된 경우 클로저 호출
                cell.selectionHandler = { [weak self, weak cell] score in
                    print("Selected button in TableView:", score)
                    self?.scoreItems.updateValue((score, true), forKey: contentKey)
                }
                cell.scoreItems = scoreItems
                print("scoreItems 데이터", cell.scoreItems)
                return cell
            } else if let inputItem = category.items[indexPath.row - 1] as? InputItem {
                // InputItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as? ExpandedTextFieldTableViewCell else { return UITableViewCell() }
                
                cell.contentLabel.text = inputItem.content
                cell.configure(with: inputItem, at: indexPath)
//                cell.inputAnswer = inputItem.inputAnswer
                
                // 데이터 모델에서 저장된 값으로 셀 구성
                let contentKey = inputItem.content
                cell.backgroundColor = cell.inputItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                // 셀이 선택된 경우 클로저 호출
                cell.inputHandler = { [weak self, weak cell] inputAnswer in
                    print("Inputed answer in TableView:", inputAnswer)
                    self?.inputItems.updateValue((inputAnswer, true), forKey: contentKey)
                }
                
                cell.inputItems = inputItems
                print("inputItems 데이터", cell.inputItems)
                return cell
            } else if let selectionItem = category.items[indexPath.row - 1] as? SelectionItem {
                // SelectionItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as? ExpandedDropdownTableViewCell else { return UITableViewCell() }

                cell.contentLabel.text = selectionItem.content
                cell.configure(with: selectionItem, at: indexPath)
                cell.options = selectionItem.options
                cell.selectedOption = selectionItem.selectAnswer
                
                // 데이터 모델에서 저장된 값으로 셀 구성
                let contentKey = selectionItem.content
                cell.backgroundColor = cell.selectionItems[contentKey]?.isSelected ?? false ? UIColor(named: "lightOrange") : UIColor.white // 상태에 따라 배경색 설정

                // 셀이 선택된 경우 클로저 호출
                cell.selectionHandler = { [weak self, weak cell] selectedOption in
                    print("selected Option in TableView:", selectedOption)
                    self?.selectionItems.updateValue((selectedOption, true), forKey: contentKey)
                }
                cell.selectionItems = selectionItems
                print("selectionItems 데이터", cell.selectionItems)
                return cell
            } 
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var category = categories[indexPath.section]
        
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryItemTableViewCell {
            // 카테고리 셀을 눌렀을 때
            if indexPath.row == 0 {
                if categories[indexPath.section].isExpanded == true {
                    categories[indexPath.section].isExpanded = false
                    // 테이블 뷰 리로드
                    tableView.reloadSections([indexPath.section], with: .automatic)
                } else {
                    categories[indexPath.section].isExpanded = true
                }
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            } else {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedCalendarTableViewCell {
            // 확장된 캘린더 셀을 눌렀을 때
            if let selectedDate = cell.selectedDate, var item = category.items[indexPath.row - 1] as? CalendarItem {
                item.inputDate = selectedDate
                item.isSelected = true
                category.items[indexPath.row - 1] = item
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedScoreTableViewCell {
            // 확장 점수 셀을 눌렀을 때
            if let selectedAnswer = cell.score, var item = category.items[indexPath.row - 1] as? ScoreItem {
                item.score = selectedAnswer
                item.isSelected = true
                category.items[indexPath.row - 1] = item
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedTextFieldTableViewCell {
            // 확장 입력 셀을 눌렀을 때
            if let inputAnswer = cell.inputAnswer, var item = category.items[indexPath.row - 1] as? InputItem {
                item.inputAnswer = inputAnswer
                item.isSelected = true
                category.items[indexPath.row - 1] = item
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedDropdownTableViewCell {
            // 확장 드롭다운 셀을 눌렀을 때
            if let selectedOption = cell.selectedOption, var item = category.items[indexPath.row - 1] as? SelectionItem {
                item.selectAnswer = selectedOption
                item.isSelected = true
                category.items[indexPath.row - 1] = item
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 0 else {
            // 카테고리 셀의 높이
            return 63
        }

        let category = categories[indexPath.section]
        let selectedItem = category.items[indexPath.row - 1]

        switch selectedItem {
        case is CalendarItem:
            return 480
        case is ScoreItem, is InputItem:
            return 98
        case is SelectionItem:
            return 114
        default:
            return UITableView.automaticDimension
        }
    }
}
