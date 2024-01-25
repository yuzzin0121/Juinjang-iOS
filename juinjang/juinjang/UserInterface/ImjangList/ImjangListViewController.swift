//
//  ImjangListViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/21/24.
//

import UIKit
import SnapKit
import Then

class ImjangListViewController: UIViewController {
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
    // 스크롤할 컨텐트뷰
    let contentView = UIView()
    
    // 임장 노트가 존재하지 않을 때의 뷰
    let emptyBackgroundView = UIView()
    let emptyLogoImageView = UIImageView()
    let emptyMessageLabel = UILabel()
    let newPageButton = UIButton()
    
    let clippingBackgroundView = UIView() 
    lazy var messageStackView = UIStackView()
    lazy var clipImageView = UIImageView()
    lazy var clipEmptyMessageLabel = UILabel()
    
    lazy var tableTopView = UIView()
    lazy var selectBtn: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        configuration.attributedTitle = AttributedString(filterArray[0].title, attributes: container)
        configuration.background.cornerRadius = 10
        configuration.baseBackgroundColor = ColorStyle.textWhite
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.setTitleColor(ColorStyle.darkGray, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.tintColor = ColorStyle.darkGray
        return button
    }()
    
    lazy var filterArray = Filter.allCases
    var isEmpty = false
    
    let imjangTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = ColorStyle.textWhite
//        tableView.contentInset = .init(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        tableView.register(ScrapCollectionTableViewCell.self, forCellReuseIdentifier: ScrapCollectionTableViewCell.identifier)
        tableView.register(ImjangNoteTableViewCell.self, forCellReuseIdentifier: ImjangNoteTableViewCell.identifier)
        return tableView
    }()
    
    let tableHeaderView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var scrapImjangList: [ImjangNote] = ImjangList.list
    let imjangList: [ImjangNote] = ImjangList.list
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designNavigationBar()
        addSubviews()
        designView()
        configureTableView()
        setEmptyConstraints()
        setConstraints()
    }
    
    func configureTableView() {
        imjangTableView.delegate = self
        imjangTableView.dataSource = self
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "님의 임장노트"     // TODO: - 나중에 nickname 으로 연결
        self.navigationController?.navigationBar.tintColor = .black
        // 이미지 로드
        let backImage = UIImage(named: "arrow-left")

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: nil)
        
        let addImage = ImageStyle.add
        let addButtonItem = UIBarButtonItem(image: addImage, style: .plain, target: self, action: nil)
        
        let searchImage = ImageStyle.search
        let searchButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(showSearchVC))

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItems = [addButtonItem, searchButtonItem]
    }
    
    @objc func showSearchVC() {
        let searchVC = ImjangSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func addSubviews() {
        view.addSubview(imjangTableView)
        view.addSubview(emptyBackgroundView)
        [emptyLogoImageView, emptyMessageLabel, newPageButton].forEach {
            emptyBackgroundView.addSubview($0)
        }
        
        contentView.addSubview(clippingBackgroundView)
        clippingBackgroundView.addSubview(messageStackView)
        
        if isEmpty == false {
            emptyBackgroundView.isHidden = true
        }
    }
    
    func designView() {
        view.backgroundColor = UIColor(named: "textWhite")
        
        // 비었을 때 로고 이미지뷰
        emptyLogoImageView.design(image: ImageStyle.logo,
                         contentMode: .scaleAspectFit)
        // 비었을 때 추가 권유 메시지 레이블
        emptyMessageLabel.design(text: "아직 등록된 집이 없어요\n지금 바로 부동산을 추가해 볼까요?", 
                                 textColor: ColorStyle.textGray,
                                 font: .pretendard(size: 16, weight: .semiBold),
                                 textAlignment: .center,
                                 numberOfLines: 0)
        emptyMessageLabel.setLineSpacing(spacing: 4)
        emptyMessageLabel.textAlignment = .center
        
        
        // 새 페이지 펼치기 버튼
        newPageButton.design(title: "새 페이지 펼치기",
                             font: .pretendard(size: 16, weight: .semiBold),
                             cornerRadius: 10)
        
        clipImageView.design(image: ImageStyle.bookmark, contentMode: .scaleAspectFit)
        clipEmptyMessageLabel.design(text: "버튼을 누르면 상단에 고정할 수 있어요",
                                     textColor: ColorStyle.null,
                                     font: .pretendard(size: 16, weight: .medium))
        
        setStackView(messageStackView, label: clipEmptyMessageLabel,
                     image: clipImageView, axis: .horizontal, spacing: 9, imageRight: false)
        
        DispatchQueue.main.async {
            self.clippingBackgroundView.applyGradientBackground()    // 스크랩 배경에 Gradient 추가
        }
    }
    
    func setConstraints() {
 
        clippingBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(contentView)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.15)
        }
    }
    
    func setEmptyConstraints() {
        imjangTableView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyBackgroundView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyLogoImageView.snp.makeConstraints {
            $0.centerX.equalTo(emptyBackgroundView)
            $0.width.height.equalTo(UIScreen.main.bounds.width * 0.4)
            $0.top.equalTo(emptyBackgroundView).offset(UIScreen.main.bounds.height * 0.25)
        }
        
        emptyMessageLabel.snp.makeConstraints {
            $0.leading.equalTo(emptyBackgroundView.snp.leading).offset(36)
            $0.trailing.equalTo(emptyBackgroundView.snp.trailing).offset(-36)
            $0.top.equalTo(emptyLogoImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(emptyBackgroundView)
            $0.height.equalTo(46)
        }
        
        newPageButton.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(52)
            $0.centerX.equalTo(emptyBackgroundView)
            $0.top.equalTo(emptyMessageLabel.snp.bottom).offset(118)
        }
        
        messageStackView.snp.makeConstraints {
            $0.centerY.equalTo(clippingBackgroundView)
            $0.centerX.equalTo(clippingBackgroundView)
        }
        
        clipImageView.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
        
        clipEmptyMessageLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }
    }

    
    // 스택뷰 설정
    func setStackView(_ stackView: UIStackView, label: UILabel, image: UIImageView, axis: NSLayoutConstraint.Axis, spacing: CGFloat, imageRight: Bool){
        
        stackView.axis = axis
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing
        
        if imageRight {
            [label, image].forEach {
                stackView.addArrangedSubview($0)
            }
        } else {
            [image, label].forEach {
                stackView.addArrangedSubview($0)
            }
        }
        
    }
    
}

extension ImjangListViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return imjangList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScrapCollectionTableViewCell.identifier, for: indexPath) as! ScrapCollectionTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImjangNoteTableViewCell.identifier, for: indexPath) as! ImjangNoteTableViewCell
            cell.selectionStyle = .none
            cell.configureCell(imjangNote: imjangList[indexPath.row])
            
            return cell
        default:
            print("오류")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 252
        } else {
            return 116
        }
    }
}

#Preview {
    ImjangListViewController()
}
