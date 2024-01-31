//
//  DeleteImjangViewController.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit
import Then
import SnapKit

class DeleteImjangViewController: UIViewController {
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*0.6, height: 24)).then {
        $0.text = "삭제할 페이지를 선택해주세요"
        $0.font = .pretendard(size: 16, weight: .semiBold)
        $0.textColor = ColorStyle.textGray
        $0.textAlignment = .center
    }
    
    let deleteImjangTableView = UITableView()
    let deleteButtonBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    let deleteButton = UIButton()
    
    var imjangList: [ImjangNote] = ImjangList.list
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designNavigationBar()
        configureTableView()
        configureHierarchy()
        configureLayout()
        configureView()
        deleteImjangTableView.reloadData()
    }
    
    func configureTableView() {
        deleteImjangTableView.delegate = self
        deleteImjangTableView.dataSource = self
        deleteImjangTableView.rowHeight = 116
        deleteImjangTableView.separatorStyle = .none
        deleteImjangTableView.showsVerticalScrollIndicator = false
        deleteImjangTableView.sectionHeaderTopPadding = 0
        deleteImjangTableView.register(DeleteImjangTableHeaderView.self, forHeaderFooterViewReuseIdentifier: DeleteImjangTableHeaderView.identifier)
        deleteImjangTableView.register(DeleteImjangNoteTableViewCell.self, forCellReuseIdentifier: DeleteImjangNoteTableViewCell.identifier)
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = .black

        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
      
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(deleteImjangTableView)
        view.addSubview(deleteButtonBackgroundView)
        deleteButtonBackgroundView.addSubview(deleteButton)
    }
    
    func configureLayout() {
        deleteImjangTableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(deleteButtonBackgroundView.snp.top)
        }
        
        deleteButtonBackgroundView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view)
            $0.height.equalTo(98)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(deleteButtonBackgroundView.snp.top).offset(12)
            $0.horizontalEdges.equalTo(deleteButtonBackgroundView).inset(24)
            $0.bottom.equalTo(deleteButtonBackgroundView.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        deleteButton.design(title: "삭제하기", 
                            font: .pretendard(size: 16, weight: .semiBold),
                            backgroundColor: ColorStyle.null,
                            cornerRadius: 10)
    }
    
    @objc func removeAllCheckButtonClicked() {
        
    }
}

extension DeleteImjangViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DeleteImjangTableHeaderView.identifier) as? DeleteImjangTableHeaderView else {
            return UITableViewHeaderFooterView()
        }
        
        headerView.selectedCountLabel.text = "0개 선택됨"   // 개수 변경 필요
        headerView.removeAllCheckButton.addTarget(self, action: #selector(removeAllCheckButtonClicked), for: .touchUpInside)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imjangList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeleteImjangNoteTableViewCell.identifier, for: indexPath) as? DeleteImjangNoteTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none

        cell.configureCell(imjangNote: imjangList[indexPath.row])
        cell.checkButton.tag = indexPath.row
        
        return cell
    }
    
    
}
