//
//  EditBasicInfoDetailViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/31/24.
//

import UIKit
import Alamofire

class EditBasicInfoDetailViewController: BaseViewController {
    
    var transactionModel = TransactionModel()
    var imjangId: Int? = nil
    var versionInfo: VersionInfo? = nil
    var selectedPriceType: Int?
    
    var priceTypeButtons: [UIButton] = [] // "가격 유형"을 나타내는 선택지
    var selectedPriceTypeButton: UIButton? // 가격 유형 카테고리의 버튼
    var isMoveTypeSelected: Bool = false
    
    var moveTypeStackView: UIStackView!
    var inputPriceStackView: UIStackView!
    var inputMonthlyRentStackView: UIStackView!
    
    var priceDetailLabel: UILabel?
    var priceDetailLabel2: UILabel?
    
    var delegate: SendDetailEditData?
    
    let contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
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
        $0.textAlignment = .center
        
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
        $0.textAlignment = .center
        
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
        $0.textAlignment = .center
        
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
    
    // -MARK: API 요청
    func getImjang() {
        guard let imjangId = imjangId else { return }
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<DetailDto>.self, api: .detailImjang(imjangId: imjangId)) { detailDto, error in
            if error == nil {
                guard let result = detailDto else { return }
                if let detailDto = result.result {
                    print(detailDto)
                    self.setData(detailDto: detailDto)
                }
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
    
    func modifyImjang(completionHandler: @escaping (NetworkError?) -> Void) {
        guard let imjangId = imjangId else { return }
        let url = JuinjangAPI.modifyImjang(imjangId: imjangId).endpoint
        
        // -MARK: 매매-전세-월세 선택값 가져오기
        var selectedPriceType: Int? = nil
        if saleButton.isSelected == true {
            selectedPriceType = 0
        } else if jeonseButton.isSelected == true {
            selectedPriceType = 1
        } else if monthlyRentButton.isSelected == true {
            selectedPriceType = 2
        }
        
        // -MARK: 가격 리스트 가져오기
        // threeDisitPriceField와 fourDisitPriceField의 값을 합쳐서 selectedPrice에 저장
        let threeDisitPrice = Int(threeDisitPriceField.text ?? "") ?? 0
        let fourDisitPrice = Int(fourDisitPriceField.text ?? "") ?? 0
        var priceList = [String(threeDisitPrice * 100000000 + fourDisitPrice * 10000)]
        
        // fourDisitMonthlyRentField 추가
        if let monthlyRentValue = fourDisitMonthlyRentField.text, !monthlyRentValue.isEmpty {
            if let monthlyRent = Int(monthlyRentValue) {
                priceList.append(String(monthlyRent * 10000))
            }
            print(priceList)
        }
        
        let parameter: Parameters = [
            "limjangId": imjangId,
            "priceType": selectedPriceType,
            "priceList": priceList,
            "address": addressTextField.text ?? "",
            "addressDetail": addressDetailTextField.text ?? "",
            "nickname": houseNicknameTextField.text ?? ""
        ]
        
        print(parameter)
        
        let header : HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
        ]
        
        AF.request(url,
                 method: .patch,
                 parameters: parameter,
                 encoding: JSONEncoding.default,
                   headers: JuinjangAPI.modifyImjang(imjangId: imjangId).header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: BaseResponse<String>.self) { response in
            switch response.result {
            case .success(let success):
                print(success)
                completionHandler(nil)
        
            case .failure(let failure):
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(jsonString)")
                }
                print("Request failed with error: \(failure)")
                print("Bearer \(UserDefaultManager.shared.accessToken)")
                completionHandler(NetworkError.failedRequest)
            }
        }
    }

