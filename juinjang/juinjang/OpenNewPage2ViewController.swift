//
//  OpenNewPage2ViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/03.
//

import UIKit

class OpenNewPage2ViewController: UINavigationController, UITextFieldDelegate {
    
    var backgroundImageViewWidthConstraint: NSLayoutConstraint? // 배경 이미지의 너비 제약조건
    
    func makeImageView(_ imageView: UIImageView, imageName: String) {
        imageView.image = UIImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
    }
    
    lazy var backgroundImageView = UIImageView().then {
        makeImageView($0, imageName: "creation-background")
    }
    
    lazy var investorImageView = UIImageView().then {
        makeImageView($0, imageName: "investor")
    }
    
    lazy var movingUserImageView = UIImageView().then {
        makeImageView($0, imageName: "user-moving-in-directly")
    }
    
    lazy var apartmentImageView = UIImageView().then {
        makeImageView($0, imageName: "apartment-img")
    }
    
    lazy var villaImageView = UIImageView().then {
        makeImageView($0, imageName: "villa-img")
    }
    
    lazy var houseImageView = UIImageView().then {
        makeImageView($0, imageName: "house-img")
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
    
    lazy var addressTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "상세 주소",
            attributes: [
                .foregroundColor: UIColor(red: 0.788, green: 0.788, blue: 0.788, alpha: 1),
                .font: UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 24)
            ]
        )
        $0.textColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        $0.keyboardType = .numberPad
        if let customFont = UIFont(name: "Pretendard-SemiBold", size: 24) {
            $0.font = customFont
        }
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: $0.frame.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
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
        // Do any additional setup after loading the view.
        addressTextField.delegate = self
        setupWidgets()
    }
    
    func setupWidgets() {
        // 위젯들을 서브뷰로 추가
        let widgets: [UIView] = [addressLabel, houseNicknameLabel, backgroundImageView, backButton, nextButton]
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
//        NSLayoutConstraint.activate([
//            addressTextField.widthAnchor.constraint(equalToConstant: 58),
//            addressTextField.heightAnchor.constraint(equalToConstant: 22),
////            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
//            addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 7),
//        ])
        
        // 집 별명 Label
        NSLayoutConstraint.activate([
            houseNicknameLabel.widthAnchor.constraint(equalToConstant: 66),
            houseNicknameLabel.heightAnchor.constraint(equalToConstant: 24),
            houseNicknameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width * -0.35),
//            houseNicknameLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 35)
        ])
        
        // 집 별명 TextField
        
        // 이전으로 버튼
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 109),
            backButton.heightAnchor.constraint(equalToConstant: 52),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])

        // 다음으로 버튼
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 225),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])

    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        let customPopup = CustomPopupViewController()
        customPopup.modalPresentationStyle = .overCurrentContext
        present(customPopup, animated: false, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
