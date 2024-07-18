//
//  ExpandedDropdownTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/23/24.
//

import UIKit
import SnapKit

class ExpandedDropdownTableViewCell: UITableViewCell {
    
    var optionSelectionHandler: ((String) -> Void)?
    var selectedOption: String?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    lazy var itemButton = UIButton().then {
        $0.backgroundColor = UIColor(named: "shadowGray")
        $0.titleLabel?.font = .pretendard(size: 16, weight: .regular)
        $0.addTarget(self, action: #selector(openItemOptions(_:)), for: .touchUpInside)
        $0.layer.backgroundColor = UIColor(named: "shadowGray")?.cgColor
        $0.layer.cornerRadius = 15
        $0.setTitle("선택안함", for: .normal)
        $0.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        $0.contentHorizontalAlignment = .left
        
        let buttonImage = UIImage(named: "item-arrow-down")
        $0.setImage(buttonImage, for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.semanticContentAttribute = .forceRightToLeft
        
        // 여백 설정
        let titleInset: CGFloat = 12.0
        let imageInset: CGFloat = 8.0
        $0.sizeToFit()
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -imageInset)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: $0.bounds.width - 35, bottom: 0, right: -imageInset)
    }
    
    lazy var transparentView = UIView()
    
    lazy var itemPickerView = UIPickerView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "gray4")?.cgColor
        $0.layer.backgroundColor = UIColor(named: "textWhite")?.cgColor
