//
//  ScrapCollectionTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/25/24.
//

import UIKit
import SnapKit
import Then

class ScrapCollectionTableViewCell: UITableViewCell {
    var collectionView: UICollectionView = {    // 스크랩 CollectionView
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        let spacing = 44
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - (44 * 2), height: 198)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.applyGradientBackground()
        collectionView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.register(ScrapCollectionViewCell.self, forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // 디자인 설정
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentView)
            $0.verticalEdges.equalTo(contentView)
            $0.height.equalTo(252)
        }
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
}

