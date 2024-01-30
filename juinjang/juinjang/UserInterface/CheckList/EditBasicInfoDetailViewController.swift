//
//  EditBasicInfoDetailViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/31/24.
//

//
//  EditBasicInfoViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/31/24.
//

import UIKit

class EditBasicInfoDetailViewController: UIViewController {
    
    var transactionModel = TransactionModel()
    
    var moveTypeButtons: [UIButton] = [] // "입주 유형"을 나타내는 선택지
    var selectedMoveTypeButton: UIButton? // 입주 유형 카테고리의 버튼
    var isMoveTypeSelected: Bool = false
    
    var moveTypeStackView: UIStackView!
    var inputPriceStackView: UIStackView!
    var inputMonthlyRentStackView: UIStackView!
    
    var priceDetailLabel: UILabel?
    var priceDetailLabel2: UILabel?
    
    let contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.backgroundColor = .blue
    }
    
    func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = UIColor(named: "normalText")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    func secondConfigureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = UIColor(named: "textBlack")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    lazy var addressLabel = UILabel().then {
        configureLabel($0, text: "주소")
    }

    lazy var houseNicknameLabel = UILabel().then {
        configureLabel($0, text: "집 별명")
    }
    
    lazy var priceLabel = UILabel().then {
        configureLabel($0, text: "가격")
    }
    
    lazy var explanationLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "※ 별명은 리스트 구분을 위해 쓰여요.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.3, range: NSRange(location: 0, length: attributedString.length)) // 글자 간격 설정

        let customFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let scaledFont = fontMetrics.scaledFont(for: customFont)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: scaledFont, range: NSRange(location: 0, length: attributedString.length))
        
        $0.attributedText = attributedString
        $0.textColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        $0.translatesAutoresizingMaskIntoConstraints = false

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13
        
        $0.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    lazy var addressTextField = UITextField().then {
        $0.layer.backgroundColor = UIColor(named: "gray0")?.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor(named: "gray2")?.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
    }
    
    lazy var searchAddressButton = UIButton().then {
        $0.setTitle("주소 검색하기", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.358, green: 0.363, blue: 0.371, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(searchAddressButtonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    lazy var addressDetailTextField = UITextField().then {
        let customFont = UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: customFont
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "상세 주소", attributes: attributes)
            $0.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor(named: "gray2")?.cgColor
            $0.textColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
            $0.font = customFont
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
            $0.leftView = paddingView
            $0.leftViewMode = .always
    }
    
    lazy var houseNicknameTextField = UITextField().then {
        let customFont = UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: customFont
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "12자 이내", attributes: attributes)
            $0.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor(named: "gray2")?.cgColor
            $0.textColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
            $0.font = customFont
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
            $0.leftView = paddingView
            $0.leftViewMode = .always
            $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureButton(_ button: UIButton, normalImage: UIImage?, selectedImage: UIImage?, action: Selector) {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.setBackgroundImage(normalImage, for: .normal)
        button.setBackgroundImage(selectedImage, for: .selected)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)
        button.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지
    }
    
    lazy var saleButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "sale-button"), selectedImage: UIImage(named: "sale-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var jeonseButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "jeonse-button"), selectedImage: UIImage(named: "jeonse-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var monthlyRentButton = UIButton().then {
        configureButton($0, normalImage: UIImage(named: "monthlyrent-button"), selectedImage: UIImage(named: "monthlyrent-selected-button"), action: #selector(buttonPressed))
    }
    
    lazy var priceView = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.971, green: 0.971, blue: 0.971, alpha: 1).cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var priceView2 = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.971, green: 0.971, blue: 0.971, alpha: 1).cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configurePriceLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 55, height: 22)
        label.textColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
    
    lazy var priceDetailLabels: [UILabel] = {
        let labelsTexts = [
            "매매가",
            "보증금",
            "전세금",
            "억",
            "월",
            "만원", // 기본 단위
            "만원" // 월세 선택 시 추가되는 단위
        ]
        return labelsTexts.map { text in
            UILabel().then {
                secondConfigureLabel($0, text: text)
                if text == "매매가" {
                    priceDetailLabel = $0
                    priceView.addSubview($0)
                }
            }
        }
    }()
    
    
    lazy var threeDisitPriceField = UITextField().then {
        $0.layer.backgroundColor = UIColor(named: "gray2")?.cgColor
        $0.layer.cornerRadius = 15
        
        $0.attributedPlaceholder = NSAttributedString(
            string: "000",
            attributes: [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        $0.keyboardType = .numberPad
        if let customFont = UIFont(name: "Pretendard-SemiBold", size: 24) {
            $0.font = customFont
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
        $0.leftView = paddingView
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var fourDisitPriceField = UITextField().then {
        $0.layer.backgroundColor = UIColor(named: "gray2")?.cgColor
        $0.layer.cornerRadius = 15
        $0.attributedPlaceholder = NSAttributedString(
            string: "0000",
            attributes: [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        $0.keyboardType = .numberPad
        if let customFont = UIFont(name: "Pretendard-SemiBold", size: 24) {
            $0.font = customFont
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
        $0.leftView = paddingView
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var fourDisitMonthlyRentField = UITextField().then {
        $0.layer.backgroundColor = UIColor(named: "gray2")?.cgColor
        $0.layer.cornerRadius = 15
        $0.attributedPlaceholder = NSAttributedString(
            string: "0000",
            attributes: [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: UIFont(name: "Pretendard-Medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        $0.keyboardType = .numberPad
        if let customFont = UIFont(name: "Pretendard-SemiBold", size: 24) {
            $0.font = customFont
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: $0.frame.height))
        $0.leftView = paddingView
        $0.rightView = paddingView
        $0.rightViewMode = .always
        $0.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var cancelButton = UIButton().then {
        $0.setTitle("취소하기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(named: "textBlack")
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        addressTextField.isUserInteractionEnabled = false // 사용자 입력 방지
        setupWidgets()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "정보 수정하기"
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage(named: "arrow-left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backToPageTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setDelegate() {
        addressTextField.delegate = self
        houseNicknameTextField.delegate = self
        threeDisitPriceField.delegate = self
        fourDisitPriceField.delegate = self
        fourDisitMonthlyRentField.delegate = self
    }
    
    func setupWidgets() {
        // 위젯들을 서브뷰로 추가
        [addressLabel,
         houseNicknameLabel,
         addressTextField,
         searchAddressButton,
         addressDetailTextField,
         explanationLabel,
         houseNicknameTextField,
         priceLabel,
         priceView,
         priceView2,
         cancelButton,
         saveButton].forEach { view.addSubview($0) }
        setupLayout()
    }
    
    func setupLayout() {
        // 주소 Label
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 주소 TextField
        addressTextField.snp.makeConstraints {
            $0.width.equalTo(225)
            $0.height.equalTo(36)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
        }
        
        // 주소 검색하기 Button
        searchAddressButton.snp.makeConstraints {
            $0.width.equalTo(109)
            $0.height.equalTo(36)
            $0.leading.equalTo(addressTextField.snp.trailing).offset(8)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12)
        }
        
        // 상세주소 TextField
        addressDetailTextField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.top.equalTo(searchAddressButton.snp.bottom).offset(8)
        }

        // 집 별명 Label
        houseNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(addressDetailTextField.snp.bottom).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 별명 설명 Label
        explanationLabel.snp.makeConstraints {
            $0.leading.equalTo(houseNicknameLabel.snp.trailing).offset(1)
            $0.bottom.equalTo(houseNicknameTextField.snp.top).offset(-14)
        }
        
        // 집 별명 TextField
        houseNicknameTextField.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.top.equalTo(houseNicknameLabel.snp.bottom).offset(12)
        }
        
        // 가격 Label
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(houseNicknameTextField.snp.bottom).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.18)
            $0.height.equalToSuperview().multipliedBy(0.03)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 입주 유형 Stack View
        moveTypeStackView = UIStackView(
            arrangedSubviews:
                [saleButton,
                 jeonseButton,
                 monthlyRentButton])
        
        moveTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        moveTypeStackView.axis = .horizontal
        moveTypeStackView.spacing = 8
        
        view.addSubview(moveTypeStackView)
        
        moveTypeStackView.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(12)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5)
            $0.leading.equalTo(view.snp.leading).offset(24)
        }
        
        // 매매 버튼이 기본으로 선택되어 있음
        saleButton.isSelected = true
        
        // 가격 View
        priceView.snp.makeConstraints {
            $0.top.equalTo(moveTypeStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        priceView2.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        priceView2.isHidden = true

        // 가격 입력칸 Stack View
        inputPriceStackView = UIStackView(
            arrangedSubviews:
                [threeDisitPriceField,
                 priceDetailLabels[4],
                 fourDisitPriceField,
                 priceDetailLabels[6]])

        inputPriceStackView.translatesAutoresizingMaskIntoConstraints = false
        inputPriceStackView.axis = .horizontal
        inputPriceStackView.spacing = 5

        priceView.addSubview(inputPriceStackView)

        if let priceDetailLabel = priceDetailLabel {
            priceDetailLabel.snp.makeConstraints {
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.top.equalTo(priceView.snp.top).offset(8)
                $0.leading.equalTo(priceView.snp.leading).offset(24)
            }
            inputPriceStackView.snp.makeConstraints {
                $0.leading.equalTo(priceDetailLabel.snp.trailing).offset(16)
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.top.equalTo(priceView.snp.top).offset(8)
            }
        }
        
        // 월세 가격 입력칸 Stack View
        inputMonthlyRentStackView = UIStackView()
        inputMonthlyRentStackView.translatesAutoresizingMaskIntoConstraints = false
        inputMonthlyRentStackView.axis = .horizontal
        inputMonthlyRentStackView.spacing = 5
    
        // 가격 입력 받는 TextField
        threeDisitPriceField.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.top).offset(4)
            $0.centerY.equalTo(priceView.snp.centerY)
        }

        fourDisitPriceField.snp.makeConstraints {
            $0.top.equalTo(priceView.snp.top).offset(4)
            $0.centerY.equalTo(priceView.snp.centerY)
        }
        
        // 취소 버튼
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.centerX.equalTo(view.snp.centerX).offset(-116.5)
            $0.leading.equalTo(view.snp.leading).offset(24)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
            $0.bottom.equalTo(view.snp.bottom).offset(-33)
        }

        // 저장 버튼
        saveButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.centerX.equalTo(view.snp.centerX).offset(58.5)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(8)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.bottom.equalTo(view.snp.bottom).offset(-33)
        }

    }
    
    // 각 카테고리에 따른 버튼을 나타내기 위한 처리
    func setButton() {
        // 입주 유형 카테고리에 속한 버튼
        moveTypeButtons = [saleButton, jeonseButton, monthlyRentButton]
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard !sender.isSelected else { return } // 이미 선택된 버튼이면 아무 동작도 하지 않음
        // 해당 버튼의 선택 여부를 반전
        sender.isSelected = !sender.isSelected
        isMoveTypeSelected = sender.isSelected
        
        if sender != saleButton {
            saleButton.isSelected = false
        }
        // 매물 유형 카테고리의 버튼일 경우
        if let selectedButton = selectedMoveTypeButton, selectedButton != sender {
            // 이전에 선택된 버튼이 있고 새로운 버튼과 다른 경우에는 이전 버튼의 선택을 해제
            selectedButton.isSelected = false
        }
        
        // 버튼에 따라 가격 View 표시
        if sender == saleButton {
            threeDisitPriceField.text = ""
            fourDisitPriceField.text = ""
            priceView2.isHidden = true
            priceDetailLabel?.removeFromSuperview()
            priceDetailLabel = priceDetailLabels[0]
            checkPriceDetailLabel()
        } else if sender == jeonseButton {
            threeDisitPriceField.text = ""
            fourDisitPriceField.text = ""
            priceView2.isHidden = true
            priceDetailLabel?.removeFromSuperview()
            priceDetailLabel = priceDetailLabels[2]
            checkPriceDetailLabel()
        } else if sender == monthlyRentButton {
            threeDisitPriceField.text = ""
            fourDisitPriceField.text = ""
            fourDisitMonthlyRentField.text = ""
            priceDetailLabel?.removeFromSuperview()
            priceView2.isHidden = false
            priceDetailLabel = priceDetailLabels[1]
            checkPriceDetailLabel()
            priceView2.addSubview(inputMonthlyRentStackView)
            priceDetailLabel2 = priceDetailLabels[4]
            inputMonthlyRentStackView.addArrangedSubview(fourDisitMonthlyRentField)
            inputMonthlyRentStackView.addArrangedSubview(priceDetailLabels[6])
            if let priceDetailLabel2 = priceDetailLabel2 {
                priceView2.addSubview(priceDetailLabel2)
                priceDetailLabel2.snp.makeConstraints {
                    $0.centerY.equalTo(priceView2.snp.centerY)
                    $0.top.equalTo(priceView2.snp.top).offset(8)
                    $0.leading.equalTo(priceView2.snp.leading).offset(24)
                }
                inputMonthlyRentStackView.snp.makeConstraints {
                    $0.leading.equalTo(priceDetailLabel2.snp.trailing).offset(16)
                    $0.centerY.equalTo(priceView2.snp.centerY)
                    $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.1)
                    $0.top.equalTo(priceView2.snp.top).offset(8)
                }
                fourDisitMonthlyRentField.snp.makeConstraints {
                    $0.top.equalTo(priceView2.snp.top).offset(4)
                    $0.centerY.equalTo(priceView2.snp.centerY)
                }
            }
        }
        selectedMoveTypeButton = sender.isSelected ? sender : nil
    }
    
    func checkPriceDetailLabel() {
        if let priceDetailLabel = priceDetailLabel {
            priceView.addSubview(priceDetailLabel)
            priceView.addSubview(inputPriceStackView)
            priceDetailLabel.snp.makeConstraints {
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.top.equalTo(priceView.snp.top).offset(8)
                $0.leading.equalTo(priceView.snp.leading).offset(24)
            }
            inputPriceStackView.snp.makeConstraints {
                $0.leading.equalTo(priceDetailLabel.snp.trailing).offset(16)
                $0.centerY.equalTo(priceView.snp.centerY)
                $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5)
                $0.top.equalTo(priceView.snp.top).offset(8)
            }
        }
    }
    
    @objc func searchAddressButtonTapped(_ sender: UIButton) {
        let KakaoZipCodeVC = KakaoZipCodeViewController()
        present(KakaoZipCodeVC, animated: true)
    }
    
    @objc func backToPageTapped(_ sender: UIButton) {
        let warningPopup = OpenNewPagePopupViewController()
//        warningPopup.warningDelegate = self
        warningPopup.modalPresentationStyle = .overCurrentContext
        present(warningPopup, animated: false, completion: nil)
    }

    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        let newPageViewController = CheckListViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(newPageViewController, animated: true)
    }
}


extension EditBasicInfoDetailViewController: UITextFieldDelegate {
    
    func updateTextFieldWidthConstraint(for textField: UITextField, constant: CGFloat) {
        guard let text = textField.text else { return }
        // 기존의 widthAnchor로 업데이트
        if text.isEmpty {
            for constraint in textField.constraints where constraint.firstAttribute == .width {
                constraint.constant = constant
            }
        } else {
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        // 각 텍스트 필드에 대한 최소, 최대 너비 설정
        let minimumWidth: CGFloat = 30 // 최소 너비
        var maximumWidth: CGFloat = 74 // 네 자릿수 텍스트 필드의 최대 너비

        if textField == threeDisitPriceField {
            maximumWidth = 60 // 세 자릿수 텍스트 필드의 최대 너비
        }
        
        // 텍스트 길이에 따라 적절한 너비 계산
        let size = text.size(withAttributes: [.font: textField.font ?? UIFont.systemFont(ofSize: 17)])
        let calculatedWidth = max(size.width + 20, minimumWidth) // 텍스트 길이와 최소 너비 중 큰 값을 선택
        let finalWidth = min(calculatedWidth, maximumWidth) // 최대 너비 제한

        // 너비 제약 업데이트
        updateTextFieldWidthConstraint(for: textField, constant: finalWidth)

        // 레이아웃 업데이트
        view.layoutIfNeeded()
        
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        // textField에 따라 글자 수 제한
        if textField == houseNicknameTextField {
            guard textField.text!.count < 12 else { return false }
        } else if textField == threeDisitPriceField || textField == fourDisitPriceField
                    || textField == fourDisitMonthlyRentField  {
            // 숫자만 허용
            guard Int(string) != nil || string == "" else { return false }
            
            if textField == threeDisitPriceField {
                guard textField.text!.count < 3 else { return false }
            } else if textField == fourDisitPriceField || textField == fourDisitMonthlyRentField {
                guard textField.text!.count < 4 else { return false }
            }
        }
    
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "" // 입력 시작 시 placeholder를 숨김
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty ?? true else { return }
        if textField == threeDisitPriceField {
            textField.placeholder = "000"
            updateTextFieldWidthConstraint(for: textField, constant: 60) // 기존 너비로 복원
        } else if textField == fourDisitPriceField || textField == fourDisitMonthlyRentField {
            textField.placeholder = "0000"
            updateTextFieldWidthConstraint(for: textField, constant: 74)
        }
    }
}
