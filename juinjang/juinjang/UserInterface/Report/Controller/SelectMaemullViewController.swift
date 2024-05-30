//
//  SelectMaemullViewController.swift
//  juinjang
//
//  Created by 박도연 on 1/31/24.
//
import UIKit
import Then
import SnapKit

class SelectMaemullViewController : BaseViewController {
    
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
    var imjangList: [ListDto] = []
    
    let tableView = UITableView().then {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
        $0.register(ReportImjangListTableViewCell.self, forCellReuseIdentifier: ReportImjangListTableViewCell.identifier)
    }
    
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
    
    func callRequest(sort: Filter = .update, setScrap: Bool = false, excludingId: Int? = nil) {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .totalImjang(sort: sort.sortValue)) { response, error in
            if error == nil {
                guard let response = response else { return }
                guard let result = response.result else { return }
                
                // 특정 limjangId를 제외한 리스트를 생성
                let filteredList = result.limjangList.filter { item in
                    if let excludingId = excludingId {
                        return item.limjangId != excludingId
                    }
                    return true
                }
                self.imjangList = filteredList
                print("나의 임장들 \(result)")
                //self.imjangList = result.limjangList
                self.setEmptyUI(isEmpty: self.imjangList.isEmpty)
                self.tableView.reloadData()
            } else {
                guard let error else { return }
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
    func setEmptyUI(isEmpty: Bool) {
        //emptyBackgroundView.isHidden = isEmpty ? false : true
        tableView.isHidden = isEmpty ? true : false
    }
    
    func setConstraint() {
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
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(btnBackGroundView.snp.top)
        }
        
    }
    
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "비교할 매물 고르기"

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .plain, target: self, action: #selector(backBtnTap))
        backButtonItem.tintColor = UIColor(named: "300")
        backButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        let searchButtonItem = UIBarButtonItem(image: UIImage(named:"search"), style: .plain, target: self, action: #selector(searchBtnTap))
        searchButtonItem.tintColor = UIColor(named: "300")
        searchButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }
    @objc func backBtnTap() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func searchBtnTap() {
        let searchVC = CompareSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    @objc func applyBtnTap() {
        let vc = ReportViewController()
        vc.tabViewController.index = 1
        vc.tabViewController.compareVC.isCompared = true
        vc.tabViewController.compareVC.compareDataSet2.fillAlpha = CGFloat(0.8)
        vc.tabViewController.compareVC.compareDataSet2.fillColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        callRequest(setScrap: true, excludingId: 9)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        
        view.addSubview(contentView)
        contentView.addSubview(filterselectBtn)
        view.addSubview(tableView)
        
        view.addSubview(btnBackGroundView)
        btnBackGroundView.addSubview(applyBtn)
        //applyBtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        
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
        let cell = tableView.cellForRow(at: indexPath) as! ReportImjangListTableViewCell
        if cell.isSelect == false {
            cell.isSelect = true
            cell.contentView.backgroundColor = UIColor(named: "main100")
            cell.contentView.layer.borderColor = ColorStyle.mainOrange.cgColor
            applyBtn.backgroundColor = UIColor(named: "500")
            applyBtn.addTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        }
        else {
            cell.isSelect = false
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.borderColor = ColorStyle.strokeGray.cgColor
            applyBtn.backgroundColor = UIColor(named: "null")
            applyBtn.removeTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReportImjangListTableViewCell
        cell.isSelect = false
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.borderColor = ColorStyle.strokeGray.cgColor
        applyBtn.backgroundColor = UIColor(named: "null")
        applyBtn.removeTarget(self, action: #selector(applyBtnTap), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }

}


