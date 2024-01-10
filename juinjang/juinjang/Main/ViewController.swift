//
//  ViewController.swift
//  Juinjang
//
//  Created by 박도연 on 12/29/23.
//

import UIKit
import SnapKit
import Then


class ViewController: UIViewController {
    
    let tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TopTableViewCell.self, forCellReuseIdentifier: TopTableViewCell.identifier)
        $0.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.identifier)
    }
    
    // MARK: - 상단바
    var isSlideInMenuPresented = false
    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.30
    var hambergerButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"hamberger"), for: .normal)
        $0.addTarget(self, action: #selector(hambergerButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func hambergerButtonTapped(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.menuView.frame.origin.x = self.isSlideInMenuPresented ? -300 : 0
        } completion: { (finished) in
            print("Animation finished: \(finished)")
            self.isSlideInMenuPresented.toggle()
        }
    }
    
    var menuView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var speakerButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"speaker"), for: .normal)
    }
    
    var mainLogoImageView = UIImageView().then {
        $0.image = UIImage(named:"mainLogo")
    }

    // MARK: - 배경
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named:"backgroundshape")
        $0.alpha = 0.0
    }
    
    func setConstraint() {
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(hambergerButton.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        //MARK: - 상단바
        hambergerButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.16)
            $0.height.equalTo(24)
            $0.left.equalToSuperview().offset(26.73)
        }
        
        mainLogoImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.16)
            $0.height.equalTo(21)
            $0.centerX.equalToSuperview()
        }
        
        speakerButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.16)
            $0.height.equalTo(24)
            $0.right.equalToSuperview().inset(26.55)
        }
        
        //MARK: - 배경
        backgroundImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(21.82)
            $0.left.right.equalToSuperview()
        }
        
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.backgroundImageView.alpha = 1.0
        }, completion: nil)
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 710
        tableView.backgroundColor = .clear
        
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        view.addSubview(hambergerButton)
        view.addSubview(speakerButton)
        view.addSubview(mainLogoImageView)
        view.addSubview(tableView)
        menuView.pinMenuTo(view, with: slideInMenuPadding)
        setConstraint()
    }

}

extension UIView {
    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34.16).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -constant*3).isActive = true
        trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopTableViewCell", for: indexPath) as? TopTableViewCell
            else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BottomTableViewCell", for: indexPath) as? BottomTableViewCell
            else{
                return UITableViewCell()
            }
            //cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        } else {
            return BottomTableViewCell.cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        guard let tableViewCell = cell as? BottomTableViewCell else {
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}
     
     
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return 5
     }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCollectionViewCell", for: indexPath) as?
                BottomCollectionViewCell else{
            return UICollectionViewCell()
     }
        return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 143 , height: 204)
     }
}

