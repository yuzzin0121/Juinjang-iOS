//
//  OpenNewPageViewController.swift
//  juinjang
//
//  Created by 임수진 on 2023/12/30.
//
// TODO: 코드 정리 필요

import UIKit
import Then

class OpenNewPageViewController: UINavigationController {
    
    var investmentButtons: [UIButton] = [] // "거래 목적"을 나타내는 선택지
    var propertyTypeButtons: [UIButton] = [] // "매물 유형"을 나타내는 선택지
    
    lazy var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "creation-background")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var purposeLabel = UILabel().then {
        $0.text = "거래 목적"
        $0.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        $0.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13

        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    lazy var realestateInvestmentButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let image = UIImage(named: "realestate-investment-button")
        $0.setBackgroundImage(image, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        // 버튼이 선택되면 이미지가 변경됨
        // 이벤트 처리: 선택된(selected) 상태에서 색상 변경 방지
        $0.adjustsImageWhenHighlighted = false
        let normalImage = UIImage(named: "realestate-investment-button")
        $0.setBackgroundImage(normalImage, for: .normal)
        let selectedImage = UIImage(named: "realstate-investment-selected-button")
        $0.setBackgroundImage(selectedImage, for: .selected)
    }
    
    lazy var moveInDirectlyButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let image = UIImage(named: "move-in-directly-button")
        $0.setBackgroundImage(image, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        // 이벤트 처리: 선택된(selected) 상태에서 색상 변경 방지
        $0.adjustsImageWhenHighlighted = false
        // 버튼이 선택되면 이미지가 변경됨
        let normalImage = UIImage(named: "move-in-directly-button")
        $0.setBackgroundImage(normalImage, for: .normal)
        let selectedImage = UIImage(named: "move-in-directly-selected-button")
        $0.setBackgroundImage(selectedImage, for: .selected)
    }
    
    lazy var typeLabel = UILabel().then {
        $0.text = "매물 유형"
        $0.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        $0.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13

        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    lazy var apartmentButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let image = UIImage(named: "apartment-button")
        $0.setBackgroundImage(image, for: .normal)
        let selectedImage = UIImage(named: "apartment-selected-button")
        $0.setBackgroundImage(selectedImage, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        // 이벤트 처리: 선택된(selected) 상태에서 색상 변경 방지
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var villaButton = UIButton().then {
        // 기본 이미지
        let image = UIImage(named: "villa-button")
        $0.setBackgroundImage(image, for: .normal)
        // 선택된 이미지
        let selectedImage = UIImage(named: "villa-selected-button")
        $0.setBackgroundImage(selectedImage, for: .selected)
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        $0.setBackgroundImage(image, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        // 이벤트 처리: 선택된(selected) 상태에서 색상 변경 방지
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var houseButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let image = UIImage(named: "house-button")
        $0.setBackgroundImage(image, for: .normal)
        let selectedImage = UIImage(named: "house-selected-button")
        $0.setBackgroundImage(selectedImage, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        // 이벤트 처리: 선택된(selected) 상태에서 색상 변경 방지
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var priceLabel = UILabel().then {
        $0.text = "가격"
        $0.frame = CGRect(x: 0, y: 0, width: 66, height: 24)
        $0.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13

        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "새 페이지 펼치기"
        self.navigationController?.navigationBar.tintColor = .black
        // 이미지 로드
//        let backImage = UIImage(named: "arrow-left")
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // Do any additional setup after loading the view.
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        // 이미지 뷰의 가로 사이즈를 부모 뷰와 같도록 설정
        //        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //        // 이미지 뷰의 세로 사이즈를 설정
        //        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        //
        //        // 이미지 뷰의 위치를 네비게이션 바 바로 아래로 설정
        //        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        //        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        setupWidgets()
    }
        

    func setupWidgets() {
        // 위젯들을 서브뷰로 추가
        view.addSubview(purposeLabel)
        view.addSubview(realestateInvestmentButton)
        view.addSubview(moveInDirectlyButton)
        view.addSubview(typeLabel)
        view.addSubview(apartmentButton)
        view.addSubview(villaButton)
        view.addSubview(houseButton)
        view.addSubview(priceLabel)
        view.addSubview(backgroundImageView)
        view.addSubview(nextButton)
        setupLayout()
        setButton()
    }
    
    func setupLayout() {
        
        // 위젯에 관한 Auto Layout 설정
        // 배경 이미지
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 300),
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        // 거래 목적 Label
        purposeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            purposeLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 20),
//            purposeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 350)
            purposeLabel.widthAnchor.constraint(equalToConstant: 66),
            purposeLabel.heightAnchor.constraint(equalToConstant: 24),
            purposeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -138),
        ])
        
        // 거래 목적 Stack View
        let investmentButtonsStackView = UIStackView(arrangedSubviews: [realestateInvestmentButton, moveInDirectlyButton])
        
        investmentButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        investmentButtonsStackView.axis = .horizontal
        investmentButtonsStackView.spacing = 8

        view.addSubview(investmentButtonsStackView)

        NSLayoutConstraint.activate([
            investmentButtonsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            investmentButtonsStackView.topAnchor.constraint(equalTo: purposeLabel.bottomAnchor, constant: 12),
            investmentButtonsStackView.heightAnchor.constraint(equalToConstant: 38),
        ])
        
        // 매물 유형 Label
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeLabel.widthAnchor.constraint(equalToConstant: 66),
            typeLabel.heightAnchor.constraint(equalToConstant: 24),
            typeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -138),
            typeLabel.topAnchor.constraint(equalTo: realestateInvestmentButton.bottomAnchor, constant: 40),
        ])
        
        // 매물 유형 Stack View
        let propertyTypeStackView = UIStackView(arrangedSubviews: [apartmentButton, villaButton, houseButton])

        propertyTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        propertyTypeStackView.axis = .horizontal
        propertyTypeStackView.spacing = 8

        view.addSubview(propertyTypeStackView)

        NSLayoutConstraint.activate([
            propertyTypeStackView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 12),
            propertyTypeStackView.heightAnchor.constraint(equalToConstant: 38),
            propertyTypeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])

        // 가격 Label
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.widthAnchor.constraint(equalToConstant: 31),
            priceLabel.heightAnchor.constraint(equalToConstant: 24),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -155.5),
            priceLabel.topAnchor.constraint(equalTo: propertyTypeStackView.topAnchor, constant: 80) // 임의로 지정
        ])
        
        // 다음으로 버튼
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 342),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 764)
        ])
    
    }
    
    // 각 카테고리에 따른 버튼을 나타내기 위한 처리
    func setButton() {
        // 거래 목적 카테고리의 버튼
        let realEstateButton1 = UIButton()
        let realEstateButton2 = UIButton()
        investmentButtons = [realestateInvestmentButton, moveInDirectlyButton]
        
        // 매물 유형 카테고리의 버튼
        let propertyTypeButton1 = UIButton()
        let propertyTypeButton2 = UIButton()
        propertyTypeButtons = [apartmentButton, villaButton, houseButton]
    }
    
    
    // 버튼이 눌렸을 때 버튼의 색상 변경
    @objc func buttonPressed(_ sender: UIButton) {
        // 해당 버튼의 선택 여부를 반전시킴
        sender.isSelected = !sender.isSelected
    }

    
    @objc func buttonTapped(_ sender: UIButton) {
        // 모든 항목 입력 완료 시 다음으로 버튼 활성화
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
