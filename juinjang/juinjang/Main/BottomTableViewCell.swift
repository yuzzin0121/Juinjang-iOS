//
//  BottomTableViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 12/31/23.
//

import UIKit
import SnapKit
import Then

class BottomTableViewCell: UITableViewCell{
    static let identifier = "BottomTableViewCell"
    static let cellHeight = 250.0
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cv.alpha = 0.0
        cv.backgroundColor = .clear
        return cv
    }()
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate : UICollectionViewDelegate & UICollectionViewDataSource, forRow row: Int){
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        //collectionView.reloadData()  //재부팅
    }
    
    /*let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 12
        $0.collectionViewLayout = layout
        $0.backgroundColor = .red
    }*/
    
    //MARK: - 최근 본 임장
    var recentImjangLabel = UILabel().then {
        $0.text = "최근 본 임장"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
        ///$0.alpha = 0.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
        
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
        
    private func addContentView() {
        self.contentView.addSubview(self.recentImjangLabel)
        self.contentView.addSubview(collectionView)
    }
        
    private func autoLayout() {
        recentImjangLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(24)
        }
        
        UIView.animate(withDuration: 1.5, delay: 1.2, options: .curveEaseIn, animations: {
            self.recentImjangLabel.alpha = 1.0
        }, completion: nil)
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(recentImjangLabel.snp.bottom).offset(15)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(204)
        }
        
        UIView.animate(withDuration: 1.5, delay: 1.4, options: .curveEaseIn, animations: {
            self.collectionView.alpha = 1.0
        }, completion: nil)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