//        $0.separatorStyle = .none
    }
    
    lazy var etcTextField = UITextField().then {
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
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    var options: [Option] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        itemPickerView.delegate = self
        itemPickerView.dataSource = self
        etcTextField.delegate = self
        [questionImage, contentLabel, itemButton].forEach { contentView.addSubview($0) }
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 피커 뷰 초기화
        itemPickerView.reloadAllComponents()
        etcTextField.text = ""
        etcTextField.removeConstraints(etcTextField.constraints)
        etcTextField.removeFromSuperview()
        itemPickerView.selectRow(0, inComponent: 0, animated: true)
        
        // 기본 셀 내용 초기화
        let buttonImage = UIImage(named: "item-arrow-down")
        itemButton.setTitle("선택안함", for: .normal)
        itemButton.setImage(buttonImage, for: .normal)
        itemButton.layer.backgroundColor = UIColor(named: "shadowGray")?.cgColor
        itemButton.semanticContentAttribute = .forceRightToLeft
    
        // 여백 설정
        let titleInset: CGFloat = 12.0
        let imageInset: CGFloat = 8.0
        itemButton.sizeToFit()
        itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -imageInset)
        itemButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: itemButton.bounds.width - 35, bottom: 0, right: -imageInset)

        // 배경색 초기화
        backgroundColor = .white
        questionImage.image = UIImage(named: "question-image")
    
        // 버튼 위치 초기화
        itemButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-24)
        }
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
        
        // 답변 항목 Button
        itemButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.height.equalTo(31)
            $0.width.equalTo(123)
        }
    }
    
    func addTransparentView(frames: CGRect) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        // itemButton의 정중앙 좌표 계산
        let itemButtonCenterX = frames.origin.x + frames.width / 2
        let itemButtonCenterY = frames.origin.y + frames.height / 2

        let calculatedHeight = CGFloat(options.count) * 39 + CGFloat(options.count - 1)
        let maxHeight: CGFloat = 235
        let finalHeight = min(calculatedHeight, maxHeight)

        // itemButton을 기준으로 하여 itemPickerView 좌표 계산
        let pickerViewOriginX = itemButtonCenterX - frames.width / 2
        let pickerViewOriginY = itemButtonCenterY - (finalHeight / 2)

        // itemPickerView의 좌표를 window 기준으로 변환
        let pickerViewFrameInWindow = CGRect(x: pickerViewOriginX, y: pickerViewOriginY, width: frames.width, height: finalHeight)
        let pickerViewFrameInWindowConverted = window.convert(pickerViewFrameInWindow, from: self.contentView)

        transparentView.frame = window.frame
        window.addSubview(transparentView)
        window.addSubview(itemPickerView)

        itemPickerView.frame = pickerViewFrameInWindowConverted

        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
    }

    @objc func removeTransparentView() {
        transparentView.removeFromSuperview()
        itemPickerView.removeFromSuperview()
        
        // 선택한 옵션이 "기타"일 경우
        if selectedButton.title(for: .normal) == "기타" {
            selectedButton.backgroundColor = UIColor(named: "shadowGray")
            selectedButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
            selectedButton.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-250)
            }
            
            contentView.addSubview(etcTextField)
            
            etcTextField.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-24)
                $0.top.equalTo(contentLabel.snp.bottom).offset(20)
                $0.height.equalTo(31)
                $0.width.equalTo(218)
            }
        } else {
            etcTextField.removeConstraints(etcTextField.constraints)
            etcTextField.removeFromSuperview()
            
            // 기타 항목이 아닌 경우, selectedButton을 원래 위치로 복구
            selectedButton.snp.remakeConstraints {
                $0.trailing.equalToSuperview().offset(-24)
                $0.top.equalTo(contentLabel.snp.bottom).offset(20)
                $0.height.equalTo(31)
                $0.width.equalTo(123)
            }
        }
    }

    @objc func openItemOptions(_ sender: UIButton) {
        let selectedOptions = options.map { $0.option }
        dataSource = selectedOptions
        selectedButton = sender
        addTransparentView(frames: sender.frame)
    }
    
    // 보기 모드
    func viewModeConfigure(with questionDto: CheckListItem, at indexPath: IndexPath) {
        contentLabel.text = questionDto.question
        contentLabel.textColor = UIColor(named: "lightGray")
        backgroundColor = UIColor(named: "gray0")
        
        // 보기 모드 설정
        itemButton.isUserInteractionEnabled = false
        itemPickerView.isUserInteractionEnabled = false
    }
      
    // 수정 모드
    func editModeConfigure(with questionDto: CheckListItem, at indexPath: IndexPath) {
        contentLabel.text = questionDto.question
        contentLabel.textColor = UIColor(named: "500")
        backgroundColor = .white
        
        var optionValues: [Option] = []

        // 지하철 노선도 항목에 대한 이미지 추가
        if questionDto.questionId == 4 || questionDto.questionId == 62 {
            optionValues = questionDto.options.map { optionItem in
                if let originalImage = UIImage(data: optionItem.image ?? Data()) {
                    // 이미지가 리사이즈하여 새로운 이미지로 생성
                    let newSize = CGSize(width: 16, height: 16)
                    let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                        originalImage.draw(in: CGRect(origin: .zero, size: newSize))
                    }
                    return Option(option: optionItem.option, image: resizedImage.pngData())
                } else {
                    return Option(option: optionItem.option, image: nil)
                }
            }
        } else {
            // 기본값은 nil로 설정
            optionValues = questionDto.options.map { optionItem in
                return Option(option: optionItem.option, image: nil)
            }
        }
        options = optionValues
    }
    
    // 보기 모드일 때 저장된 값이 있는 경우
    func savedViewModeConfigure(with answer: String, with options: [Option], at indexPath: IndexPath) {
        // answer와 일치하는 옵션의 인덱스를 찾기
        if let selectedIndex = options.firstIndex(where: { $0.option == answer }) {
            itemPickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            questionImage.image = UIImage(named: "question-selected-image")
            contentLabel.textColor = UIColor(named: "500")
            backgroundColor = .white
            
            let selectedOption = options[selectedIndex]
            itemButton.setTitle(selectedOption.option, for: .normal)
            
            // 이미지가 있는 경우 리사이즈하여 설정
            if let originalImage = UIImage(data: selectedOption.image) {
                let newSize = CGSize(width: 16, height: 16)
                let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                    originalImage.draw(in: CGRect(origin: .zero, size: newSize))
                }
                itemButton.setImage(resizedImage, for: .normal)
            } else {
                itemButton.setImage(nil, for: .normal)
            }

            itemButton.backgroundColor = UIColor(named: "lightBackgroundOrange")
            itemButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
            itemButton.semanticContentAttribute = .forceLeftToRight
            setSavedInset()
        } else {
            if let selectedIndex = options.firstIndex(where: { $0.option == "기타" }) {
                if !answer.isEmpty && answer != nil {
                    itemPickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
                    questionImage.image = UIImage(named: "question-selected-image")
                    contentLabel.textColor = UIColor(named: "500")
                    backgroundColor = .white
                    
                    let selectedOption = options[selectedIndex]
                    itemButton.setTitle(selectedOption.option, for: .normal)
                    itemButton.setImage(nil, for: .normal)
                    
                    itemButton.snp.updateConstraints {
                        $0.trailing.equalToSuperview().offset(-250)
                    }
                    
                    contentView.addSubview(etcTextField)
                    
                    etcTextField.snp.makeConstraints {
                        $0.trailing.equalToSuperview().offset(-24)
                        $0.top.equalTo(contentLabel.snp.bottom).offset(20)
                        $0.height.equalTo(31)
                        $0.width.equalTo(218)
                    }
                    etcTextField.text = answer
                    etcTextField.backgroundColor = UIColor(named: "lightBackgroundOrange")
                    let padding: CGFloat = 27
                    let etcTextFieldSize = (etcTextField.text ?? "").width(forFont: etcTextField.font ?? UIFont.systemFont(ofSize: 16)) + padding
                    updateTextFieldWidthConstraint(for: etcTextField, constant: etcTextFieldSize, shouldRemoveLeadingConstraint: false)
                }
            } else {
                print("값을 찾을 수 없습니다.")
                itemButton.backgroundColor = .white
            }
        }
        selectedOption = answer
    }

    // 수정 모드일 때 저장된 값이 있는 경우
    func savedEditModeConfigure(with answer: String, with options: [Option], at indexPath: IndexPath) {
        print("선택형 답변: \(answer)")
        
        // answer와 일치하는 옵션의 인덱스를 찾기
        if let selectedIndex = options.firstIndex(where: { $0.option == answer }) {
            itemPickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            
            let selectedOption = options[selectedIndex]
            itemButton.setTitle(selectedOption.option, for: .normal)
            
            // 이미지가 있는 경우 리사이즈하여 설정
            if let originalImage = UIImage(data: selectedOption.image) {
                let newSize = CGSize(width: 16, height: 16)
                let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                    originalImage.draw(in: CGRect(origin: .zero, size: newSize))
                }
                itemButton.setImage(resizedImage, for: .normal)
                itemButton.semanticContentAttribute = .forceLeftToRight
            } else {
                itemButton.setImage(nil, for: .normal)
            }
            itemButton.backgroundColor = .white
        } else {
            let selectedIndex = options.firstIndex(where: { $0.option == "기타" })!
            itemPickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            itemButton.setTitle("기타", for: .normal)
            itemButton.setImage(nil, for: .normal)
            itemButton.backgroundColor = UIColor(named: "shadowGray")
            etcTextField.backgroundColor = .white
            etcTextField.text = answer
            itemButton.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-250)
            }
            
            contentView.addSubview(etcTextField)
            
            etcTextField.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-24)
                $0.top.equalTo(contentLabel.snp.bottom).offset(20)
                $0.height.equalTo(31)
                $0.width.equalTo(218)
            }
            etcTextField.layoutIfNeeded()
            let padding: CGFloat = 27
            let etcTextFieldSize = (etcTextField.text ?? "").width(forFont: etcTextField.font ?? UIFont.systemFont(ofSize: 16)) + padding
            updateTextFieldWidthConstraint(for: etcTextField, constant: etcTextFieldSize, shouldRemoveLeadingConstraint: false)
        }
        
        setSavedInset()
        itemButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        questionImage.image = UIImage(named: "question-selected-image")
        contentLabel.textColor = UIColor(named: "500")
        backgroundColor = UIColor(named: "lightOrange")
        
        selectedOption = answer
    }

    
    func handleOptionSelection(_ option: String) {
        optionSelectionHandler?(option)
    }
}

