//
//  OpenNewPage2ViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/03.
//

import UIKit
import Then

class OpenNewPage2ViewController: UIViewController, UITextFieldDelegate {
    
    var backgroundImageViewWidthConstraint: NSLayoutConstraint? // 배경 이미지의 너비 제약조건
    
    var transactionModel = TransactionModel()
    
    func makeImageView(_ imageView: UIImageView, imageName: String) {
        imageView.image = UIImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
    }
    
    lazy var backgroundImageView = UIImageView().then {
        let backgroundImage = UIImage(named: "creation-background")
        $0.image = backgroundImage
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var investorImageView = UIImageView().then {
        makeImageView($0, imageName: "investor")
    }
    
    lazy var movingUserImageView = UIImageView().then {
        makeImageView($0, imageName: "user-moving-in-directly")
    }
    
    lazy var apartmentImageView = UIImageView().then {
        makeImageView($0, imageName: "apartment")
    }
    
    lazy var villaImageView = UIImageView().then {
        makeImageView($0, imageName: "villa")
    }
    
    lazy var officetelImageView = UIImageView().then {
        makeImageView($0, imageName: "officetel")
    }
    
    lazy var officetelImageView = UIImageView().then {
        makeImageView($0, imageName: "officetel")
    }
    
    lazy var houseImageView = UIImageView().then {
        makeImageView($0, imageName: "house")
    }
    
    func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        label.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13

        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }

    lazy var addressLabel = UILabel().then {
        configureLabel($0, text: "주소")
    }

