//
//  ScrapCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/26/24.
//

import UIKit
import Then
import Kingfisher

class ScrapCollectionViewCell: UICollectionViewCell {
    var totalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 4
        $0.backgroundColor = ColorStyle.emptyGray
    }
    
    let emptyBackgroundView = UIView().then {
        $0.backgroundColor = ColorStyle.emptyGray
    }
    let emptyImage = UIImageView().then {
        $0.image = ImageStyle.gallery
        $0.contentMode = .scaleAspectFit
    }
    
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
    
    
    func setData(imjangNote: ListDto?) {
        guard let imjangNote else { return }
        roomNameLabel.text = imjangNote.nickname
        setRate(totalAverage: imjangNote.totalAverage)
        setPriceLabel(priceList: imjangNote.priceList)
        roomAddressLabel.text = imjangNote.address
        let bookmarkImage = imjangNote.isScraped ? ImageStyle.bookmarkSelected : ImageStyle.bookmark
        bookMarkButton.setImage(bookmarkImage, for: .normal)
        
        let images = imjangNote.images
        switch images.count {
        case 0:
            setStackViewBackground(isEmpty: true)
        case 1:
            setImage1(image: images[0])
            setStackViewBackground(isEmpty: false)
        case 2:
            setImage2(images: images)
            setStackViewBackground(isEmpty: false)
        case 3...:
            setImage3(images: images)
            setStackViewBackground(isEmpty: false)
        default:
            print("알 수 없는 오류 발생")
        }
    }
    
    func setImage1(image: String) {
        let firstImageView = ImjangImageView(frame: .zero)
        totalStackView.addArrangedSubview(firstImageView)
        if let url = URL(string: image) {
            DispatchQueue.main.async {
                firstImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
            }
        }
        
        DispatchQueue.main.async {
            firstImageView.layer.cornerRadius = 5
            firstImageView.clipsToBounds = true
        }
    }
    
    func setImage2(images: [String]) {
        let firstImageView = ImjangImageView(frame: .zero)
        let secondImageView = ImjangImageView(frame: .zero)
        
        [firstImageView, secondImageView].forEach { totalStackView.addArrangedSubview($0)}
        
        firstImageView.snp.makeConstraints {
            $0.height.equalTo(firstImageView.snp.width).multipliedBy(117.0 / 174.0)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(secondImageView.snp.width).multipliedBy(117.0 / 109.0)
        }
        
        if let url1 = URL(string: images[0]) {
            DispatchQueue.main.async {
                firstImageView.kf.setImage(with: url1, placeholder: UIImage(named: "1"))
            }
        }
        if let url2 = URL(string: images[1]) {
            DispatchQueue.main.async {
                secondImageView.kf.setImage(with: url2, placeholder: UIImage(named: "2"))
            }
        }
        
        DispatchQueue.main.async {
            firstImageView.layer.cornerRadius = 5
            secondImageView.layer.cornerRadius = 5
            firstImageView.clipsToBounds = true
            secondImageView.clipsToBounds = true
        }
    }
    
    func setImage3(images: [String]) {
        let firstImageView = ImjangImageView(frame: .zero)
        let secondImageView = ImjangImageView(frame: .zero)
        let thirdImageView = ImjangImageView(frame: .zero)
        
        let imageVStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .equalSpacing
            $0.spacing = 5
        }
        
        [firstImageView, imageVStackView].forEach {
            totalStackView.addArrangedSubview($0)
        }

        [secondImageView, thirdImageView].forEach {
            imageVStackView.addArrangedSubview($0)
        }
               
        var secondHeight: Double = UIScreen.main.isWiderThan375pt ? 67 : 80
        var thirdHeight: Double = UIScreen.main.isWiderThan375pt ? 48 : 58
        
        var firstWidth: Double = UIScreen.main.isWiderThan428pt ? 186 : 174
        var secondWidth: Double = UIScreen.main.isWiderThan428pt ? 130 : 105
        firstImageView.snp.makeConstraints {
            $0.height.equalTo(firstImageView.snp.width).multipliedBy(117.0 / firstWidth)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(secondImageView.snp.width).multipliedBy(secondHeight / secondWidth)
        }
        
        thirdImageView.snp.makeConstraints {
            $0.height.equalTo(thirdImageView.snp.width).multipliedBy(thirdHeight / secondWidth)
        }
        
        if let url1 = URL(string: images[0]) {
            DispatchQueue.main.async {
                firstImageView.kf.setImage(with: url1, placeholder: UIImage(named: "1"))
            }
        }
        if let url2 = URL(string: images[1]) {
            DispatchQueue.main.async {
                secondImageView.kf.setImage(with: url2, placeholder: UIImage(named: "2"))
            }
        }
        if let url3 = URL(string: images[2]) {
            DispatchQueue.main.async {
                thirdImageView.kf.setImage(with: url3, placeholder: UIImage(named: "3"))
            }
        }
        
        DispatchQueue.main.async {
            firstImageView.layer.cornerRadius = 5
            secondImageView.layer.cornerRadius = 5
            thirdImageView.layer.cornerRadius = 5
            firstImageView.clipsToBounds = true
            secondImageView.clipsToBounds = true
            thirdImageView.clipsToBounds = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        totalStackView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        setData(imjangNote: nil)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        setupConstraints()
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPriceLabel(priceList: [String]) {
        switch priceList.count {
        case 1:
            let priceString = priceList[0]
            roomPriceLabel.text = priceString.formatToKoreanCurrencyWithZero()
        case 2:
            let priceString1 = priceList[0].formatToKoreanCurrencyWithZero()
            let priceString2 = priceList[1].formatToKoreanCurrencyWithZero()
            roomPriceLabel.text = "\(priceString1) • 월 \(priceString2)"
            roomPriceLabel.asColor(targetString: "•", color: ColorStyle.mainStrokeOrange)
        default:
            roomPriceLabel.text = "편집을 통해 가격을 설정해주세요."
        }
    }
    
    func setRate(totalAverage: String?) {
        if let score = totalAverage {
            DispatchQueue.main.async {
                self.starIcon.image = ImageStyle.star
            }
            scoreLabel.text = String(format: "%.1f", score)
        } else {
            DispatchQueue.main.async {
                self.starIcon.image = ImageStyle.starEmpty
            }
            scoreLabel.text = "0.0"
            scoreLabel.textColor = ColorStyle.null
        }
    }

    
    func setStackViewBackground(isEmpty: Bool) {
        emptyImage.isHidden = isEmpty ? false : true
        if isEmpty {
            totalStackView.addSubview(emptyImage)
            emptyImage.snp.makeConstraints {
                $0.center.equalTo(totalStackView)
                $0.size.equalTo(50)
            }
        }
        totalStackView.backgroundColor = isEmpty ? ColorStyle.emptyGray : UIColor.white
    }
    
    func configureHierarchy() {
        [totalStackView,roomNameStackView, starStackView, roomPriceLabel, roomAddressLabel, bookMarkButton].forEach {
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
