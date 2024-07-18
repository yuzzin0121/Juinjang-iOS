//
//  RecordingFilesViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit
import AVFoundation

class RecordingFilesViewController: BaseViewController {

    let lastPopupDateKey = "lastPopupDate" // 경고 메시지 날짜 저장 Key
    
    private let recordingFileTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.separatorInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        $0.register(RecordingFileViewCell.self, forCellReuseIdentifier: RecordingFileViewCell.identifier)
    }
    
    private let refreshControl = UIRefreshControl().then {
        $0.backgroundColor = .clear
    }
    
    var fileItems: [RecordResponse] = [] {
        didSet {
            recordingFileTableView.reloadData()
        }
    }
    
    weak var removeRecordDelegate: RemoveRecordDelegate?
    var imjangId: Int
    
    init(imjangId: Int) {
        self.imjangId = imjangId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        setConstraints()
        configureView()
        designNavigationBar()
        setDelegate()
        fetchRecordFiles()
        refreshControl.addTarget(self, action: #selector(refreshFiles), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAddObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)    }
    
    private func setAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(editRecordName), name: .editRecordName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editRecordScript), name: .editRecordScript, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addRecordResponse), name: .addRecordResponse, object: nil)
    }
    
    @objc private func addRecordResponse(_ notification: Notification) {
        print(#function)
        guard let recordResponse = notification.object as? RecordResponse else { return }
        fileItems.insert(recordResponse, at: 0)
    }
    
    @objc private func editRecordName(_ notification: Notification) {
        print(#function)
        guard let recordResponse = notification.object as? RecordResponse else { return }
        
        for index in fileItems.indices {
            if fileItems[index].recordId == recordResponse.recordId {
                fileItems[index].recordName = recordResponse.recordName
            }
        }
    }
      
    @objc private func editRecordScript(_ notification: Notification) {
        print(#function)
        guard let recordResponse = notification.object as? RecordResponse else { return }
        
        for index in fileItems.indices {
            if fileItems[index].recordId == recordResponse.recordId {
                fileItems[index].recordScript = recordResponse.recordScript
            }
        }
    }
    
    @objc private func refreshFiles() {
        fetchRecordFiles()
    }
    
    private func fetchRecordFiles() {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[RecordResponse]?>.self, api: .fetchRecordFiles(imjangId: imjangId)) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                guard let response, let result = response.result, let fileList = result else { return }
                fileItems = fileList
                refreshControl.endRefreshing()
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
    
    func setDelegate() {
        recordingFileTableView.dataSource = self
        recordingFileTableView.delegate = self
    }
    
    func designNavigationBar() {
        self.navigationItem.title = "녹음 파일"     // TODO: - 나중에 roomName 으로 연결
        self.navigationController?.navigationBar.tintColor = UIColor(named: "textBlack")
        navigationItem.setHidesBackButton(true, animated: true)

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(back))
        
        let addButtonItem = UIBarButtonItem(image: UIImage(named: "addOrange"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(startRecording))

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = addButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "mainOrange")
    }
    
    @objc func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func startRecording(_ sender: Any) {
        let bottomSheetVC = BottomSheetViewController(imjangId: imjangId)
        let warningMessageVC = WarningMessageViewController(imjangId: imjangId)
        let recordVC = RecordViewController(imjangId: imjangId)
        if shouldShowPopup() {
            warningMessageVC.bottomSheetViewController = bottomSheetVC
            warningMessageVC.delegate = self
            bottomSheetVC.addContentViewController(warningMessageVC)
            bottomSheetVC.modalPresentationStyle = .custom
            self.present(bottomSheetVC, animated: false, completion: nil)
        } else {
            print("오늘 하루 보지 않기 버튼을 선택했으므로 경고 메시지가 내일 나타납니다.")
            recordVC.bottomSheetViewController = bottomSheetVC
            bottomSheetVC.addContentViewController(recordVC)
            bottomSheetVC.modalPresentationStyle = .custom
            self.present(bottomSheetVC, animated: false, completion: nil)
        }
    }
    
    func shouldShowPopup() -> Bool {
        let userDefaults = UserDefaults.standard
        if let lastPopupDate = userDefaults.object(forKey: lastPopupDateKey) as? Date {
            let calendar = Calendar.current
            if calendar.isDateInToday(lastPopupDate) {
                return false
            } else {
                return true
            }
        } else {
            return true // 처음 실행
        }
    }
    
    func resetPopupDateIfNeeded() {
        let userDefaults = UserDefaults.standard
        if let lastPopupDate = userDefaults.object(forKey: lastPopupDateKey) as? Date {
            let calendar = Calendar.current
            if !calendar.isDateInToday(lastPopupDate) {
                userDefaults.removeObject(forKey: lastPopupDateKey)
            } else {
                print("오늘 하루 보지 않기 버튼을 선택했으므로 경고 메시지가 내일 나타납니다.")
            }
        }
    }
 
    func addSubViews() {
        view.addSubview(recordingFileTableView)
    }
    
    func setConstraints() {
        recordingFileTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        recordingFileTableView.refreshControl = refreshControl
    }
    
    func showDeletePopup(indexPath: IndexPath) {
        let deletePopupVC = DeletePopupViewController()
        deletePopupVC.fileIndexPath = indexPath
        //deletePopupVC.fileName = fileItems[indexPath.row].name
        
        let index = indexPath.row
        let fileName = fileItems[index].recordName
        deletePopupVC.fileName = fileItems[index].recordName
        deletePopupVC.completionHandler = { [weak self] indexPath in
            guard let self else { return }
            let index = indexPath.row
            deleteRecordFile(recordId: fileItems[index].recordId)
            NotificationCenter.default.post(name: .removeRecordResponse, object: fileItems[index].recordId, userInfo: nil)
            fileItems.remove(at: index)
            view.makeToast("\(fileName)이 삭제되었습니다.", duration: 1.0)
        }
        deletePopupVC.modalPresentationStyle = .overCurrentContext
        present(deletePopupVC, animated: false)
    }
    
    private func deleteRecordFile(recordId: Int) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<String>.self, api: .deleteRecordFile(recordId: recordId)) { response, error in
            if error == nil {
                guard let response, let result = response.result else { return }
                print(result)
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
    
    @objc func playButtonTapped(_ sender: UIButton) {
        // 버튼 이미지 변경
        print("버튼 눌림")
        sender.setImage(UIImage(named: "star"), for: .normal)
        
        // 녹음 파일을 재생하는 코드
        
    }
}

extension RecordingFilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordingFileViewCell.identifier, for: indexPath) as? RecordingFileViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none
        let fileItem = fileItems[indexPath.row]
        cell.setData(fileItem: fileItem)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordResponse = fileItems[indexPath.row]
        
        let bottomSheetViewController = BottomSheetViewController(imjangId: imjangId)
        let recordPlaybackVC = RecordPlaybackViewController(recordResponse: recordResponse)
        recordPlaybackVC.bottomSheetViewController = bottomSheetViewController
        bottomSheetViewController.addContentViewController(recordPlaybackVC)
        bottomSheetViewController.modalPresentationStyle = .custom
        self.present(bottomSheetViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제하기") {
            (_,_, completionHandler) in
            self.showDeletePopup(indexPath: indexPath)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(named: "mainOrange")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension RecordingFilesViewController: CheckWarningMessageDelegate {
    func checkMessage() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        UserDefaults.standard.set(startOfDay, forKey: lastPopupDateKey)
    }
}
