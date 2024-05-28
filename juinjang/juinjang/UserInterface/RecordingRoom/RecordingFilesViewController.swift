//
//  RecordingFilesViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit
import AVFoundation

class RecordingFilesViewController: UIViewController {
    
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
    
    var imjangId: Int
    
    init(imjangId: Int) {
        self.imjangId = imjangId
        super.init(nibName: nil, bundle: nil)
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
        NotificationCenter.default.addObserver(self, selector: #selector(editRecordName), name: .editRecordName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        let bottomSheetViewController = BottomSheetViewController(imjangId: imjangId)
        let warningMessageVC = WarningMessageViewController(imjangId: imjangId)
        warningMessageVC.bottomSheetViewController = bottomSheetViewController
        bottomSheetViewController.addContentViewController(warningMessageVC)
        bottomSheetViewController.modalPresentationStyle = .custom
        self.present(bottomSheetViewController, animated: false, completion: nil)
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
