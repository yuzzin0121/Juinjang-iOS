//
//  ImjangImageListViewController.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit
import SnapKit

class ImjangImageListViewController: UIViewController {
    let noImageBackgroundView = UIView()
    let noImageStackView = UIStackView()
    let galleryImageView = UIImageView()
    let noImageMessageLabel = UILabel()
    
    lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    var imageList: [String] = ["1", "2", "3"]  // 일단 String 배열

    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        checkImage()
        configureCollectionView()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addImage() { // + 버튼 눌렀을 때 -> 이미지 추가
        
    }
    
    func checkImage() {
        if imageList.isEmpty {
            setEmptyLayout(true)
        } else {
            setEmptyLayout(false)
        }
    }
    
    func setEmptyLayout(_ isEmpty: Bool) {
        if isEmpty {
            imageCollectionView.isHidden = true
            noImageBackgroundView.isHidden = false
        } else {
            imageCollectionView.isHidden = false
            noImageBackgroundView.isHidden = true
        }
    }
    
    func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let size = (UIScreen.main.bounds.width - 48) - spacing*2
        layout.itemSize = CGSize(width: size/3, height: size/3)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        return layout
    }
    
    // 네비게이션 바 디자인
    func designNavigationBar() {
        self.navigationItem.title = "사진 목록"     // TODO: - 나중에 roomName 으로 연결
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        // UIBarButtonItem 생성 및 이미지 설정
        let backButtonItem = UIBarButtonItem(image: ImageStyle.arrowLeft, style: .plain, target: self, action: #selector(popView))
       
        let addButtonItem = UIBarButtonItem(image: ImageStyle.add, style: .plain, target: self, action: #selector(addImage))
        addButtonItem.tintColor = ColorStyle.darkGray

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = addButtonItem
    }
    
    func configureHierarchy() {
        view.addSubview(noImageBackgroundView)
        view.addSubview(imageCollectionView)
        noImageBackgroundView.addSubview(noImageStackView)
        [galleryImageView, noImageMessageLabel].forEach {
            noImageStackView.addArrangedSubview($0)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        
        imageCollectionView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        noImageBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noImageStackView.snp.makeConstraints {
            $0.center.equalTo(noImageBackgroundView)
            $0.width.equalTo(200)
        }
        
        galleryImageView.snp.makeConstraints {
            $0.size.equalTo(117)
        }
        
        noImageMessageLabel.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
    }
    
    func configureView() {
        noImageStackView.design(axis: .vertical, spacing: 26)
        galleryImageView.design(image: ImageStyle.gallery, contentMode: .scaleAspectFit)
        noImageMessageLabel.design(text: "아직 등록된 사진이 없어요\n사진을 추가해 볼까요?", 
                                   textColor: ColorStyle.gray1,
                                   font: .pretendard(size: 18, weight: .medium),
                                   numberOfLines: 2)
        noImageMessageLabel.setLineSpacing(spacing: 4)
        noImageMessageLabel.textAlignment = .center
    }
}

extension ImjangImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: imageList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        showEnlargePhotoVC(index: index, photoList: imageList)
    }
    
    func showEnlargePhotoVC(index: Int, photoList: [String]) {
        let enlargePhotoVC = EnlargePhotoViewController()
        enlargePhotoVC.currentIndex = index
        enlargePhotoVC.photoList = photoList
        enlargePhotoVC.modalPresentationStyle = .overFullScreen
        present(enlargePhotoVC, animated: false)
    }
    
}
