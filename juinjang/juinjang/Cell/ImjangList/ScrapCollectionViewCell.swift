//
//  ScrapCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/26/24.
//

import UIKit
import Then

class ScrapCollectionViewCell: UICollectionViewCell {
    var totalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 4
        $0.backgroundColor = ColorStyle.emptyGray
    }
    var imageVStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    
    let emptyBackgroundView = UIView().then {
        $0.backgroundColor = ColorStyle.emptyGray
    }
    let emptyImage = UIImageView().then {
        $0.image = ImageStyle.emptyImage
        $0.contentMode = .scaleAspectFit
    }
    
    // 하우스 이미지뷰
    let firstImage = UIImageView()
    let secondImage = UIImageView()
    let thirdImage = UIImageView()
    
    // 방 이름 레이블
    let roomNameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    let roomNameLabel = UILabel()
    let roomIcon = UIImageView()
    
    
    let starStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 2
    }
    let starIcon = UIImageView()
    let scoreLabel = UILabel()
    
    let roomPriceLabel = UILabel()
    let roomAddressLabel = UILabel()
    let bookMarkButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        setupConstraints()
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setData(imjangNote: nil)
    }
    
    func setData(imjangNote: ImjangNote?) {
        guard let imjangNote else { return }
        roomNameLabel.text = imjangNote.roomName
        scoreLabel.text = String(format: "%.1f", imjangNote.score ?? 0.0)
        roomPriceLabel.text = imjangNote.price
        roomAddressLabel.text = imjangNote.location
        let bookmarkImage = imjangNote.isBookmarked ? ImageStyle.bookmarkSelected : ImageStyle.bookmark
        bookMarkButton.setImage(bookmarkImage, for: .normal)
    }
    
    func configureHierarchy() {
        [totalStackView, roomNameStackView, starStackView, roomPriceLabel, roomAddressLabel, bookMarkButton].forEach {
            contentView.addSubview($0)
        }
        [roomNameLabel, roomIcon].forEach {
            roomNameStackView.addArrangedSubview($0)
        }
        
        [starIcon, scoreLabel].forEach {
            starStackView.addArrangedSubview($0)
        }
    }
    
    override func draw(_ rect: CGRect) {
        contentView.layer.cornerRadius = 10
        totalStackView.layer.cornerRadius = 5
        emptyBackgroundView.layer.cornerRadius = 5
    }
    
    func configureView() {
        contentView.backgroundColor = .white
        contentView.layer.borderColor = ColorStyle.strokeGray.cgColor
        contentView.layer.borderWidth = 1.5
        contentView.layer.shadowOffset = .init(width: 0, height: 4)
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        roomNameLabel.design(text: "", font: .pretendard(size: 18, weight: .bold))
        roomIcon.design(image: ImageStyle.house, contentMode: .scaleAspectFit)
        
        starIcon.design(image: ImageStyle.star, contentMode: .scaleAspectFit)
        scoreLabel.design(textColor: ColorStyle.mainOrange, font: .pretendard(size: 16, weight: .semiBold))
        roomPriceLabel.design(text: "", font: .pretendard(size: 16, weight: .semiBold))
        roomAddressLabel.design(text: "", textColor: ColorStyle.textGray, font: .pretendard(size: 14, weight: .medium))
        bookMarkButton.design(image: ImageStyle.bookmark, backgroundColor: .white)
    }
    
    func setupConstraints() {
        totalStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(117)
        }
        
        
        roomNameStackView.snp.makeConstraints {
            $0.leading.equalTo(totalStackView.snp.leading)
            $0.top.equalTo(totalStackView.snp.bottom).offset(8)
        }
        roomNameLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(18)
        }
        
        starStackView.snp.makeConstraints {
            $0.centerY.equalTo(roomNameStackView)
            $0.trailing.equalTo(totalStackView.snp.trailing)
        }
        starIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        scoreLabel.snp.makeConstraints {
            $0.height.equalTo(23)
        }
        
        roomPriceLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(totalStackView)
            $0.top.equalTo(roomNameStackView.snp.bottom)
            $0.height.equalTo(23)
        }
        
        roomAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(totalStackView)
            $0.bottom.greaterThanOrEqualTo(contentView).inset(9)
            $0.height.equalTo(20)
        }
        
        bookMarkButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(contentView).inset(12)
            $0.size.equalTo(18)
        }
    }
}