extension ExpandedDropdownTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].option
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = options[row].option
        
        // 선택한 옵션으로 selectedButton 설정
        selectedButton.setTitle(selectedOption, for: .normal)
        selectedButton.backgroundColor = .white
        selectedButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        
        if let image = UIImage(data: options[row].image) {
            selectedButton.setImage(image, for: .normal)
        } else {
            selectedButton.setImage(nil, for: .normal)
        }
        selectedButton.semanticContentAttribute = .forceLeftToRight
        setSelectedInset()

        // 답변 항목 Button
        selectedButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.height.equalTo(31)
            $0.width.equalTo(123)
        }
        
        etcTextField.text = ""
        etcTextField.removeConstraints(etcTextField.constraints)
        etcTextField.removeFromSuperview()
        
        // 기본값 설정
        if row == 0 {
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
            itemButton.layer.backgroundColor = UIColor(named: "shadowGray")?.cgColor
            setBasicInset()
            handleOptionSelection(options[row].option)
        } else {
            if options[row].option == "기타" {
                etcTextField.snp.updateConstraints {
                    $0.width.equalTo(218)
                }
                etcTextField.layoutIfNeeded()
                etcTextField.backgroundColor = UIColor(named: "lightBackgroundOrange")
                // 기타 선택했을 때 선택지 중에 있는지 확인
                if let existingOption = options.first(where: { $0.option == etcTextField.text }) {
                    // UI 설정
                    questionImage.image = UIImage(named: "question-selected-image")
                    backgroundColor = UIColor(named: "lightOrange")

                    // 값 전달
                    handleOptionSelection(existingOption.option)
                } else {
                    // 선택지 중에 없는 경우 사용자 입력값으로 처리
                    if let etcText = etcTextField.text, !etcText.isEmpty {
                        questionImage.image = UIImage(named: "question-selected-image")
                        backgroundColor = UIColor(named: "lightOrange")
                        handleOptionSelection(etcText)
                    } else {
                        questionImage.image = UIImage(named: "question-image")
                        backgroundColor = .white
                        etcTextField.removeConstraints(etcTextField.constraints)
                        etcTextField.removeFromSuperview()
                        handleOptionSelection(options[0].option)
                    }
                }
            } else {
                questionImage.image = UIImage(named: "question-selected-image")
                backgroundColor = UIColor(named: "lightOrange")
                handleOptionSelection(options[row].option)
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let fontSize: CGFloat = 16
        let leftPadding: CGFloat = 12
        
        pickerView.subviews[1].backgroundColor = .clear // 선택된 항목 회색 바탕으로 표시되지 않게 함
        
        var label: UILabel
        if let reusedLabel = view as? UILabel {
            label = reusedLabel
        } else {
            label = UILabel()
        }
        
        let option = options[row].option
        label.font = UIFont.pretendard(size: fontSize, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .left
        
        if let originalImage = UIImage(data: options[row].image),
           let resizedImage = originalImage.resized(toWidth: 16) { // 이미지 리사이징
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = resizedImage
            
            // 이미지의 y축을 조정하여 텍스트와 수평으로 맞추기
            let mid = (label.font.capHeight - resizedImage.size.height) / 2
            imageAttachment.bounds = CGRect(x: 0, y: mid, width: resizedImage.size.width, height: resizedImage.size.height)
            
            let imageString = NSAttributedString(attachment: imageAttachment)
            
            let attributedString = NSMutableAttributedString()
            attributedString.append(imageString)
            
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.pretendard(size: fontSize, weight: .regular),
                .foregroundColor: UIColor.black
            ]
            let textAttributedString = NSAttributedString(string: " \(options[row].option)", attributes: textAttributes)
            attributedString.append(textAttributedString)
            
            label.attributedText = attributedString
        } else {
            label.text = options[row].option
            label.frame.origin.x = leftPadding
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 39
    }
    
    // pickerView에서 항목 선택 시, 여백 설정
    func setSelectedInset() {
        let imageInset: CGFloat = 12.0
        let titleInset: CGFloat = 17.0
        
        selectedButton.sizeToFit()
        
        if let originalImage = selectedButton.image(for: .normal) {
            // 이미지를 리사이즈
            if let resizedImage = originalImage.resized(toWidth: 16) {
                selectedButton.setImage(resizedImage, for: .normal)
                
                // 이미지가 있는 경우
                selectedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: titleInset)
                selectedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: 0)
            }
        } else {
            // 이미지가 없는 경우
            selectedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            selectedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: 0)
        }
    }

    
    func setSavedInset() {
        let imageInset: CGFloat = 12.0
        let titleInset: CGFloat = 17.0
        
        itemButton.sizeToFit()
        
        if let image = itemButton.image(for: .normal) {
            // 이미지가 있는 경우
            itemButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: titleInset)
            itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: 0)
        } else {
            // 이미지가 없는 경우
            itemButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            itemButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: 0)
        }
    }

    
    // pickerView에서 기본 여백 설정
    func setBasicInset() {
        let buttonImage = UIImage(named: "item-arrow-down")
        selectedButton.setImage(buttonImage, for: .normal)
        selectedButton.contentMode = .scaleAspectFit
        selectedButton.semanticContentAttribute = .forceRightToLeft
        
        let titleInset: CGFloat = 12.0
        let imageInset: CGFloat = 8.0
        selectedButton.sizeToFit()
        selectedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -imageInset)
        selectedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: selectedButton.bounds.width - 35, bottom: 0, right: -imageInset)
    }
}

