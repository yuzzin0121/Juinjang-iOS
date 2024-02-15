//
//  ImjangImageListViewController.swift
//  juinjang
//
//  Created by 조유진 on 2/2/24.
//

import UIKit
import SnapKit
import PhotosUI

class ImjangImageListViewController: UIViewController {
    let noImageBackgroundView = UIView()
    let noImageStackView = UIStackView()
    let galleryImageView = UIImageView()
    let noImageMessageLabel = UILabel()
    
    let imagePicker = UIImagePickerController()
    
    lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    var imageList: [String] = ["1", "2", "3"]  // 일단 String 배열
    var imageArr: [UIImage?] = []
    
    var isLongTap: Bool = false
    var selectedIndexs: Set<Int> = []
    var imjangId: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        checkImage()
        configureCollectionView()
        configureHierarchy()
        imagePicker.delegate = self
        configureLayout()
        configureView()
    }
    
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addImage() { // + 버튼 눌렀을 때 -> 이미지 추가
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
//        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let library =  UIAlertAction(title: "앨범에서 가져오기", style: .default) { (action) in self.openLibrary() }
//        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera() }
//        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        alert.addAction(library)
//        alert.addAction(camera)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
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
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: imageCollectionView)
        
        switch gesture.state {
        case .began, .changed:
            // 위치에 해당하는 셀의 인덱스 패스 찾기
            guard let indexPath = imageCollectionView.indexPathForItem(at: location) else { return }
            // 해당 셀을 선택 상태로 변경
            isLongTap = true
            selectedIndexs.insert(indexPath.row)
            imageCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            // UICollectionViewDelegate 메서드를 수동으로 호출하여 선택을 처리
            imageCollectionView.delegate?.collectionView?(imageCollectionView, didSelectItemAt: indexPath)
        case .ended:
            // 드래그 종료 시 필요한 작업 수행
            break
        default:
            break
        }
    }
    
    func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        imageCollectionView.addGestureRecognizer(panGesture)
        imageCollectionView.allowsMultipleSelection = true
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
       
        let deleteImageButtonItem = UIBarButtonItem(image: ImageStyle.trash, style: .plain, target: self, action: #selector(deleteImages))
        let addButtonItem = UIBarButtonItem(image: ImageStyle.add, style: .plain, target: self, action: #selector(addImage))
        addButtonItem.tintColor = ColorStyle.darkGray

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItems = [addButtonItem, deleteImageButtonItem]
    }
    
    @objc func deleteImages() {
        // 선택된 인덱스에 해당하는 요소를 배열에서 삭제
        if selectedIndexs.isEmpty {
            return
        }
        
        print("우잉")
        let deletePopupVC = DeleteImjangImagePopupView()
        deletePopupVC.selectedCount = selectedIndexs.count
        deletePopupVC.modalPresentationStyle = .overFullScreen
        deletePopupVC.completionHandler = {
            self.selectedIndexs.sorted(by: >)
            for index in self.selectedIndexs {
                if index < self.imageList.count {
                    self.imageList.remove(at: index)
                }
            }
            self.imageCollectionView.reloadData()
        }
        present(deletePopupVC, animated: false)
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
    
    func showEnlargePhotoVC(index: Int, photoList: [String]) {
        let enlargePhotoVC = EnlargePhotoViewController()
        enlargePhotoVC.currentIndex = index
        enlargePhotoVC.photoList = photoList
        enlargePhotoVC.modalPresentationStyle = .overFullScreen
        present(enlargePhotoVC, animated: false)
    }
    
    // imagePicker로 화면 전환
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)
    }
    func openCamera(){
        imagePicker.sourceType = .camera
        present(imagePicker, animated: false, completion: nil)
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
        if isLongTap {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = ColorStyle.mainStrokeOrange?.cgColor
            isLongTap = false
        } else {
            showEnlargePhotoVC(index: index, photoList: imageList)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // 선택 해제된 셀의 시각적 강조 해제, 예를 들면 배경색을 원래대로
        cell.contentView.layer.borderWidth = 0
        selectedIndexs.sorted(by: >)
        for index in selectedIndexs {
            if index < imageList.count {
                imageList.remove(at: index)
            }
        }
    }
}

extension ImjangImageListViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                self.imageArr.append(image as? UIImage ?? nil)
            }
        } else {
            print("이미지 가져오기 실패")
        }
    }
    
    
}

extension ImjangImageListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
        }
        dismiss(animated: true, completion: nil)
    }
}
