//
//  ExpandedTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/21/24.
//

import UIKit

class ExpandedTableViewCell: UITableViewCell {

    static let identifier = "ExpandedTableViewCell"
    
    let questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    let contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    let answerButton1 = UIButton().then {
        $0.setImage(UIImage(named: "answer1"), for: .normal)
    }
    
    let answerButton2 = UIButton().then {
        $0.setImage(UIImage(named: "answer2"), for: .normal)
    }
    
    let answerButton3 = UIButton().then {
        $0.setImage(UIImage(named: "answer3"), for: .normal)
    }
    
    let answerButton4 = UIButton().then {
        $0.setImage(UIImage(named: "answer4"), for: .normal)
    }
    
    let answerButton5 = UIButton().then {
        $0.setImage(UIImage(named: "answer5"), for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("CategoryItemTableViewCell initialized")
        
        [
            questionImage,
            contentLabel,
//         answerButton1,
//         answerButton2,
//         answerButton3,
//         answerButton4,
//         answerButton5
        ].forEach { addSubview($0) }
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
        questionImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(25)
//            $0.centerY.equalToSuperview()
            $0.height.equalTo(6)
            $0.width.equalTo(6)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalToSuperview().offset(16)
//            $0.centerY.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        // 점수 버튼 Stack View
        let scoreButtonStackView = UIStackView(arrangedSubviews: [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5])
        
        scoreButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreButtonStackView.axis = .horizontal
        scoreButtonStackView.spacing = 20
        
        addSubview(scoreButtonStackView)
        
        scoreButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(51)
//            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
//        answerButton1.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-24)
//            $0.centerY.equalToSuperview()
//            $0.height.equalTo(31)
//            $0.width.equalTo(31)
//        }
//
//        answerButton2.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-24)
//            $0.centerY.equalToSuperview()
//            $0.height.equalTo(31)
//            $0.width.equalTo(31)
//        }
//
//        answerButton3.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-24)
//            $0.centerY.equalToSuperview()
//            $0.height.equalTo(31)
//            $0.width.equalTo(31)
//        }
//
//        answerButton4.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-24)
//            $0.centerY.equalToSuperview()
//            $0.height.equalTo(31)
//            $0.width.equalTo(31)
//        }
//
//        answerButton5.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-24)
//            $0.centerY.equalToSuperview()
//            $0.height.equalTo(31)
//            $0.width.equalTo(31)
//        }
    }
}
