//
//  ToSItemTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import UIKit

class ToSItemTableViewCell: UITableViewCell {
    
    var toSItem: ToSItem?
    var indexPath: IndexPath?
    
    lazy var checkButton = UIButton().then {
        $0.setTitleColor(UIColor(named: "textBlack"), for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .medium)
        $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage(named: "record-check-off"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill

        $0.semanticContentAttribute = .forceLeftToRight
        $0.contentHorizontalAlignment = .left
    
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 4)
    }
    
    lazy var openContentButton = UIButton().then {
        $0.addTarget(self, action: #selector(openContentButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage(named: "document"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        [checkButton, openContentButton].forEach { contentView.addSubview($0) }
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
            $0.leading.equalToSuperview().offset(26)
            $0.top.equalToSuperview().offset(22)
        }
        
        // 파일 열기 Button
        openContentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(21)
        }
    }
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            print("선택")
            sender.setImage(UIImage(named: "record-check-on"), for: .normal)
        } else {
            print("선택 해제")
            sender.setImage(UIImage(named: "record-check-off"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("CheckButtonUnchecked"), object: nil)
        }
        NotificationCenter.default.post(name: NSNotification.Name("CheckButtonChecked"), object: nil)
    }
    
    @objc func openContentButtonPressed(_ sender: UIButton) {
        let tag = sender.tag
        let selectedDetail = termsOfServiceDetail[tag]
        
        let tosDetailVC = ToSDetailViewController()
        if let parentVC = parentViewController {
            parentVC.navigationController?.pushViewController(tosDetailVC, animated: true)
            tosDetailVC.tag = sender.tag
            tosDetailVC.contentLabel.text = selectedDetail.contentLabel
            tosDetailVC.contentDetailLabel.text = selectedDetail.contentDetailLabel
        }
    }

    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    func configure(with item: ToSItem?, isChecked: Bool) {
        // item이 nil인지 확인하고, nil이면 함수 종료
        guard let toSItem = item else {
            return
        }

        let cleanedContent = toSItem.content.replacingOccurrences(of: "\\", with: "")
        let attributedString = NSMutableAttributedString(string: cleanedContent)

        if let range = cleanedContent.range(of: "(필수)") {
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "mainOrange")!, range: NSRange(range, in: cleanedContent))
        } else if let range = cleanedContent.range(of: "(선택)") {
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "textGray")!, range: NSRange(range, in: cleanedContent))
        }

        checkButton.setAttributedTitle(attributedString, for: .normal)
        checkButton.isSelected = isChecked
        let imageName = isChecked ? "record-check-on" : "record-check-off"
        checkButton.setImage(UIImage(named: imageName), for: .normal)
        openContentButton.tag = toSItem.tag
    }
}