extension ExpandedDropdownTableViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        
        // 글자 수 8글자 제한
        guard textField.text!.count < 8 else { return false }
        
        textField.becomeFirstResponder()
        backgroundColor = UIColor(named: "lightOrange")
        questionImage.image = UIImage(named: "question-selected-image")
        textField.backgroundColor = UIColor(named: "lightBackgroundOrange")
        updateTextFieldWidthConstraint(for: textField, constant: 218, shouldRemoveLeadingConstraint: false)
    
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            // 텍스트 필드가 비어 있지 않은 경우
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
            textField.backgroundColor = .white
            
            // 입력된 텍스트에 따라 동적으로 너비 조절
            let calculatedWidth = calculateTextFieldWidth(for: text, maxCharacterCount: 8)

            // 텍스트 필드의 너비 및 위치 업데이트
            updateTextFieldWidthConstraint(for: textField, constant: calculatedWidth, shouldRemoveLeadingConstraint: true)
            textField.contentHorizontalAlignment = .left
            handleOptionSelection(text)
        } else {
            // 비어있는 경우 기존 너비로
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
            textField.backgroundColor = UIColor(named: "lightBackgroundOrange")
            etcTextField.snp.updateConstraints {
                $0.width.equalTo(218)
            }
            handleOptionSelection(options[0].option)
        }
        etcTextField.layoutIfNeeded()
    }

    func calculateTextFieldWidth(for text: String, maxCharacterCount: Int) -> CGFloat {
        let font = UIFont.pretendard(size: 16, weight: .regular)
        
        // 최대 글자 수에 따라 너비 계산
        let truncatedText = String(text.prefix(maxCharacterCount))
        let size = truncatedText.size(withAttributes: [.font: font])

        let calculatedWidth = size.width + 25
        return calculatedWidth
    }
    
    func updateTextFieldWidthConstraint(for textField: UITextField, constant: CGFloat, shouldRemoveLeadingConstraint: Bool) {
        // 텍스트 필드 너비 업데이트
        for constraint in textField.constraints where constraint.firstAttribute == .width {
            constraint.constant = constant
        }
        
        // 좌측 여백 제약 추가하거나 제거하는 조건
        if shouldRemoveLeadingConstraint {
            textField.superview?.constraints.forEach { constraint in
                if constraint.firstAttribute == .leading && constraint.firstItem === textField {
                    constraint.isActive = false
                }
            }
        } else {
            textField.snp.makeConstraints {
                    $0.trailing.equalToSuperview().offset(-24)
            }
        }
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvasSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: canvasSize))
        }
    }
}
