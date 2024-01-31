//
//  SelectMaemullViewController.swift
//  juinjang
//
//  Created by 박도연 on 1/31/24.
//
import UIKit
import Then
import SnapKit

class SelectMaemullViewController : UIViewController {
    
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "비교할 매물 고르기"

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .plain, target: self, action: #selector(backBtnTap))
        
        let searchButtonItem = UIBarButtonItem(image: UIImage(named:"search"), style: .plain, target: self, action: nil)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }
    @objc
    func backBtnTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*var backButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"leftArrow"), for: .normal)
        $0.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
    }
    
    var compareLabel = UILabel().then {
        $0.text = "비교할 매물 고르기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var searchButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"search"), for: .normal)
    }*/
    
    var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var filterselectBtn: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = .pretendard(size:14, weight: .semiBold)
        configuration.attributedTitle = AttributedString(filterList[0].title, attributes: container)
        configuration.imagePadding = 2
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.setTitleColor(ColorStyle.darkGray, for: .normal)
        button.setImage(ImageStyle.arrowDown, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .leading
        button.tintColor = .white
        return button
    }()
    
    var menuChildren: [UIMenuElement] = []
    lazy var filterList = Filter.allCases
    var imjangList: [ImjangNote] = ImjangList.list
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
        tableView.register(ReportImjangListTableViewCell.self, forCellReuseIdentifier: ReportImjangListTableViewCell.identifier)
        return tableView
    }()
    
    var btnBackGroundView = UIView().then{
        $0.backgroundColor = .white
    }
    
    var applyBtn = UIButton().then{
        $0.backgroundColor = UIColor(named: "null")
        $0.layer.cornerRadius = 10
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(UIColor.white, for: .normal)
        
    }
    @objc
    func applyBtnTap(_ sender: UIButton) {
        let vc = ReportViewController()
        vc.modalPresentationStyle = .overFullScreen
       // vc.tabViewController.defaultPage(for: CompareViewController())
        self.present(vc, animated: false)
    }
    
    func setFilterData() {
        for filter in filterList {
            menuChildren.append(UIAction(title: filter.title, state: .off,handler: {  (action: UIAction) in
                self.changefilterTitle(filter.title)
                self.callRequestFiltered(sort: filter.title)
            }))
        }
        filterselectBtn.menu = UIMenu(options: .displayAsPalette, children: menuChildren)
        
        filterselectBtn.showsMenuAsPrimaryAction = true
    }
    func changefilterTitle(_ title: String) {
        filterselectBtn.setTitle(title, for: .normal)
        filterselectBtn.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    func callRequestFiltered(sort: String) {
        
    }
    
    func setConstraint() {
        /*backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13.16)
            $0.left.equalToSuperview().inset(24)
            $0.width.height.equalTo(22)
        }
        compareLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.16)
            $0.centerX.equalToSuperview()
        }
        searchButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13.16)
            $0.right.equalToSuperview().inset(24)
            $0.width.height.equalTo(22)
        }*/
        btnBackGroundView.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(97)
        }
        applyBtn.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        contentView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(63)
        }
        filterselectBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(32)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(19)
            //$0.width.equalTo(73.3)
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(btnBackGroundView.snp.top)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        
        //view.addSubview(backButton)
        //view.addSubview(compareLabel)
        //view.addSubview(searchButton)
        view.addSubview(contentView)
        contentView.addSubview(filterselectBtn)
        view.addSubview(tableView)
        
        view.addSubview(btnBackGroundView)
        btnBackGroundView.addSubview(applyBtn)
        applyBtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        
        setFilterData()
        setConstraint()
    }
}

extension SelectMaemullViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportImjangListTableViewCell.identifier, for: indexPath) as! ReportImjangListTableViewCell
        cell.selectionStyle = .none
        cell.configureCell(imjangNote: imjangList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = tableView.cellForRow(at: indexPath as IndexPath)!
        cell.contentView.backgroundColor = UIColor(named: "main100")
        cell.contentView.layer.borderColor = UIColor(named: "juinjang")?.cgColor
        applyBtn.backgroundColor = UIColor(named: "500")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }

}


