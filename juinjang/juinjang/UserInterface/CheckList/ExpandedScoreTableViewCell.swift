//
//  ExpandedScoreTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/22/24.
//

import UIKit
import SnapKit

class ExpandedScoreTableViewCell: UITableViewCell {
    
    var selectedScore: String?
    var question: CheckListItem?
    var imjangId: Int?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    var scoreButtonStackView = UIStackView()
    
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
        // Configure the view for the selected state
    }
    
    func setupLayout() {
        // 질문 구분 imageView
        questionImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(25)
            $0.height.equalTo(6)
            $0.width.equalTo(6)
        }
        
        // 질문 Label
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(23)
        }
        
        // 점수 버튼 Stack View
        setupStackView()
    }
    
    func handleScoreSelection(_ score: String) {
        selectedScore = score
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        // 선택한 버튼이 아닌 경우 선택 해제
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            if button != sender {
                button.isSelected = false
                button.setImage(UIImage(named: "answer\(button.tag)"), for: .normal)
                RealmManager.shared.deleteChecklistItem(imjangId: imjangId!, questionId: question!.questionId)
            }
        }

        if sender.isSelected {
            sender.setImage(UIImage(named: "checked-button"), for: .normal)
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
            
            for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
                if button != sender {
                    button.isSelected = false
                    button.setImage(UIImage(named: "checklist-completed-button"), for: .normal)
                }
            }
            RealmManager.shared.saveChecklistItem(imjangId: imjangId!, questionId: question!.questionId, answer: String(sender.tag), isSelected: true)
        } else {
            sender.setImage(UIImage(named: "answer\(sender.tag)"), for: .normal)
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
            RealmManager.shared.deleteChecklistItem(imjangId: imjangId!, questionId: question!.questionId)
        }
        
        // 선택된 버튼의 정보를 저장
        selectedScore = String(sender.tag)
        
        if let score = selectedScore {
            print("Button Pressed: \(score)")
        } else {
            print("Button Pressed: No answer")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 버튼 초기화
        selectedScore = nil
        
        // 기존 스택 뷰 제거
        scoreButtonStackView.removeFromSuperview()
        
        // 새로운 스택 뷰 생성 및 설정
        scoreButtonStackView = UIStackView()
        setupStackView()
        
        // 배경색 초기화
        backgroundColor = .white
        questionImage.image = UIImage(named: "question-image")
    }
    
    func setupStackView() {
        scoreButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreButtonStackView.axis = .horizontal
        scoreButtonStackView.spacing = 20
        
        [answerButton1,
         answerButton2,
         answerButton3,
         answerButton4,
         answerButton5].forEach( { scoreButtonStackView.addArrangedSubview($0) } )
        
        addSubview(scoreButtonStackView)
        
        scoreButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(51)
//            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }

    // 보기 모드
    func viewModeConfigure(with questionDto: CheckListItem, with imjangId: Int, at indexPath: IndexPath) {
        self.question = questionDto
        self.imjangId = imjangId
        contentLabel.text = questionDto.question
        contentLabel.textColor = UIColor(named: "lightGray")
        backgroundColor = UIColor(named: "gray0")
        
        // 보기 모드 설정
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            button.isEnabled = false
            button.setImage(UIImage(named: "saved-button2"), for: .normal)
        }
    }
      
    // 수정 모드
    func editModeConfigure(with questionDto: CheckListItem, with imjangId: Int, at indexPath: IndexPath) {
        self.question = questionDto
        self.imjangId = imjangId
        contentLabel.text = questionDto.question
        contentLabel.textColor = UIColor(named: "500")
        backgroundColor = .white
        
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            button.isSelected = false
            button.setImage(UIImage(named: "checklist-completed-button"), for: .normal)
        }
    }
    
    // 보기 모드일 때 저장된 값이 있는 경우
    func savedViewModeConfigure(with imjangId: Int, with score: String, at indexPath: IndexPath) {
        questionImage.image = UIImage(named: "question-selected-image")
        contentLabel.textColor = UIColor(named: "500")
        backgroundColor = .white
        
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            if String(button.tag) == score {
                button.setImage(UIImage(named: "checked-button"), for: .normal)
            } else {
                button.setImage(UIImage(named: "saved-button"), for: .normal)
            }
        }
    }
    
    // 수정 모드일 때 저장된 값이 있는 경우
    func savedEditModeConfigure(with imjangId: Int, with score: String, at indexPath: IndexPath) {
        questionImage.image = UIImage(named: "question-selected-image")
        contentLabel.textColor = UIColor(named: "500")
        backgroundColor = UIColor(named: "lightOrange")
        
        for button in [answerButton1, answerButton2, answerButton3, answerButton4, answerButton5] {
            if String(button.tag) == score {
                button.setImage(UIImage(named: "checked-button"), for: .selected)
            } else {
                button.setImage(UIImage(named: "checklist-completed-button"), for: .selected)
            }
            button.isSelected = true
        }
    }
}
