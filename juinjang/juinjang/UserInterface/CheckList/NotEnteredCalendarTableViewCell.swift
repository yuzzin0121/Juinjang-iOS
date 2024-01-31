//
//  NotEnteredCalendarTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 2/1/24.
//

import UIKit

class NotEnteredCalendarTableViewCell: UITableViewCell {
    
    var calendarItem: CalendarItem?
    var calendarItems: [Item] = []
    
    lazy var moveInDateImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "calendar")
    }
    
    lazy var moveInDateLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .semiBold)
        $0.textColor = UIColor(named: "gray5")
        $0.text = "입주 가능 날짜"
    }
    
    lazy var moveInDateContentLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = UIColor(named: "textGray")
        $0.text = "입력 안함"
    }
    
    lazy var separationLine = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "separation-line")
    }
    
    lazy var balanceDueImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "wallet")
    }
    
    lazy var balanceDueLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .semiBold)
        $0.textColor = UIColor(named: "gray5")
        $0.text = "잔금 날짜"
    }
    
    lazy var balanceDueContentLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = UIColor(named: "textGray")
        $0.text = "입력 안함"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(named: "gray0")
        
        [moveInDateImage,
         moveInDateLabel,
         moveInDateContentLabel,
         separationLine,
         balanceDueImage,
         balanceDueLabel,
         balanceDueContentLabel].forEach { contentView.addSubview($0) }
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
        // Configure the view for the selected state
    }
    
    func setupLayout() {
        // 입주 가능 날짜 imageView
        moveInDateImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }

        // 입주 가능 날짜 Label
        moveInDateLabel.snp.makeConstraints {
            $0.leading.equalTo(moveInDateImage.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }

        // 입주 가능 날짜 상세 Label
        moveInDateContentLabel.snp.makeConstraints {
            $0.leading.equalTo(moveInDateLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }

        // 구분선 imageView
        separationLine.snp.makeConstraints {
            $0.trailing.equalTo(balanceDueImage.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(8)
        }

        // 잔금 기한 imageView
        balanceDueImage.snp.makeConstraints {
            $0.trailing.equalTo(balanceDueLabel.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }

        // 잔금 기한 날짜 Label
        balanceDueLabel.snp.makeConstraints {
            $0.trailing.equalTo(balanceDueContentLabel.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
        // 잔금 기한 날짜 상세 Label
        balanceDueContentLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-49)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
}
