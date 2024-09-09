//
//  ImjangListHeaderView.swift
//  juinjang
//
//  Created by 조유진 on 1/26/24.
//

import UIKit
import SnapKit
import Then

class ImjangListHeaderView: UITableViewHeaderFooterView {
    
    let filterBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var filterselectBtn: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        configuration.attributedTitle = AttributedString(filterList[0].title, attributes: container)
        configuration.baseBackgroundColor = ColorStyle.textWhite
        configuration.baseForegroundColor = ColorStyle.darkGray
        configuration.image = ImageStyle.arrowDown
        configuration.image?.withTintColor(ColorStyle.darkGray)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }()
    let deleteButton = UIButton()
    var menuChildren: [UIMenuElement] = []
    let filterList = Filter.allCases
    weak var sendFilterItemDelegate: SendFilterItemDelegate?
    
    // MARK: - init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        setupConstraints()
        configureView()
        setFilterData()
    }
    
    func addFilterObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(setFilterButtonTitle), name: .imjangListFilterTapped, object: nil)
    }
    
    @objc private func setFilterButtonTitle(_ notification: Notification) {
        guard let titleDict = notification.userInfo as? [String: String], let title = titleDict["title"] else { return }
        changefilterTitle(title)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Data
    func setFilterData() {
        for filter in filterList {
            menuChildren.append(UIAction(title: filter.title, state: .off,handler: {  (action: UIAction) in
                self.changefilterTitle(filter.title)
                self.callRequestFiltered(filterItem: filter)
            }))
        }
        if #available(iOS 17.0, *) {
            filterselectBtn.menu = UIMenu(options: .displayAsPalette, preferredElementSize: .small ,children: menuChildren)
        } else if #available(iOS 16.0, *){
            filterselectBtn.menu = UIMenu(options: .displayInline, preferredElementSize: .small ,children: menuChildren)
        } else {
            filterselectBtn.menu = UIMenu(options: .destructive, children: menuChildren)
        }
        
        filterselectBtn.showsMenuAsPrimaryAction = true
    }
    
    func callRequestFiltered(filterItem: Filter) {
        sendFilterItemDelegate?.sendFilterItem(filter: filterItem)
    }
    
    func changefilterTitle(_ title: String) {
        var container = AttributeContainer()
        container.font = .pretendard(size: 14, weight: .semiBold)
        filterselectBtn.configuration?.title = title
        filterselectBtn.configuration?.attributedTitle = AttributedString(title, attributes: container)
    }
    
    func configureHierarchy() {
        // 스크랩 없을 때
//        [clippingEmptyBackgroundView, filterBackgroundView].forEach {
//            contentView.addSubview($0)
//        }
//        [clipImageView, clipEmptyMessageLabel].forEach {
//            messageStackView.addArrangedSubview($0)
//        }
//        clippingEmptyBackgroundView.addSubview(messageStackView)
//        clippingEmptyBackgroundView.addSubview(collectionView)
        addSubview(filterBackgroundView)
        filterBackgroundView.addSubview(filterselectBtn)
        filterBackgroundView.addSubview(deleteButton)
//        collectionView.isHidden = true  // 초기값
        // 스크랩 있을 때: 1. backgroundView 숨기기 2. 고정된 높이의 collectionView 보이게 하기 + gradient 추가
        // 아니면 1. backgroundView 높이를 높이고, 2. label을 없애기
        // 스택뷰를 사용하는게 좋을까,,?
    }
    
    func configureView(){
        backgroundColor = .white
        deleteButton.design(image: ImageStyle.trash, backgroundColor: .clear)

    }
    
    func setupConstraints() {
        filterBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(49)
        }
        filterselectBtn.snp.makeConstraints {
            $0.centerY.equalTo(filterBackgroundView)
            $0.leading.equalToSuperview().offset(16)
        }
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(filterBackgroundView)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(22)
        }
    }

}

//extension ImjangListHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        scrapedList.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapCollectionViewCell.identifier, for: indexPath) as! ScrapCollectionViewCell
//        
//        cell.bookMarkButton.tag = indexPath.row
//        cell.setData(imjangNote: scrapedList[indexPath.row])
//        cell.bookMarkButton.addTarget(self, action: #selector(bookMarkButtonClicked), for: .touchUpInside)
//        
//        return cell
//    }
//    
//    
//}

//var currentIndex = 0
//
//extension ImjangListHeaderView: UICollectionViewDelegateFlowLayout {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
//        let cellWidth = Const.bigItemSize.width + Const.itemSpacing
//        let index = round(scrolledOffsetX / cellWidth)
//        currentIndex = Int(index)
////        print(index)
//        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left,
//                                              y: scrollView.contentInset.top)
//        self.collectionView.reloadData()
//    }
//}
//
//extension ImjangListHeaderView {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//        
//        let cellWidthIncludeSpacing = Const.smallItemSize.width + Const.itemSpacing
//        let offsetX = collectionView.contentOffset.x
//        let index = (offsetX + collectionView.contentInset.left) / cellWidthIncludeSpacing
//        let roundedIndex = round(index)
//        print(roundedIndex)
//        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            animateZoomforCell(zoomCell: cell)
//        }
//        if Int(roundedIndex) != Const.previousIndex {
//            let preIndexPath = IndexPath(item: Const.previousIndex, section: 0)
//           if let preCell = collectionView.cellForItem(at: preIndexPath) {
//               animateZoomforCellremove(zoomCell: preCell)
//           }
//            Const.previousIndex = indexPath.item
//       }
//    }
//    
//    func animateZoomforCell(zoomCell: UICollectionViewCell) {
//        UIView.animate(
//            withDuration: 0.2,
//            delay: 0,
//            options: .curveEaseOut,
//            animations: {
//                zoomCell.transform = .identity
//        },
//            completion: nil)
//    }
//    
//    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
//        UIView.animate(
//            withDuration: 0.2,
//            delay: 0,
//            options: .curveEaseOut,
//            animations: {
//                zoomCell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        },
//            completion: nil)
//    }
//}
