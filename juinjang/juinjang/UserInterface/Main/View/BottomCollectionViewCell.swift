//
//  BottomCollectionViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 12/31/23.
//

import UIKit
import SnapKit
import Then

class BottomCollectionViewCell: UICollectionViewCell {

    static let id = "BottomCollectionViewCell"
    var isMonthPrice : Bool = true
    var isNoImage : Bool =  false
    var isRated : Bool = true
    
    
//MARK: - 변수 설정
    var recentImjangButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor(named: "bordercolor")?.cgColor
        $0.backgroundColor = .white
    }
    var recentImjangImageView = UIImageView().then {
        $0.image = UIImage(named:"apartment")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    var noImageImageView = UIImageView().then {
        $0.image = UIImage(named: "noImage")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    var nameLabel = UILabel().then {
        $0.text = "판교푸르지오월드마크7층2호"
        $0.numberOfLines = 2
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 15)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var priceLabel = UILabel().then {
        $0.text = "30억 1천"
        $0.textColor = UIColor(named: "price")
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var monthPriceLabel = UILabel().then{
        $0.text = "월 100만원"
        $0.textColor = UIColor(named: "price")
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var rateLabel = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "star")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "juinjang")
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
//MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addContentView()
        autoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - 함수 구현
    func isMonth() {
        if isMonthPrice == true {
            priceLabel.isHidden = true
        } else {
            monthPriceLabel.isHidden = true
        }
    }
    func noImage() {
        if isNoImage == true {
            recentImjangImageView.isHidden = true
        }
    }
    func isRate() {
        if isRated == false {
            rateLabel.textColor = UIColor(named: "null")
            let text1 = NSTextAttachment()
            text1.image = UIImage(named: "starNoColor")
            let text2 = " " + "0.0"
            let text3 = NSMutableAttributedString(string: "")
            text3.append(NSAttributedString(attachment: text1))
            text3.append(NSAttributedString(string: text2))
            rateLabel.attributedText = text3
        }
    }
    private func addContentView() {
        contentView.addSubview(recentImjangButton)
        recentImjangButton.addSubview(nameLabel)
        isRate()
        recentImjangButton.addSubview(rateLabel)
        recentImjangButton.addSubview(noImageImageView)
        recentImjangButton.addSubview(recentImjangImageView)
        
        noImage()
        recentImjangButton.addSubview(priceLabel)
        recentImjangButton.addSubview(monthPriceLabel)
        isMonth()
        
    }
        
    private func autoLayout() {
        recentImjangButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.height.equalTo(204)
            $0.width.equalTo(143)
        }
        recentImjangImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(6)
            $0.left.right.equalToSuperview().inset(8)
        }
        noImageImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(6)
            $0.left.right.equalToSuperview().inset(8)
        }
        nameLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(131)
            $0.left.right.equalToSuperview().inset(8)
        }
        priceLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
            $0.left.equalToSuperview().inset(8)
        }
        monthPriceLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
            $0.left.equalToSuperview().inset(8)
        }
        rateLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
            $0.right.equalToSuperview().inset(11)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
