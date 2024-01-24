//
//  ExpandedTextFieldTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/23/24.
//

import UIKit

import UIKit
import SnapKit

class ExpandedTextFieldTableViewCell: UITableViewCell {
    
    static let identifier = "ExpandedTextFieldTableViewCell"
    
    var inputAnswer: String?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    lazy var answerTextField = UITextField().then {
        $0.layer.cornerRadius = 15
        $0.layer.backgroundColor = UIColor(named: "lightBackgroundOrange")?.cgColor
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "darkGray")
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
        $0.leftView = paddingView
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftViewMode = .always
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        answerTextField.delegate = self
        
        [questionImage, contentLabel, answerTextField].forEach { contentView.addSubview($0) }
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
        
        // 답변 TextField
        answerTextField.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
//            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.width.equalTo(342)
            $0.height.equalTo(31)
        }
    }
}

//extension ExpandedTextFieldTableViewCell: UITextFieldDelegate {
//    func updateTextFieldWidthConstraint(for textField: UITextField, constant: CGFloat) {
//        guard let text = textField.text else { return }
//        // 기존의 widthAnchor로 업데이트
//        if text.isEmpty {
//            for constraint in textField.constraints where constraint.firstAttribute == .width {
//                constraint.constant = constant
//            }
//        } else {
//        }
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return true }
//
//        // 각 텍스트 필드에 대한 최소, 최대 너비 설정
//        let minimumWidth: CGFloat = 30 // 최소 너비
//        var maximumWidth: CGFloat = 74 // 네 자릿수 텍스트 필드의 최대 너비
//
//        
//        // 텍스트 길이에 따라 적절한 너비 계산
//        let size = text.size(withAttributes: [.font: textField.font ?? UIFont.systemFont(ofSize: 17)])
//        let calculatedWidth = max(size.width + 20, minimumWidth) // 텍스트 길이와 최소 너비 중 큰 값을 선택
//        let finalWidth = min(calculatedWidth, maximumWidth) // 최대 너비 제한
//
//        // 너비 제약 업데이트
//        updateTextFieldWidthConstraint(for: textField, constant: finalWidth)
//
//        // 레이아웃 업데이트
//        layoutIfNeeded()
//        
//        // 백 스페이스 실행 가능하도록
//        if let char = string.cString(using: String.Encoding.utf8) {
//            let isBackSpace = strcmp(char, "\\b")
//            if (isBackSpace == -92) {
//                return true
//            }
//        }
//        
//        // 글자 수 20글자 제한
//        guard textField.text!.count < 20 else { return false }
//    
//        return true
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard textField.text?.isEmpty ?? true else { return }
//        updateTextFieldWidthConstraint(for: textField, constant: 342) // 기존 너비로 복원
//    }
//}

extension ExpandedTextFieldTableViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        
        // 글자 수 20글자 제한
        guard textField.text!.count < 20 else { return false }
    
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
//        guard textField.text?.isEmpty ?? true else { return }
//        updateTextFieldWidthConstraint(for: textField, constant: 342) // 기존 너비로 복원
//        
//        // 텍스트가 비어있지 않은 경우에만 실행
//        guard let text = textField.text, !text.isEmpty else { return }
//
//        // 입력된 텍스트에 따라 동적으로 너비 조절
//        let calculatedWidth = calculateTextFieldWidth(for: text, maxCharacterCount: 20)
//        updateTextFieldWidthConstraint(for: textField, constant: calculatedWidth)
        // 입력이 완료된 후에 동적으로 너비 조절
        print("안녕")
        let calculatedWidth = calculateTextFieldWidth(for: textField.text ?? "", maxCharacterCount: 20)
        updateTextFieldWidthConstraint(for: textField, constant: calculatedWidth)
        backgroundColor = UIColor(named: "lightOrange")
    }

    func calculateTextFieldWidth(for text: String, maxCharacterCount: Int) -> CGFloat {
        // 원하는 폰트, 텍스트에 따라 적절한 너비 계산
        let font = UIFont.pretendard(size: 16, weight: .regular)
        
        // 최대 글자 수에 따라 적절한 너비 계산
        let truncatedText = String(text.prefix(maxCharacterCount))
        let size = truncatedText.size(withAttributes: [.font: font])
        
        let minimumWidth: CGFloat = 342
        let maximumWidth: CGFloat = 20 * (size.width / CGFloat(maxCharacterCount)) + 20  // 각 글자에 대한 평균 너비 계산
        let calculatedWidth = max(size.width + 20, minimumWidth)
        return min(calculatedWidth, maximumWidth)
    }
    
    func updateTextFieldWidthConstraint(for textField: UITextField, constant: CGFloat) {
        // 기존의 widthAnchor로 업데이트
        for constraint in textField.constraints where constraint.firstAttribute == .width {
            constraint.constant = constant
        }
    }
}
