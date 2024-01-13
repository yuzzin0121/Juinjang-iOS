//
//  RecordBottomSheetViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/09.
//

import UIKit

class RecordBottomSheetViewController: UIViewController {
    
    let dimmedView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let totalHeight: CGFloat = 844 // 전체 높이
    let ratio: CGFloat = 392 // Bottom Sheet가 차지하는 높이

    var bottomSheetHeight: CGFloat {
        return (ratio / totalHeight) * UIScreen.main.bounds.height // 디바이스가 달라져도 비율만큼 차지
    }
    
    lazy var cancelButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "cancel-black"), for: .normal)
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var warningMessageLabel = UILabel().then {
        $0.text = "녹음 파일을 법적인 상황에서 활용하려면\n반드시 녹음한 사람의 목소리가 함께 들어가야 해요."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.asColor(targetString: "녹음한 사람의 목소리가 함께", color: UIColor(named: "mainOrange"))
    }
    
    lazy var warningMessageImage = UIImageView().then {
        $0.image = UIImage(named: "record-check-image")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var checkButton = UIButton().then {
        $0.setTitle("오늘 하루 보지 않기", for: .normal)
        $0.setTitleColor(UIColor(named: "normalText"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage(named: "record-check-off"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit

        $0.semanticContentAttribute = .forceLeftToRight
        $0.contentHorizontalAlignment = .left
    
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
    }

    lazy var recordStartButton = UIButton().then {
        $0.setTitle("녹음 시작!", for: .normal)
        $0.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(named: "textBlack")
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(confirmButtonPressed(_:)), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    lazy var recordLabel = UILabel().then {
        $0.text = "녹음하기"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textWhite")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    lazy var timeLabel = UILabel().then {
        $0.text = "00:18.79"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "lightGray")
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    lazy var recordsttLabel = UILabel().then {
        $0.text = "speech to text 적용 중"
        $0.textAlignment = .center
        $0.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    lazy var trashButton = UIButton().then {
        $0.setImage(UIImage(named: "record-trash"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    lazy var recordButton = UIButton().then {
        $0.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(startRecordPressed(_:)), for: .touchUpInside)
    }
    
    lazy var completedButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.addTarget(self, action: #selector(completedButtonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var sttConversionLabel = UILabel().then {
        $0.text = "speech to text 변환 중..."
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textWhite")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
//    lazy var topViewController = TopViewController()
//    lazy var bottomViewController = BottomViewController()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupLayout()
        
        dimmedView.alpha = 0.0
        dimmedView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    func addSubViews() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        
        let widgets: [UIView] = [
            cancelButton,
            warningMessageLabel,
            warningMessageImage,
            checkButton,
            recordStartButton]
        widgets.forEach { bottomSheetView.addSubview($0) }
    }
    
    func setupLayout() {
        dimmedView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(bottomSheetHeight)
        }
        
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(12)
            $0.width.equalTo(12)
//            $0.leading.equalTo(bottomSheetView.snp.leading).offset(354)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-24)
            $0.top.equalTo(bottomSheetView.snp.top).offset(29)
        }
        
        warningMessageLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(cancelButton.snp.bottom).offset(4)
        }
        
        let ratio: CGFloat = 294.07 / 114.61
        
        warningMessageImage.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(warningMessageLabel.snp.bottom).offset(28.88)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(55)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-55)
            $0.height.equalTo(warningMessageImage.snp.width).dividedBy(ratio)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(warningMessageImage.snp.bottom).offset(38.51)
        }
        
        recordStartButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(warningMessageImage.snp.bottom).offset(74.51)
            $0.bottom.equalTo(bottomSheetView.snp.bottom).offset(-33)
//            $0.bottom.equalTo(bottomSheetView.snp.bottom).multipliedBy(0.9)
        }
    }
    
    func addRecordSubViews() {
        let widgets: [UIView] = [
            recordLabel,
            timeLabel,
            recordsttLabel,
            trashButton,
            recordButton,
            completedButton
        ]
        widgets.forEach { bottomSheetView.addSubview($0) }
    }
    
    func setRecordLayout() {
        cancelButton.setImage(UIImage(named: "cancel-white"), for: .normal)
        
        recordLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(bottomSheetView.snp.top).offset(24)
//            $0.leading.equalTo(bottomSheetView.snp.leading).offset(164)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(recordLabel.snp.bottom).offset(34)
        }
        
        recordsttLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(recordLabel.snp.bottom).offset(117)
        }
        
        trashButton.snp.makeConstraints {
            $0.top.equalTo(recordsttLabel.snp.bottom).offset(52)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(39)
        }
        
        recordButton.snp.makeConstraints {
            $0.leading.equalTo(trashButton.snp.trailing).offset(90)
            $0.top.equalTo(recordsttLabel.snp.bottom).offset(39)
        }
        
        completedButton.snp.makeConstraints {
            $0.leading.equalTo(recordButton.snp.trailing).offset(90)
            $0.top.equalTo(recordsttLabel.snp.bottom).offset(58)
            $0.height.equalTo(24)
        }
    }
    
    func addConversionSubViews() {
        let widgets: [UIView] = [
            sttConversionLabel,
        ]
        widgets.forEach { bottomSheetView.addSubview($0) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.sttConversionLabel.removeFromSuperview()
//            self.bottomSheetView.addSubview(self.topViewController.view)
//            self.bottomSheetView.addSubview(self.bottomViewController.view)
//            self.configureBottomSheetViewController()
        }
    }

    
    func setConversionLayout() {
        sttConversionLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(bottomSheetView.snp.top).offset(87)
        }
    }
    
