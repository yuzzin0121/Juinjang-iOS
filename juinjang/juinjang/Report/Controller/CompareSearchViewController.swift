
import UIKit
import Pageboy

class CompareSearchViewController: UIViewController {
    var searchBar = UISearchBar().then{
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.82, height: 0)
        $0.placeholder = "집 별명이나 주소를 검색해보세요"
        $0.searchTextField.font = .pretendard(size: 14, weight: .medium)
        $0.searchTextField.borderStyle = .roundedRect
        $0.searchTextField.clipsToBounds = true
        $0.searchTextField.layer.cornerRadius = 15
        //$0.setImage(ImageStyle.search, for: .clear, state: .normal)
    }
    
    let searchedTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 116
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = ColorStyle.textWhite
        tableView.isHidden = true
        tableView.register(ReportImjangListTableViewCell.self, forCellReuseIdentifier: ReportImjangListTableViewCell.identifier)
        return tableView
    }()
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "투명로고")
    }
    
    let mentLabel = UILabel().then {
        $0.text = "일치하는 매물이 없습니다."
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = UIColor(named: "450")
    }
    
    var applyBtn = UIButton().then{
        $0.backgroundColor = UIColor(named: "null")
        $0.layer.cornerRadius = 10
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.isHidden = true
    }
    
    var searchKeyword  = ""
    var searchedImjangList: [ImjangNote] = []
    var totalImjangList = ImjangList.list
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    func setData() {
        for item in totalImjangList {
            if item.roomName.contains(searchKeyword) || item.location.contains(searchKeyword) {
                searchedImjangList.append(item)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ self.view.endEditing(true)
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.tintColor = .black

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
    
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.titleView = searchBar
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func setupConstraints() {
        searchedTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        logoImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(243)
            $0.centerX.equalToSuperview()
        }
        mentLabel.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(37.17)
            $0.centerX.equalToSuperview()
        }
        applyBtn.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
    @objc func textFieldDidChange(_ sender: Any?) {
        if searchBar.searchTextField.text == "" {
            searchedTableView.isHidden = true
            applyBtn.isHidden = true
        } else {
            searchedTableView.isHidden = false
            applyBtn.isHidden = false
            //searchedTableView.reloadData()
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        hideKeyboardWhenTappedAround()
        //searching()
        
        view.backgroundColor = .white
        searchBar.delegate = self
        searchedTableView.delegate = self
        searchedTableView.dataSource = self
        
        view.addSubview(logoImageView)
        view.addSubview(mentLabel)
        view.addSubview(searchedTableView)
        view.addSubview(applyBtn)
        searchBar.searchTextField.addTarget(self, action: #selector(CompareSearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        applyBtn.addTarget(self, action: #selector(SelectMaemullViewController().applyBtnTap), for: .touchUpInside)
        setupConstraints()
    }
}

extension CompareSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalImjangList.count
        //searchedImjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportImjangListTableViewCell.identifier, for: indexPath) as! ReportImjangListTableViewCell
        
        cell.selectionStyle = .none
        cell.configureCell(imjangNote: totalImjangList[indexPath.row])
        //cell.configureCell(imjangNote: searchedImjangList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)!
        totalImjangList[indexPath.row].isSelected.toggle()
        if totalImjangList[indexPath.row].isSelected == true {
            cell.contentView.backgroundColor = UIColor(named: "main100")
            cell.contentView.layer.borderColor = UIColor(named: "juinjang")?.cgColor
            applyBtn.backgroundColor = UIColor(named: "500")
        }
        else {
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.borderColor = ColorStyle.strokeGray.cgColor
            applyBtn.backgroundColor = UIColor(named: "null")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

extension CompareSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text!
        if keyword.count < 2 {
            return
        }
        searchKeyword = searchBar.searchTextField.text!
        
        //view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
