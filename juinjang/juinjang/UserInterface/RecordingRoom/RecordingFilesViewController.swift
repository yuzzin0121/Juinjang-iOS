//
//  RecordingFilesViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit
import AVFoundation
var recordings: [Recording] = []

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
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.separatorInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        $0.register(RecordingFileViewCell.self, forCellReuseIdentifier: RecordingFileViewCell.identifier)
    }
    
    var recordings: [Recording] = []
    //var fileURLs : [URL] = []
    //var fileItems: [RecordingFileItem] = []
    
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
        //setItemData()
        loadRecordings()
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
//        let vc = ImjangNoteViewController()
//        navigationController?.pushViewController(vc, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func startRecording(_ sender: Any) {
        let bottomSheetViewController = BottomSheetViewController(imjangId: imjangId)
        bottomSheetViewController.modalPresentationStyle = .custom
//        bottomSheetViewController.transitioningDelegate = self
        self.present(bottomSheetViewController, animated: false, completion: nil)
    }
    
//    func setItemData() {
//        fileItems.append(contentsOf: [
//            .init(name: "보일러 관련", recordedDate: Date(), recordedTime: "1:30"),
//            .init(name: "화장실 관련", recordedDate: Date(), recordedTime: "1:50"),
//            .init(name: "인테리어 관련", recordedDate: Date(), recordedTime: "4:20"),
//            .init(name: "계약 관련", recordedDate: Date(), recordedTime: "4:20"),
//        ])
//        
//        if fileItems.isEmpty {
//            recordingFileTableView.isHidden = true
//        }
//        
//        recordingFileTableView.reloadData()
//    }
    
    func loadRecordings() {
        clearRecordingDirectory()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let existingRecordingsDict = Dictionary(uniqueKeysWithValues: recordings.map { ($0.fileURL, $0.title) })

                do {
                    let recordingURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
                    recordings = recordingURLs.filter { $0.pathExtension == "m4a" }.map { url in
                        let title = existingRecordingsDict[url] ?? url.lastPathComponent
                        return Recording(title: title, fileURL: url)
                    }
                } catch {
                    print("Error loading recordings: \(error)")
                }
//        do {
//           // 문서 디렉토리에서 녹음 파일들을 가져옴
//            let recordingURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
//           
//           // 녹음 파일 목록에 추가
//            recordings = recordingURLs.filter { $0.pathExtension == "m4a" }.map {Recording(title: $0.lastPathComponent, fileURL: $0)} //.sorted(by: { $0.absoluteString > $1.absoluteString }) // .m4a 확장자를 가진 파일만 필터링
//        } catch {
//            print("Failed to load recordings: \(error)")
//        }

       // UITableView 새로고침
        recordingFileTableView.reloadData()
   }
    func clearRecordingDirectory() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLsInDirectory = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            for fileURL in fileURLsInDirectory {
                try fileManager.removeItem(at: fileURL)
            }
            print("Recording directory cleared successfully.")
        } catch {
            print("Failed to clear recording directory: \(error)")
        }
    }
    func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(recordingFileTableView)
    }
    
    func setConstraints() {
        // 스크롤뷰
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 컨텐트뷰
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(view).multipliedBy(1.1)
        }
        
        recordingFileTableView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(contentView)
        }
    }
    
    func showDeletePopup(indexPath: IndexPath) {
        let deletePopupVC = DeletePopupViewController()
        deletePopupVC.fileIndexPath = indexPath
        //deletePopupVC.fileName = fileItems[indexPath.row].name
        
        let fileURL = recordings[indexPath.row].fileURL
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting file: \(error)")
        }
        deletePopupVC.fileName = recordings[indexPath.row].title
        deletePopupVC.completionHandler = { [weak self] indexPath in
            guard let self else { return }
            recordings.remove(at: indexPath.row)
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
        //return fileItems.count
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordingFileViewCell.identifier, for: indexPath) as? RecordingFileViewCell else { return UITableViewCell() }
        let recording = recordings[indexPath.row]
//        let playVC = PlayRecordViewController()
//        playVC.bottomViewController.audioFile = recording.fileURL
//        playVC.bottomViewController.initPlay1()
        cell.selectionStyle = .none

        //cell.setData(fileItem: fileURLs[indexPath.row])
//        cell.setData(fileTitle: "\(recording.title)", time: "\(playVC.bottomViewController.remainingTimeLabel.text ?? "0:00")", date: recordTime)
        //cell.recordingFileNameLabel.text = fileURLs[indexPath.row].lastPathComponent

//        cell.setData(fileTitle: "\(recording.title)", time: "\(playVC.bottomViewController.remainingTimeLabel.text ?? "0:00")", date: recordTime)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 새로운 뷰 컨트롤러를 생성하고 데이터를 전달합니다.
        let vc = BottomSheetViewController(imjangId: imjangId)
        vc.modalPresentationStyle = .custom
        
        let playVC = PlayRecordViewController()
        playVC.bottomViewController.audioFile = recordings[indexPath.row].fileURL
        playVC.bottomViewController.titleTextField.text = recordings[indexPath.row].title
        playVC.bottomViewController.recordingIndexPath = indexPath
        vc.transitionToViewController(playVC)
        
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
    func playRecordViewControllerDidDismiss(_ controller: PlayRecordViewController) {
        recordingFileTableView.reloadData()
    }
}
