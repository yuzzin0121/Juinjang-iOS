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

class CellClass: UITableViewCell {
    
    lazy var iconImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var iconLabel = UILabel().then() {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "darkGray")
        $0.adjustsFontSizeToFitWidth = true
    }
    
    lazy var expandButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(named: "item-arrow-down"), for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [iconImage, iconLabel, expandButton].forEach { contentView.addSubview($0) }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        iconImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        
        iconLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImage.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        expandButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
    }
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
        
        // 전체 버튼 크기에 따른 비율 조정
        let labelWidth = 55  // 예시 비율 (60%)
        let imageWidth = 16  // 예시 비율 (40%)
        
        // 여백 설정
        let titleInset: CGFloat = 12.0
        let imageInset: CGFloat = 8.0
        
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: -imageInset)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: 0)
    }
    
    lazy var transparentView = UIView()
    
    lazy var itemTableView = UITableView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "gray4")?.cgColor
        $0.layer.backgroundColor = UIColor(named: "textWhite")?.cgColor
        $0.frame = CGRect(x: 0, y: 0, width: 116, height: 235)
        $0.separatorStyle = .none
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
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
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
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.contentView.frame
        self.contentView.addSubview(transparentView)
        
        // itemButton 정중앙 계산
        let itemButtonCenterX = frames.origin.x + frames.width / 2
        let itemButtonCenterY = frames.origin.y + frames.height / 2
        
        let calculatedHeight = CGFloat(options.count) * 39 + CGFloat(options.count - 1)
        let maxHeight: CGFloat = 235
        let finalHeight = min(calculatedHeight, maxHeight)
        
        // tableView 정중앙 위치 계산
        let tableViewOriginX = itemButtonCenterX - frames.width / 2
        let tableViewOriginY = itemButtonCenterY - (finalHeight / 2)
        
        itemTableView.frame = CGRect(x: tableViewOriginX, y: tableViewOriginY, width: frames.width, height: 0)
        self.contentView.addSubview(itemTableView)

        itemTableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        
        transparentView.isUserInteractionEnabled = true
        
        self.itemTableView.frame = CGRect(x: tableViewOriginX, y: tableViewOriginY, width: frames.width, height: finalHeight)
    }


    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        self.itemTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.transparentView.removeFromSuperview()
    }

    
    @objc func openItemOptions(_ sender: UIButton) {
        let selectedOptions = options.map { $0.option }
        dataSource = selectedOptions
        selectedButton = sender
        addTransparentView(frames: sender.frame)
       }
}

extension ExpandedDropdownTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CellClass ?? CellClass(style: .default, reuseIdentifier: "Cell")
        let option = options[indexPath.row]
        
        if let image = option.image {
            cell.iconImage.isHidden = false
            cell.iconImage.image = image
            cell.iconLabel.snp.updateConstraints {
                $0.leading.equalTo(cell.iconImage.snp.trailing).offset(8)
            }
        } else {
            // option의 image가 nil일 경우
            cell.iconImage.isHidden = true  // 이미지 뷰 숨김
            cell.iconLabel.snp.updateConstraints {
                $0.leading.equalTo(cell.iconImage.snp.trailing).offset(-16)
            }
        }
        
        // 아이콘 이미지와 레이블 설정
        cell.iconImage.image = option.image
        cell.iconLabel.text = option.option
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 39
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(options[indexPath.row].option, for: .normal)
        selectedButton.backgroundColor = .white
        selectedButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        
        // 선택한 옵션이 "기타"일 경우
        if selectedButton.title(for: .normal) == "기타" {
            selectedButton.backgroundColor = UIColor(named: "shadowGray")
            selectedButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
            selectedButton.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-250) // -24를 더해서 왼쪽으로 24만큼 이동
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
            
            // 답변 항목 Button
            selectedButton.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-24)
                $0.top.equalTo(contentLabel.snp.bottom).offset(20)
                $0.height.equalTo(31)
                $0.width.equalTo(116)
            }
        }
        
        if indexPath.row == 0 {
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
        } else if selectedButton.title(for: .normal) == "기타" {
            backgroundColor = .white
            questionImage.image = UIImage(named: "question-image")
        } else {
            backgroundColor = UIColor(named: "lightOrange")
            questionImage.image = UIImage(named: "question-selected-image")
        }
        
        let selectedOption = options[indexPath.row].option
        print("Selected option: \(selectedOption)")
    
        delegate?.didSelectOption(selectedOption)
        removeTransparentView()
    }
}