    override func viewDidLoad() {
        getImjang()
        super.viewDidLoad()
        view.backgroundColor = .white
        setDelegate()
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
    
    func setData(detailDto: DetailDto) {
        addressTextField.text = detailDto.address
        addressDetailTextField.text = detailDto.addressDetail
        houseNicknameTextField.text = detailDto.nickname
        setPriceTypeButton(priceType: detailDto.priceType)
        setPriceLabel(priceList: detailDto.priceList)
    }
    
    func setPriceTypeButton(priceType: Int) {
        if priceType == 0 {
            saleButton.isSelected = true
            isMoveTypeSelected = saleButton.isSelected
            selectedPriceTypeButton = saleButton.isSelected ? saleButton : nil
            setSaleView()
        } else if priceType == 1 {
            jeonseButton.isSelected = true
            isMoveTypeSelected = jeonseButton.isSelected
            selectedPriceTypeButton = jeonseButton.isSelected ? jeonseButton : nil
            setJeonseView()
        } else if priceType == 2 {
            monthlyRentButton.isSelected = true
            isMoveTypeSelected = monthlyRentButton.isSelected
            selectedPriceTypeButton = monthlyRentButton.isSelected ? monthlyRentButton : nil
            setmonthlyRentView()
        }
    }
    
    func setPriceLabel(priceList: [String]) {
        guard !priceList.isEmpty else { return }
        
        switch priceList.count {
        case 1:
            let priceString = priceList[0]
            let (units, remainder) = priceString.twoSplitAmount()
            print("\(units)억 \(remainder)만원")
            threeDisitPriceField.text = units
            if remainder != "0" {
                fourDisitPriceField.text = remainder
            } else {
                fourDisitPriceField.text = ""
            }
        case 2:
            let priceString = priceList[0]
            let (units, remainder) = priceString.twoSplitAmount()
            let monthlyPriceString = priceList[1].oneSplitAmount()
            print("\(units)억 \(remainder)만원")
            print("월 \(monthlyPriceString)만원")
            threeDisitPriceField.text = units
            fourDisitPriceField.text = remainder
            fourDisitMonthlyRentField.text = monthlyPriceString
        default:
            threeDisitPriceField.text = ""
            fourDisitPriceField.text = ""
            fourDisitMonthlyRentField.text = ""
        }
        
        // 텍스트 필드 너비 설정
        let padding: CGFloat = 20
        let minimumWidth: CGFloat = 30
        let threeDisitPriceFieldMaximumWidth: CGFloat = 63
        let fourDisitPriceFieldMaximumWidth: CGFloat = 79
        
        let threeDisitPriceFieldSize = sizeForText(text: threeDisitPriceField.text ?? "", font: threeDisitPriceField.font ?? UIFont.systemFont(ofSize: 17)).width + padding
        let fourDisitPriceFieldSize = sizeForText(text: fourDisitPriceField.text ?? "", font: fourDisitPriceField.font ?? UIFont.systemFont(ofSize: 17)).width + padding
        let fourDisitMonthlyRentFieldSize = sizeForText(text: fourDisitMonthlyRentField.text ?? "", font: fourDisitMonthlyRentField.font ?? UIFont.systemFont(ofSize: 17)).width + padding

        // 최대 너비 제한
        let threeDisitPriceFieldFinalWidth: CGFloat = min(max(threeDisitPriceFieldSize, minimumWidth), threeDisitPriceFieldMaximumWidth)
        let fourDisitMonthlyRentFieldSizeFinalWidth: CGFloat = min(max(fourDisitMonthlyRentFieldSize, minimumWidth), fourDisitPriceFieldMaximumWidth)
        let fourDisitPriceFieldFinalWidth: CGFloat
        if fourDisitPriceField.text?.isEmpty ?? true {
            fourDisitPriceFieldFinalWidth = fourDisitPriceFieldMaximumWidth
        } else {
            fourDisitPriceFieldFinalWidth = min(max(fourDisitPriceFieldSize, minimumWidth), fourDisitPriceFieldMaximumWidth)
        }

        // 너비 제약 업데이트
        updateTextFieldWidthConstraint(for: threeDisitPriceField, constant: threeDisitPriceFieldFinalWidth)
        updateTextFieldWidthConstraint(for: fourDisitPriceField, constant: fourDisitPriceFieldFinalWidth)
        updateTextFieldWidthConstraint(for: fourDisitMonthlyRentField, constant: fourDisitMonthlyRentFieldSizeFinalWidth)
        
        view.layoutIfNeeded()
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
                 priceDetailLabels[3],
                 fourDisitPriceField,
                 priceDetailLabels[5]])

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

