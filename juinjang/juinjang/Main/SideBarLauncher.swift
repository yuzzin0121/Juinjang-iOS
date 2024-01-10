//
//  SideBarLauncher.swift
//  Juinjang
//
//  Created by 박도연 on 1/5/24.
//

import UIKit

class SideBar: NSObject {
    let name: SidebarComponents
    init(name: SidebarComponents) {
        self.name = name
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
}

