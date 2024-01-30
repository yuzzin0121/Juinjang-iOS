//
//  ToSViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import UIKit

class ToSViewController: UIViewController {
    
    var selectedIndexPath: IndexPath?
    
    lazy var guideLabel = UILabel().then {
        $0.text = "주인장 서비스의\n이용 약관에 동의해 주세요"
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.textColor = UIColor(named: "normalText")
        $0.font = .pretendard(size: 24, weight: .bold)
        $0.asColor(targetString: "이용 약관", color: UIColor(named: "mainOrange"))
    }
    
    lazy var guideDetailLabel = UILabel().then {
        $0.text = "원활한 서비스 이용을 위해 약관 동의가 필요해요."
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textGray")
        $0.font = .pretendard(size: 16, weight: .medium)
    }
    
    lazy var agreeToAllTermsView = UIView().then {
        $0.backgroundColor = UIColor(named: "lightBackgroundOrange")
        $0.layer.cornerRadius = 10
    }
    
    lazy var checkButton = UIButton().then {
        $0.setTitle("약관 모두 동의하기", for: .normal)
        $0.setTitleColor(UIColor(named: "textBlack"), for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
        $0.adjustsImageWhenHighlighted = false // 버튼이 눌릴 때 색상 변경 방지

        $0.setImage(UIImage(named: "record-check-off"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill

        $0.semanticContentAttribute = .forceLeftToRight
        $0.contentHorizontalAlignment = .left
    
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 4)
    }
    
    var isChecked = false {
        didSet {
            // 체크 버튼이 눌릴 때마다 리로드
            itemtableView.reloadData()
        }
    }
    
    lazy var itemtableView = UITableView().then {
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(ToSItemTableViewCell.self, forCellReuseIdentifier: ToSItemTableViewCell.identifier)
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        $0.backgroundColor = UIColor(named: "lightGray")
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        itemtableView.delegate = self
        itemtableView.dataSource = self
        setNavigationBar()
        addSubViews()
        setupLayout()
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage(named: "arrow-left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func addSubViews() {
        [guideLabel,
         guideDetailLabel,
         agreeToAllTermsView,
         itemtableView,
         nextButton].forEach { view.addSubview($0) }
        agreeToAllTermsView.addSubview(checkButton)
    }
    
    func setupLayout() {
        // 안내 Label
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0.04 * view.bounds.height)
            $0.leading.equalTo(24)
        }

        // 안내 상세 Label
        guideDetailLabel.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(0.06 * view.bounds.height)
            $0.height.lessThanOrEqualTo(0.08 * view.bounds.height)
            $0.leading.equalTo(24)
        }
        
        // 약관 모두 동의 Container View
        agreeToAllTermsView.snp.makeConstraints {
            $0.top.equalTo(guideDetailLabel.snp.bottom).offset(151)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(63)
        }
        
        // 약관 모두 동의 Button
        checkButton.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.equalToSuperview().offset(27)
            $0.top.equalToSuperview().offset(20)
        }
        
        checkButton.bringSubviewToFront(agreeToAllTermsView)
        
        // 약관 동의 tableView
        itemtableView.snp.makeConstraints {
            $0.height.equalTo(189)
            $0.top.equalTo(agreeToAllTermsView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }

        // 다음으로 Button
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(52)
        }
    }
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        isChecked = !isChecked
        if isChecked {
            print("선택")
            checkButton.setImage(UIImage(named: "record-check-on"), for: .normal)
            nextButton.backgroundColor = UIColor(named: "textBlack")
            nextButton.isEnabled = true
        } else {
            print("선택 해제")
            checkButton.setImage(UIImage(named: "record-check-off"), for: .normal)
            nextButton.backgroundColor = UIColor(named: "lightGray")
            nextButton.isEnabled = false
        }
    }
    
    @objc func backButtonTapped() {
        let SignupPopupVC = SignupPopupViewController()
        SignupPopupVC.modalPresentationStyle = .overCurrentContext
        present(SignupPopupVC, animated: false, completion: nil)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let setNickNameVC = SetNickNameViewController()
        setNickNameVC.modalPresentationStyle = .fullScreen
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(setNickNameVC, animated: true)
    }
}

extension ToSViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsOfService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ToSItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: ToSItemTableViewCell.identifier, for: indexPath) as? ToSItemTableViewCell else {
            return UITableViewCell()
        }
        
        let toSItem = termsOfService[indexPath.row]
        
        let cleanedContent = toSItem.content.replacingOccurrences(of: "\\", with: "") // 백 슬래쉬 제거
        let attributedString = NSMutableAttributedString(string: cleanedContent)
        
        // cleanedContent에 "(필수)"가 포함되어 있는지 확인
        if let range = cleanedContent.range(of: "(필수)") {
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "mainOrange")!, range: NSRange(range, in: cleanedContent))
        // "(선택)"이 포함되어 있는지 확인
        } else if let range = cleanedContent.range(of: "(선택)") {
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "textGray")!, range: NSRange(range, in: cleanedContent))
        }
        
        cell.checkButton.tag = indexPath.row
        cell.checkButton.setAttributedTitle(attributedString, for: .normal)
        cell.configure(with: toSItem, isChecked: isChecked)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
}
