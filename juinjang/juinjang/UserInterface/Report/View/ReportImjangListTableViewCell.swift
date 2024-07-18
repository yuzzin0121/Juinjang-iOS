//
//  ImjangNoteTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/25/24.
//

import UIKit
import SnapKit

class ReportImjangListTableViewCell: UITableViewCell {
    let roomThumbnailImageView = UIImageView()
    let roomNameLabel = UILabel()
    let roomIcon = UIImageView()
    let roomNameStackView = UIStackView()
    let priceLabel = UILabel()
    let starIcon = UIImageView()
    let scoreLabel = UILabel()
    let starStackView = UIStackView()
    let addressLabel = UILabel()
    var isSelect: Bool = false
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [roomThumbnailImageView, roomNameStackView, priceLabel, starStackView, addressLabel, ].forEach {
            contentView.addSubview($0)
        }
        [roomNameLabel, roomIcon].forEach {
            roomNameStackView.addArrangedSubview($0)
        }
        [starIcon, scoreLabel].forEach {
            starStackView.addArrangedSubview($0)
        }
        designView()
        setConstraints()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 8, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPriceLabel(priceList: [String]) {
        switch priceList.count {
        case 1:
            let priceString = priceList[0]
            priceLabel.text = priceString.formatToKoreanCurrencyWithZero()
        case 2:
            let priceString1 = priceList[0].formatToKoreanCurrencyWithZero()
            let priceString2 = priceList[1].formatToKoreanCurrencyWithZero()
            priceLabel.text = "\(priceString1) • 월 \(priceString2)"
            priceLabel.asColor(targetString: "•", color: ColorStyle.mainStrokeOrange)
        default:
            priceLabel.text = "편집을 통해 가격을 설정해주세요."
        }
    }
    
    func configureCell(imjangNote: ListDto?) {
        guard let imjangNote else { return }
        
        roomNameLabel.text = imjangNote.nickname
        setPriceLabel(priceList: imjangNote.priceList)
        setRate(totalAverage: imjangNote.totalAverage)
        print("총점은 : \(imjangNote.totalAverage)")
//        if let score = imjangNote.totalAverage {
//            DispatchQueue.main.async {
//                self.starIcon.image = ImageStyle.star
//            }
//            scoreLabel.text = String(format: "%.1f", score)
//        } else {
//            DispatchQueue.main.async {
//                self.starIcon.image = ImageStyle.starEmpty
//            }
//            scoreLabel.text = "0.0"
//            scoreLabel.textColor = ColorStyle.null
//        }
        
        addressLabel.text = imjangNote.address
        
        let images = imjangNote.images
        if images.isEmpty {
            let image = ImageStyle.emptyImage
            DispatchQueue.main.async {
                self.roomThumbnailImageView.image = image
            }
        } else {
            let image = images[0]
            if let url = URL(string: image) {
                DispatchQueue.main.async {
    //                self.roomThumbnailImageView.image = UIImage(named: image)  // 임시
                    self.roomThumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
                }
            }
        }
    }
    
    func setRate(totalAverage: String?) {
        if let totalAverage {
            starIcon.image = ImageStyle.star
            scoreLabel.text = totalAverage
        } else {
            starIcon.image = ImageStyle.starEmpty
            scoreLabel.text = "0.0"
        }
    }
    
    func setConstraints() {
        roomThumbnailImageView.snp.makeConstraints {        // 방 썸네일 사진
            $0.leading.equalTo(contentView.snp.leading).offset(12)
            $0.centerY.equalTo(contentView)
            $0.size.equalTo(82)
        }
        
        roomNameStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(12)
            $0.leading.equalTo(roomThumbnailImageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(contentView.snp.trailing).inset(12)
            $0.height.equalTo(24)
        }
        
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(roomNameStackView.snp.bottom)
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing).inset(12)
        }
        
        starStackView.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.trailing.greaterThanOrEqualTo(contentView.snp.trailing).inset(12)
        }
        
        starIcon.snp.makeConstraints {
            $0.width.height.equalTo(14)
        }
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.top.equalTo(starStackView.snp.bottom)
           // $0.trailing.greaterThanOrEqualTo(bookMarkButton.snp.leading).inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(imjangNote: nil)
        self.roomThumbnailImageView.image = nil
    }
    
    override func draw(_ rect: CGRect) {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = ColorStyle.strokeGray.cgColor
//        roomThumbnailImageView.design(contentMode: .scaleAspectFill, cornerRadius: 5)
        DispatchQueue.main.async {
            self.roomThumbnailImageView.layer.cornerRadius = 5
            self.roomThumbnailImageView.clipsToBounds = true
        }
    }
    
    func designView() {
        roomNameStackView.axis = .horizontal
        roomNameStackView.spacing = 4
        roomNameStackView.alignment = .center
        roomNameStackView.distribution = .fill
        
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.alignment = .center
        starStackView.distribution = .fill

        roomThumbnailImageView.contentMode = .scaleAspectFill
        roomIcon.design(image: ImageStyle.house, contentMode: .scaleAspectFit)
        roomNameLabel.design(text:"", font: .pretendard(size: 16, weight: .bold))
        priceLabel.design(text:"", font: .pretendard(size: 16, weight: .semiBold))
        
        starIcon.design(image: ImageStyle.star, contentMode: .scaleAspectFit)
        scoreLabel.design(text:"0.0", textColor: ColorStyle.mainOrange, font: .pretendard(size: 14, weight: .semiBold))
        addressLabel.design(text: "", textColor: ColorStyle.textGray, font: .pretendard(size: 14, weight: .medium))
    }
}