//    func configureBottomSheetViewController() {
//        let topViewControllerHeight: CGFloat = topViewController.relativeHeight * totalHeight
//        let bottomViewControllerHeight: CGFloat = bottomViewController.relativeHeight * totalHeight
//        let totalBottomSheetHeight: CGFloat = topViewControllerHeight + bottomViewControllerHeight

        // 현재 뷰 컨트롤러인 RecordBottomSheetViewController를 사용
//        let bottomSheetViewController = self

        // Top ViewController 설정
//        addChild(topViewController)
//        bottomSheetView.addSubview(topViewController.view)
//        topViewController.didMove(toParent: self)

        // Bottom ViewController 설정
//        addChild(bottomViewController)
//        bottomSheetView.addSubview(bottomViewController.view)
//        bottomViewController.didMove(toParent: self)

        // 제약 조건 설정
//        topViewController.view.snp.makeConstraints {
//            $0.leading.trailing.equalTo(bottomSheetView)
//            $0.top.equalTo(bottomSheetView)
//            $0.height.equalTo(topViewControllerHeight)  // 상단 높이 조절
//        }

//        bottomViewController.view.snp.makeConstraints {
//            $0.leading.trailing.equalTo(bottomSheetView)
//            $0.top.equalTo(topViewController.view.snp.bottom)
//            $0.bottom.equalTo(bottomSheetView)
//        }

        // Bottom Sheet의 높이 제약 조건 설정
//        bottomSheetViewController.bottomSheetView.snp.makeConstraints {
//            $0.height.equalTo(topViewControllerHeight + bottomViewControllerHeight)
//        }

        // Bottom Sheet ViewController를 화면에 표시
        // 애니메이션 추가
//        UIView.animate(withDuration: 0.25) {
//            self.view.layoutIfNeeded()
//        }
//    }
    
    @objc
    func checkButtonPressed(_ sender: UIButton) {
        if checkButton.isSelected {
            checkButton.setImage(UIImage(named: "record-check-off"), for: .normal)
            recordStartButton.setTitle("녹음 시작!", for: .normal)
        } else {
            checkButton.setImage(UIImage(named: "record-check-on"), for: .normal)
            recordStartButton.setTitle("확인했어요", for: .normal)
        }
        checkButton.isSelected.toggle()
    }
    
    @objc
    func confirmButtonPressed(_ sender: UIButton) {
        bottomSheetView.backgroundColor = UIColor(named: "textBlack")
        let removeWidgets: [UIView] = [
            warningMessageLabel,
            warningMessageImage,
            checkButton,
            recordStartButton]
        removeWidgets.forEach { $0.removeFromSuperview() }
        addRecordSubViews()
        setRecordLayout()
    }
    
    @objc
    func startRecordPressed(_ sender: UIButton) {
        if recordButton.isSelected {
            recordButton.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        } else {
            recordButton.setImage(UIImage(named: "record-button"), for: .normal)
        }
        recordButton.isSelected.toggle()
    }
    
    @objc
    func completedButtonPressed(_ sender: UIButton) {
        let removeWidgets: [UIView] = [
            recordLabel,
            timeLabel,
            recordsttLabel,
            trashButton,
            recordButton,
            completedButton]
        removeWidgets.forEach { $0.removeFromSuperview() }
        addConversionSubViews()
        setConversionLayout()
    }
    
    func showBottomSheet() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    @objc
    func cancelButtonTapped(_ sender: UIButton) {
        hideBottomSheetAndGoBack()
    }
}
