//
//  ExpandedDropdownTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/23/24.
//

import UIKit
import SnapKit

protocol DropdownDelegate: AnyObject {
    func didSelectOption(_ option: String)
}

class ExpandedDropdownTableViewCell: UITableViewCell {
    var selectedOption: String?
    weak var delegate: DropdownDelegate?
    
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
    
    var options: [OptionItem] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        itemPickerView.delegate = self
        itemPickerView.dataSource = self
//        itemPickerView.register(CellClass.self, forCellReuseIdentifier: "Cell")
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
            $0.width.equalTo(116)
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
                $0.trailing.equalToSuperview().offset(-24) // 오른쪽으로 24만큼 이동
                $0.top.equalTo(contentLabel.snp.bottom).offset(20)
                $0.height.equalTo(31)
                $0.width.equalTo(218)
            }
        } else {
            etcTextField.removeFromSuperview()
        }
    }

    @objc func openItemOptions(_ sender: UIButton) {
        let selectedOptions = options.map { $0.option }
        dataSource = selectedOptions
        selectedButton = sender
        addTransparentView(frames: sender.frame)
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
        
        let selectedOption = options[row]
        print("Selected option: \(selectedOption)")
        
        // 선택한 옵션으로 selectedButton 설정
        setSelectedInset()
        selectedButton.setTitle(selectedOption.option, for: .normal)
        selectedButton.backgroundColor = .white
        selectedButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        selectedButton.setImage(selectedOption.image, for: .normal)
        selectedButton.semanticContentAttribute = .forceLeftToRight
        setSelectedInset()

        // 답변 항목 Button
        selectedButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.height.equalTo(31)
            $0.width.equalTo(116)
        }
        
        // 기본값 설정
        if row == 0 {
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
            itemButton.layer.backgroundColor = UIColor(named: "shadowGray")?.cgColor
            setBasicInset()
        } else {
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
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

        let option = options[row]
        label.font = UIFont.pretendard(size: fontSize, weight: .regular)
        label.textColor = UIColor.black
        label.textAlignment = .left

        if let image = option.image {
            // Add image to label
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image
            let imageString = NSAttributedString(attachment: imageAttachment)

            let mutableAttributedString = NSMutableAttributedString()
            mutableAttributedString.append(imageString)
            mutableAttributedString.append(NSAttributedString(string: " \(option.option)"))

            label.attributedText = mutableAttributedString
        } else {
            // 이미지가 없을 경우 왼쪽 padding 설정
            label.text = " " + option.option
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
        
        if let image = selectedButton.image(for: .normal) {
            // 이미지가 있는 경우
            selectedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: titleInset)
            selectedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: 0)
        } else {
            // 이미지가 없는 경우
            selectedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            selectedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: 0)
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