    lazy var houseNicknameLabel = UILabel().then {
        configureLabel($0, text: "집 별명")
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
        $0.layer.backgroundColor = UIColor(red: 0.971, green: 0.971, blue: 0.971, alpha: 1).cgColor
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var searchAddressButton = UIButton().then {
        $0.setTitle("주소 검색하기", for: .normal)
        $0.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.358, green: 0.363, blue: 0.371, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(searchAddressButtonTapped(_:)), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
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
            $0.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
            $0.textColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
            $0.font = customFont
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
            $0.leftView = paddingView
            $0.leftViewMode = .always
            $0.translatesAutoresizingMaskIntoConstraints = false
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
            $0.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
            $0.textColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
            $0.font = customFont
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.height))
            $0.leftView = paddingView
            $0.leftViewMode = .always
            $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var backButton = UIButton().then {
        $0.setTitle("이전으로", for: .normal)
        $0.setTitleColor(UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.navigationItem.title = "새 페이지 펼치기"
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage(named: "arrow-left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backToMainTapped))
        navigationItem.leftBarButtonItem = backButton
        addressTextField.delegate = self
        addressTextField.isUserInteractionEnabled = false // 사용자 입력 방지
        houseNicknameTextField.delegate = self
        updateImageViewsFromModel()
        setupWidgets()
    }
    
    func setupWidgets() {
        // 위젯들을 서브뷰로 추가
        let widgets: [UIView] = [addressLabel, houseNicknameLabel, backgroundImageView, addressTextField, searchAddressButton, addressDetailTextField, explanationLabel, houseNicknameTextField, backButton, nextButton]
        widgets.forEach { view.addSubview($0) }
        setupLayout()
    }
    
    func setupLayout() {
        // 배경 ImageView
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
            //            backgroundImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -13.5)
            backgroundImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
        
        // 주소 Label
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 35),
            addressLabel.widthAnchor.constraint(equalToConstant: 66),
            addressLabel.heightAnchor.constraint(equalToConstant: 24),
            addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width * -0.35)
        ])
        
        // 주소 TextField
        NSLayoutConstraint.activate([
            addressTextField.widthAnchor.constraint(equalToConstant: 225),
            addressTextField.heightAnchor.constraint(equalToConstant: 36),
            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12)
        ])
        
        // 주소 검색하기 Button
        NSLayoutConstraint.activate([
            searchAddressButton.widthAnchor.constraint(equalToConstant: 109),
            searchAddressButton.heightAnchor.constraint(equalToConstant: 36),
            searchAddressButton.leadingAnchor.constraint(equalTo: addressTextField.trailingAnchor, constant: 8),
            searchAddressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchAddressButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12)
        ])
        
        // 상세주소 TextField
        NSLayoutConstraint.activate([
//            addressDetailTextField.widthAnchor.constraint(equalToConstant: 109),
            addressDetailTextField.heightAnchor.constraint(equalToConstant: 36),
            addressDetailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addressDetailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addressDetailTextField.topAnchor.constraint(equalTo: searchAddressButton.bottomAnchor, constant: 8)
        ])

        // 집 별명 Label
        NSLayoutConstraint.activate([
            houseNicknameLabel.widthAnchor.constraint(equalToConstant: 66),
            houseNicknameLabel.heightAnchor.constraint(equalToConstant: 24),
            houseNicknameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width * -0.35),
            houseNicknameLabel.topAnchor.constraint(equalTo: addressDetailTextField.bottomAnchor, constant: 40)
        ])
        
        // 별명 설명 Label
        NSLayoutConstraint.activate([
            explanationLabel.leadingAnchor.constraint(equalTo: houseNicknameLabel.trailingAnchor, constant: 1),
//            explanationLabel.topAnchor.constraint(equalTo: addressDetailTextField.bottomAnchor, constant: 43),
            explanationLabel.bottomAnchor.constraint(equalTo: houseNicknameTextField.topAnchor, constant: -14)
        ])
        
        // 집 별명 TextField
        NSLayoutConstraint.activate([
            houseNicknameTextField.heightAnchor.constraint(equalToConstant: 36),
            houseNicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            houseNicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            houseNicknameTextField.topAnchor.constraint(equalTo: houseNicknameLabel.bottomAnchor, constant: 12)
        ])
        
        // 이전으로 버튼
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 52),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -116.5),
//            backButton.topAnchor.constraint(equalTo: houseNicknameTextField.bottomAnchor, constant: 182),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])

        // 다음으로 버튼
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 58.5),
//            nextButton.topAnchor.constraint(equalTo: houseNicknameTextField.bottomAnchor, constant: 182),
            nextButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        // 글자 수 제한
        guard textField.text!.count < 12 else { return false }
        return true
    }
    
    func updateImageViewsFromModel() {
        hideAllImageViews()
        
        if transactionModel.selectedPurposeButtonImage == investorImageView.image {
            investorImageView.isHidden = false
            backgroundImageView.addSubview(investorImageView)
            NSLayoutConstraint.activate([
                investorImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -15),
                investorImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -258.67),
                investorImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 105)
            ])
        } else {
            movingUserImageView.isHidden = false
            backgroundImageView.addSubview(movingUserImageView)
            NSLayoutConstraint.activate([
                movingUserImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -14.84),
                movingUserImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -255.55),
                movingUserImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 110)
            ])
        }
        
        if transactionModel.selectedPropertyTypeButtonImage == apartmentImageView.image {
            apartmentImageView.isHidden = false
            backgroundImageView.addSubview(apartmentImageView)
            NSLayoutConstraint.activate([
                apartmentImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -13),
                apartmentImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -95),
                apartmentImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 27)
            ])
        } else if transactionModel.selectedPropertyTypeButtonImage == villaImageView.image {
            villaImageView.isHidden = false
            backgroundImageView.addSubview(villaImageView)
            NSLayoutConstraint.activate([
                villaImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -14.5),
                villaImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -95),
                villaImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 82)
            ])
        } else if transactionModel.selectedPropertyTypeButtonImage == officetelImageView.image {
            officetelImageView.isHidden = false
            backgroundImageView.addSubview(officetelImageView)
            NSLayoutConstraint.activate([
                officetelImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -14.5),
                officetelImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -95),
                officetelImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 37)
            ])
        } else {
            houseImageView.isHidden = false
            backgroundImageView.addSubview(houseImageView)
            NSLayoutConstraint.activate([
                houseImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -14.84),
                houseImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -91),
                houseImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 102)
            ])
        }
    }
    
    func hideAllImageViews() {
        investorImageView.isHidden = true
        movingUserImageView.isHidden = true
        apartmentImageView.isHidden = true
        villaImageView.isHidden = true
        officetelImageView.isHidden = true
        houseImageView.isHidden = true
    }
    
    @objc func searchAddressButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "주소를 검색해주세요.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func backToMainTapped(_ sender: UIButton) {
        let customPopup = CustomPopupViewController()
        customPopup.modalPresentationStyle = .overCurrentContext
        present(customPopup, animated: false, completion: nil)
    }

    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        let newPageViewController = OpenNewPage2ViewController() // 체크리스트 화면으로 나중에 변경
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(newPageViewController, animated: true)
    }
}
