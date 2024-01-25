//
//  ImjangSearchViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/24/24.
//

import UIKit

class ImjangSearchViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        configureSearchBar()
        designView()
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.tintColor = .black

        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: nil)
    
        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    func configureSearchBar() {
        searchController.searchBar.placeholder = "집 별명이나 주소를 검색해보세요"
        searchController.searchBar.barStyle = .default
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = .lightGray
        searchController.searchBar.searchTextField.backgroundColor = ColorStyle.shadowGray
    }
    
    func designView() {
        view.backgroundColor = ColorStyle.textWhite
    }

}

extension ImjangSearchViewController: UISearchBarDelegate {
    
}

#Preview {
    ImjangSearchViewController()
}
