//
//  RecordingFilesViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit
import AVFoundation

class RecordingFilesViewController: UIViewController {

    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.bounces = false
    }
    
    // 스크롤할 컨텐트뷰
    let contentView = UIView()
    
    let recordingFileTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.separatorInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        $0.register(RecordingFileViewCell.self, forCellReuseIdentifier: RecordingFileViewCell.identifier)
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
        designNavigationBar()
        setDelegate()
        fetchRecordFiles()
    }
    
    private func fetchRecordFiles() {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<[RecordResponse]?>.self, api: .fetchRecordFiles(imjangId: imjangId)) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                guard let response, let result = response.result, let fileList = result else { return }
                fileItems = fileList
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
        bottomSheetViewController.modalPresentationStyle = .custom
//        bottomSheetViewController.transitioningDelegate = self
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
    
    func showDeletePopup(indexPath: IndexPath) {
        let deletePopupVC = DeletePopupViewController()
        deletePopupVC.fileIndexPath = indexPath
        //deletePopupVC.fileName = fileItems[indexPath.row].name
        
        let fileURL = fileItems[indexPath.row].recordUrl
        deletePopupVC.fileName = fileItems[indexPath.row].recordName
        deletePopupVC.completionHandler = { [weak self] indexPath in
            guard let self else { return }
            fileItems.remove(at: indexPath.row)
            recordingFileTableView.deleteRows(at: [indexPath], with: .fade)
        }
        present(deletePopupVC, animated: true)
        deletePopupVC.modalPresentationStyle = .overCurrentContext
        
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
        // 새로운 뷰 컨트롤러를 생성하고 데이터를 전달합니다.
        let vc = BottomSheetViewController(imjangId: imjangId)
        vc.modalPresentationStyle = .custom
        
//        let playVC = PlayRecordViewController(recordResponse: <#RecordResponse#>)
//        playVC.bottomViewController.audioFile = recordings[indexPath.row].fileURL
//        playVC.bottomViewController.titleTextField.text = recordings[indexPath.row].title
//        playVC.bottomViewController.recordingIndexPath = indexPath
//        vc.transitionToViewController(playVC)
        
        // 새로운 뷰 컨트롤러를 present 합니다.
        present(vc, animated: true, completion: nil)
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
