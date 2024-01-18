//
//  InitialCheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/18/24.
//

import UIKit
import SnapKit

class InitialCheckListViewController: UIViewController {
    
    lazy var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    lazy var contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var completedButton = UIButton().then {
        $0.setImage(UIImage(named: "completed-button"), for: .normal)
    }
    
    lazy var progressBar = UIProgressView().then {
        $0.trackTintColor = UIColor(named: "white0")
        $0.progressTintColor = UIColor(named: "mainOrange")
        $0.progress = 0.3
    }
    
    lazy var checklistInfoImage = UIImageView().then {
        $0.image = UIImage(named: "checklist-info")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
    }
    
    var CategoryItems: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        designNavigationBar()
        addSubViews()
        setupLayout()
        setItemData()
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "판교푸르지오월드마크"     // TODO: - 나중에 roomName 으로 연결
        self.navigationController?.navigationBar.tintColor = .black
        // 이미지 로드
        let backImage = UIImage(named: "arrow-left")

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: nil)
        let savetemporarilyButtonItem = UIBarButtonItem(title: "임시저장", style: .plain, target: self, action: nil)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = savetemporarilyButtonItem
    }
    
    func addSubViews() {
        [scrollView,
         completedButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [progressBar,
        checklistInfoImage,
        checklistInfoImage,
        tableView].forEach { contentView.addSubview($0) }
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(view.snp.height).multipliedBy(1.1)
        }
        
        completedButton.snp.makeConstraints {
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-26)
            $0.bottom.equalTo(view.snp.bottom).offset(-26)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        view.bringSubviewToFront(completedButton)
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(22)
            $0.leading.equalTo(contentView.snp.leading).offset(24)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-24)
        }
        
        checklistInfoImage.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(checklistInfoImage.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(63*4)
        }
    }
    
    func setItemData() {
        CategoryItems.append(contentsOf: [
            .init(image: UIImage(named: "deadline-item")!, name: "기한", items: []),
            .init(image: UIImage(named: "location-conditions-item")!, name: "입지여건", items: []),
            .init(image: UIImage(named: "public-space-item")!, name: "공용공간", items: []),
            .init(image: UIImage(named: "indoor-item")!, name: "실내", items: []),
        ])
    }
}

extension InitialCheckListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as? CategoryItemTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
}