        // 저장 버튼
        saveButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.centerX.equalTo(view.snp.centerX).offset(58.5)
            $0.leading.equalTo(view.snp.leading).offset(24)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
            $0.bottom.equalTo(view.snp.bottom).offset(-33)
        }
    }
    
    // 각 카테고리에 따른 버튼을 나타내기 위한 처리
    func setButton() {
        // 입주 유형 카테고리에 속한 버튼
        priceTypeButtons = [saleButton, jeonseButton, monthlyRentButton]
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard !sender.isSelected else { return } // 이미 선택된 버튼이면 아무 동작도 하지 않음
        
        // 매물 유형 카테고리의 버튼일 경우
        if let selectedButton = selectedPriceTypeButton, selectedButton != sender {
            // 이전에 선택된 버튼이 있고 새로운 버튼과 다른 경우에는 이전 버튼의 선택을 해제
            selectedButton.isSelected = false
        }

        // 해당 버튼의 선택 여부를 반전
        sender.isSelected = !sender.isSelected
        isMoveTypeSelected = sender.isSelected

        // 버튼에 따라 가격 View 표시
        if sender == saleButton {
            threeDisitPriceField.text = ""
            fourDisitPriceField.text = ""
            fourDisitMonthlyRentField.text = ""
            setSaleView()
        } else if sender == jeonseButton {
            threeDisitPriceField.text = ""
            fourDisitPriceField.text = ""
            fourDisitMonthlyRentField.text = ""
            setJeonseView()
        } else if sender == monthlyRentButton {
            threeDisitPriceField.text = ""
            fourDisitPriceField.text = ""
            fourDisitMonthlyRentField.text = ""
            setmonthlyRentView()
        }
        selectedPriceTypeButton = sender.isSelected ? sender : nil
        
        // 텍스트 필드 관련
        view.endEditing(true)
        
        updateTextFieldWidthConstraint(for: threeDisitPriceField, constant: 63)
        updateTextFieldWidthConstraint(for: fourDisitPriceField, constant: 79)
        updateTextFieldWidthConstraint(for: fourDisitMonthlyRentField, constant: 79)
    }
    
    private func setSaleView() {
        priceView2.isHidden = true
        priceDetailLabel?.removeFromSuperview()
        priceDetailLabel = priceDetailLabels[0]
        checkPriceDetailLabel()
    }
    
    private func setJeonseView() {
        priceView2.isHidden = true
        priceDetailLabel?.removeFromSuperview()
        priceDetailLabel = priceDetailLabels[2]
        checkPriceDetailLabel()
    }

    private func setmonthlyRentView() {
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        modifyImjang { [weak self] error in
            guard let self else { return }
            if error == nil {
                guard let imjangId, let version = versionInfo?.version else { return }
                let imjangNoteVC = ImjangNoteViewController(imjangId: imjangId, version: version)

                let threeDisitPrice = Int(threeDisitPriceField.text ?? "") ?? 0
                let fourDisitPrice = Int(fourDisitPriceField.text ?? "") ?? 0
                let fourDisitMonthlyRent = Int(fourDisitMonthlyRentField.text ?? "") ?? 0
                var priceList = [String(threeDisitPrice * 100000000 + fourDisitPrice * 10000)]
                
                let separatedPriceList: [String]
                if fourDisitMonthlyRentField.text?.isEmpty == true {
                    separatedPriceList = priceList
                } else {
                    separatedPriceList = [String(threeDisitPrice * 100000000 + fourDisitPrice * 10000), String(fourDisitMonthlyRent * 10000)]
                }
                
                let now = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yy.MM.dd"
                let updatedAt = formatter.string(from: now)
                
                delegate?.sendData(
                    imjangId: imjangId,
                    priceList: separatedPriceList,
                    address: addressTextField.text ?? "",
                    addressDetail: addressDetailTextField.text ?? "",
                    nickname: houseNicknameTextField.text ?? "",
                    updatedAt: updatedAt
                )
                
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                guard let error else { return }
                switch error {
                case .failedRequest:
                    print("failedRequest")
                case .noData:
                    print("noData")
                case .invalidResponse:
                    print("invalidResponse")
                case .invalidData:
                    print("invalidData")
                }
            }
        }
    }
}


