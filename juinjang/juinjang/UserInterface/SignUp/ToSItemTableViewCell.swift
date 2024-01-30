//
//  ToSItemTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import UIKit

class ToSItemTableViewCell: UITableViewCell {
    
    static let identifier = "ToSItemTableViewCell"
    
    lazy var checkButton = UIButton().then {
        $0.setTitle("약관 모두 동의하기", for: .normal)
        $0.setTitleColor(UIColor(named: "textBlack"), for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage(named: "record-check-off"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill

        $0.semanticContentAttribute = .forceLeftToRight
        $0.contentHorizontalAlignment = .left
    
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 4)
    }
    
    lazy var contentLabel = UILabel().then {
        $0.text = "야"
        $0.font = .pretendard(size: 16, weight: .medium)
    }
    
    lazy var openContentImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "document")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        [checkButton, contentLabel, openContentImage].forEach { contentView.addSubview($0) }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = .white
        // Configure the view for the selected state
    }
    
    func setupLayout() {
        // 동의 Button
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(22)
            $0.height.equalTo(6)
            $0.width.equalTo(6)
        }
        
        // 질문 Label
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(10)
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(23)
        }
        
        // 파일 열기 Image
        openContentImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(21)
            $0.height.equalTo(20)
            $0.width.equalTo(20)
        }
    }
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        checkButton.isSelected = !checkButton.isSelected
        
        if checkButton.isSelected {
            print("선택")
            checkButton.setImage(UIImage(named: "record-check-on"), for: .normal)
        } else {
            print("선택 해제")
            checkButton.setImage(UIImage(named: "record-check-off"), for: .normal)
        }
    }
}
