//
//  ImjangSearchResultViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit

class ImjangSearchResultViewController: BaseViewController {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.82, height: 0))
        searchBar.placeholder = ""
        searchBar.searchTextField.borderStyle = .roundedRect
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.layer.cornerRadius = 15
        return searchBar
    }()
    
    let searchedTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 116
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = ColorStyle.textWhite
        tableView.register(ImjangNoteTableViewCell.self, forCellReuseIdentifier: ImjangNoteTableViewCell.identifier)
        return tableView
    }()
    
    let emptyImage: UIImageView = {
        let emptyImage = UIImageView()
        emptyImage.image = UIImage(named: "nomaemull")
        return emptyImage
    }()
    
    let emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = "일치하는 매물이 없어요"
        emptyLabel.font = .pretendard(size: 16, weight: .semiBold)
        emptyLabel.textColor = UIColor(named: "400")
        return emptyLabel
    }()
    
    var searchKeyword  = ""
    var searchedImjangList: [ListDto] = []
    var totalImjangList: [ListDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designNavigationBar()
        configureHierarchy()
        setupConstraints()
        designView()
        addSubView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchRequest()
    }
    
    func searchRequest() {
        if searchKeyword.count > 0 {
            JuinjangAPIManager.shared.fetchData(type: BaseResponse<TotalListDto>.self, api: .searchImjang(keyword: searchKeyword)) { response, error in
                if error == nil {
                    guard let response = response else { return }
                    guard let result = response.result else { return }
                    self.searchedImjangList = result.limjangList
                    self.emptyImage.isHidden = !self.searchedImjangList.isEmpty
                    self.emptyLabel.isHidden = !self.searchedImjangList.isEmpty
                    print("요청성공")
                    self.searchedTableView.reloadData()
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
    }
    
    // MARK: - addSubView()
    func addSubView() {
        [emptyImage, emptyLabel].forEach {
            view.addSubview($0)
        }
    }
    
    // 결과가 없을 때 배경
    func setConstraints() {
        emptyImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(108.83)
            $0.width.equalTo(105.56)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImage.snp.bottom).offset(34.17)
            $0.height.equalTo(22)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        let searchTextFieldItem = UIBarButtonItem(customView: searchBar)
    
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = searchTextFieldItem
    }
    
    func configureHierarchy() {
        view.addSubview(searchedTableView)
    }

    func designView() {
        view.backgroundColor = .white
        searchBar.placeholder = searchKeyword
        searchBar.delegate = self
        searchedTableView.delegate = self
        searchedTableView.dataSource = self
    }

    func setupConstraints() {
        searchedTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func bookMarkButtonClicked(sender: UIButton) {
        var imjangNote = searchedImjangList[sender.tag]
        imjangNote.isScraped.toggle()
        searchedImjangList[sender.tag] = imjangNote
        scrapRequest(imjangId: imjangNote.limjangId)
        searchedTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
    }
    func scrapRequest(imjangId: Int) {
        JuinjangAPIManager.shared.fetchData(type: NoResultResponse.self, api: .scrap(imjangId: imjangId)) { response, error in
            if error == nil {
                guard let response = response else { return }
                print(response.message)
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
    
    func saveSearchKeyword(keyword: String) {
        var keywordArray = UserDefaultManager.shared.searchKeywords
        
        if let index = keywordArray.firstIndex(where: { $0 == keyword }) {
            keywordArray.remove(at: index)
            keywordArray.insert(keyword, at: 0)
        } else {
            if keywordArray.count < 3 {
                keywordArray.insert(keyword, at: 0)
            }
        }
        
        UserDefaultManager.shared.searchKeywords = keywordArray
    }
}

extension ImjangSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedImjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImjangNoteTableViewCell.identifier, for: indexPath) as! ImjangNoteTableViewCell
        
        cell.selectionStyle = .none
        cell.configureCell(imjangNote: searchedImjangList[indexPath.row])
        cell.bookMarkButton.tag = indexPath.row
        cell.bookMarkButton.addTarget(self, action: #selector(bookMarkButtonClicked), for: .touchUpInside)
        
        return cell
    }
}

extension ImjangSearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        if text.count < 2 {
            return
        }
        saveSearchKeyword(keyword: text)
        searchKeyword = text
        searchRequest()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedImjangList = []
        searchedTableView.reloadData()
    }
    
}