extension EditBasicInfoDetailViewController: UITextFieldDelegate {
    func removeAllWidthConstraints(for textField: UITextField) {
        textField.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                textField.removeConstraint(constraint)
            }
        }
    }
    
    func updateTextFieldWidthConstraint(for textField: UITextField, constant: CGFloat) {
        removeAllWidthConstraints(for: textField)
        let widthConstraint = textField.widthAnchor.constraint(equalToConstant: constant)
        widthConstraint.isActive = true
        textField.superview?.layoutIfNeeded()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        // 각 텍스트 필드에 대한 최소, 최대 너비 설정
        let minimumWidth: CGFloat = 30 // 최소 너비
        let padding: CGFloat = 20
        var maximumWidth: CGFloat = 79 // 네 자릿수 텍스트 필드의 최대 너비

        if textField == threeDisitPriceField {
            maximumWidth = 63 // 세 자릿수 텍스트 필드의 최대 너비
        }
        
        // 텍스트 길이에 따라 적절한 너비 계산
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        let size = sizeForText(text: newText, font: textField.font ?? UIFont.systemFont(ofSize: 17)).width + padding
        let calculatedWidth = max(size, minimumWidth) // 텍스트 길이와 최소 너비 중 큰 값을 선택
        let finalWidth = min(calculatedWidth, maximumWidth) // 최대 너비 제한

        // 너비 제약 업데이트
        updateTextFieldWidthConstraint(for: textField, constant: finalWidth)

        // 레이아웃 업데이트
        view.layoutIfNeeded()
        
        // 백스페이스 처리
        if string.isEmpty {
            return true
        }
        
        // textField에 따라 글자 수 제한
        if textField == houseNicknameTextField {
            guard text.count + string.count - range.length <= 12 else { return false }
        } else if textField == threeDisitPriceField || textField == fourDisitPriceField || textField == fourDisitPriceField {
            // 숫자만 허용
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            guard allowedCharacters.isSuperset(of: characterSet) else { return false }
            
            if textField == threeDisitPriceField {
                guard text.count + string.count - range.length <= 3 else { return false }
            } else if textField == fourDisitPriceField || textField == fourDisitMonthlyRentField {
                guard text.count + string.count - range.length <= 4 else { return false }
            }
        }
        return true
    }
    
    func sizeForText(text: String, font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: fontAttributes)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty ?? true else { return }
        if textField == threeDisitPriceField {
            textField.placeholder = "000"
            updateTextFieldWidthConstraint(for: textField, constant: 63) // 기존 너비로 복원
        } else if textField == fourDisitPriceField || textField == fourDisitMonthlyRentField {
            textField.placeholder = "0000"
            updateTextFieldWidthConstraint(for: textField, constant: 79)
        }
    }
}

protocol SendDetailEditData {
    func sendData(imjangId: Int,
                  priceList: [String],
                  address: String,
                  addressDetail: String,
                  nickname: String,
                  updatedAt: String)
}
