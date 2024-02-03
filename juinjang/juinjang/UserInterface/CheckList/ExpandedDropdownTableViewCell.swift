//
//  ExpandedDropdownTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/23/24.
//

import UIKit
import SnapKit
import SwiftyMenu

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
    
    lazy var pickerView = UIPickerView()
    
    var options: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        pickerView.delegate = self
        pickerView.dataSource = self
        [questionImage, contentLabel, pickerView].forEach { contentView.addSubview($0) }
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
        
        // 답변 PickerView
        pickerView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.height.equalTo(50) // 31
            $0.width.equalTo(150) // 116
        }
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
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // 기본값 설정
            if row == 0 {
                backgroundColor = .white
                questionImage.image = UIImage(named: "question-image")
            } else {
                backgroundColor = UIColor(named: "lightOrange")
                questionImage.image = UIImage(named: "question-selected-image")
            }
            
            let selectedOption = options[row]
            print("Selected option: \(selectedOption)")
        
            delegate?.didSelectOption(selectedOption)
        }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = options[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(size: 16, weight: .regular),
            .foregroundColor: UIColor.black
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }

}
