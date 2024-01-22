//
//  ExpandedTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/21/24.
//

import UIKit

class ExpandedTableViewCell: UITableViewCell {

    static let identifier = "ExpandedTableViewCell"
    
    var selectedAnswer: Int? // 선택된 버튼의 값을 저장할 변수
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    lazy var answerButton1 = UIButton().then {
        $0.setImage(UIImage(named: "answer1"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 1
    }
    
    lazy var answerButton2 = UIButton().then {
        $0.setImage(UIImage(named: "answer2"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 2
    }
    
    lazy var answerButton3 = UIButton().then {
        $0.setImage(UIImage(named: "answer3"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 3
    }
    
    lazy var answerButton4 = UIButton().then {
        $0.setImage(UIImage(named: "answer4"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 4
    }
    
    lazy var answerButton5 = UIButton().then {
        $0.setImage(UIImage(named: "answer5"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        $0.tag = 5
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        [questionImage, contentLabel].forEach { contentView.addSubview($0) }
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
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        // 각 버튼에 대한 기본 이미지
        let initialImages: [Int: UIImage] = [
            1: UIImage(named: "answer1")!,
            2: UIImage(named: "answer2")!,
            3: UIImage(named: "answer3")!,
            4: UIImage(named: "answer4")!,
            5: UIImage(named: "answer5")!
        ]
        
        // 모든 버튼을 초기화 상태로 설정
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            if let initialImage = initialImages[button.tag] {
                button.setImage(initialImage, for: .normal)
            }
        }
        
        // 현재 눌린 버튼을 선택된 상태로 변경
        sender.setImage(UIImage(named: "checked-button"), for: .normal)
        
        // 선택된 버튼의 정보를 저장
        selectedAnswer = sender.tag
        
        if let answer = selectedAnswer {
            print("Button Pressed: \(answer)")
        } else {
            print("Button Pressed: No answer")
        }
        
        // 셀의 배경색을 변경
        backgroundColor = UIColor(named: "lightOrange")
    }
}
