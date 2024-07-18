//
//  SettingViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/9/24.
//

import UIKit
import Then
import SnapKit
import Alamofire

struct YourResponseModel: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ResultModel?
}

struct ResultModel: Codable {
    let nickname: String
    let email: String
    let provider: String
    let image: String
}

class SettingViewController : BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let id = "SettingViewController"
    
    //MARK: - 프로필 사진, 닉네임
    var profileImageView = UIImageView().then {
        $0.image = UIImage(named:"profileImage")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 33
        $0.clipsToBounds = true
    }
    var editButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(ColorStyle.mainOrange, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    } //수정 버튼 눌렀을 때 갤러리 들어가게
    
    var nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.textGray
    }
    var nickname = UILabel().then {
        $0.text = UserDefaultManager.shared.nickname
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.textBlack
    }
    var nicknameTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.returnKeyType = .done
        $0.placeholder = "8자 이내"
        $0.text = UserDefaultManager.shared.nickname
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    var nicknameWarnImageView = UIImageView().then {
        $0.image = UIImage(named:"warn")
    }
    var nicknameWarnLabel = UILabel().then {
        $0.text = "닉네임은 8자 이내로 입력해 주세요."
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.mainOrange
    }
    var nicknameSameWarnLabel = UILabel().then {
        $0.text = "동일한 닉네임이 존재해요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.mainOrange
    }
    var saveButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.setTitle("변경", for: .normal)
        $0.backgroundColor = ColorStyle.darkGray
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    var line1 = UIView().then {
        $0.backgroundColor = ColorStyle.strokeGray
    }
    
    //MARK: - 로그인 정보
    var logInfoLabel = UILabel().then {
        $0.text = "로그인 정보"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.textGray
    }
//    var logImageView = UIImageView().then {
//        $0.image = UIImage(named:"KAKAO")
//    }
    var logImageView = UIImageView().then {
        if UserDefaultManager.shared.isKakaoLogin {
            $0.image = UIImage(named: "KAKAO")
        } else {
            $0.image = UIImage(named: "apple-logo")
        }
    }
    var logInfoMailLabel = UILabel().then {
        $0.text = "\(UserDefaultManager.shared.email)"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.textBlack
    }
    var line2 = UIView().then {
        $0.backgroundColor = ColorStyle.gray0
    }
    
    //MARK: - 이용약관, 자주 묻는 질문
    var useButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var useImageView = UIImageView().then {
        $0.image = UIImage(named:"document-text")
    }
    var useLabel = UILabel().then {
        $0.text = "이용약관"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.textBlack
    }
    var qnaButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var qnaImageView = UIImageView().then {
        $0.image = UIImage(named:"Q&A")
    }
    var qnaLabel = UILabel().then {
        $0.text = "자주 묻는 질문"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.textBlack
    }
    var line3 = UIView().then {
        $0.backgroundColor = ColorStyle.gray0
    }
    
    //MARK: - 로그아웃, 계정삭제
    var logoutButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(ColorStyle.mainOrange, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    var line4 = UIView().then {
        $0.backgroundColor = ColorStyle.gray0
    }
    var backgroundView = UIView().then{
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    var accountDeleteButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var accountDeleteLabel = UILabel().then {
        $0.text = "계정 삭제하기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = ColorStyle.textGray
    }
    
    //MARK: - 함수
    func addTarget() {
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        nicknameTextField.addTarget(self, action: #selector(SettingViewController.textFieldDidChange(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(tapChangeButton), for: .touchUpInside)
        useButton.addTarget(self, action: #selector(click1), for: .touchUpInside)
        qnaButton.addTarget(self, action: #selector(click2), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTap), for: .touchUpInside)
        accountDeleteButton.addTarget(self, action: #selector(click4), for: .touchUpInside)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = pickedImage
            saveProfileImage(pickedImage)
            uploadImage(profileImageView.image!)
        }
        picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage) {
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                print("Could not get JPEG representation of image")
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
            ]
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "multipartFile", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: "http://juinjang1227.com:8080/api/profile/image", method: .patch, headers: headers, interceptor: AuthInterceptor())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Response: \(value)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    func loadProfileImage() {
        if let savedImage = UserDefaultManager.shared.profileImage {
            profileImageView.image = savedImage
        }
    }
    func saveProfileImage(_ image: UIImage) {
        UserDefaultManager.shared.profileImage = image
    }
    
    func logout() {
        // 로그아웃 API의 URL
        let urlString = "http://juinjang1227.com:8080/api/auth/logout"
        // Authorization 헤더에 포함할 토큰
        // HTTP 요청 보내기
        AF.request(urlString, method: .post, headers: HTTPHeaders(["Authorization": "Bearer \(UserDefaultManager.shared.refreshToken)"]), interceptor: AuthInterceptor()).responseData { response in
            switch response.result {
            case .success(let data):
                // 응답 확인
                if let httpResponse = response.response {
                    print("Status code: \(httpResponse.statusCode)")
                }
                // 응답 데이터 출력
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        let signupViewController = SignUpViewController()
        // 현재 내비게이션 컨트롤러가 nil인지 확인
        if let navigationController = self.navigationController {
            navigationController.pushViewController(signupViewController, animated: true)
            print("SignUpViewController로 push됨") // 확인용 로그 추가
        } else {
            // 현재 내비게이션 컨트롤러가 없는 경우, 새로운 내비게이션 컨트롤러를 시작하고 SignUpViewController를 rootViewController로 설정
            let navigationController = UINavigationController(rootViewController: signupViewController)
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController = navigationController
                }
            }
            print("SignUpViewController로 새로운 내비게이션 스택 시작됨") // 확인용 로그 추가
        }
        UserDefaultManager.shared.userStatus = false
    }
    @objc func edit() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func click1(_ sender: Any) {
        let vc = UseSelectViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func click2(_ sender: Any) {
        let vc = QnAViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func logoutButtonTap() {
        let popupViewController = LogoutPopupViewController(name: UserDefaultManager.shared.nickname, email: logInfoMailLabel.text!, ment: "계정에서 로그아웃할까요?")
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)
    }
    
    @objc func click4(_ sender: Any) {
        let vc = AccountDeleteViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @objc func tapChangeButton(_ sender: Any) {
        switch saveButton.titleLabel?.text {
        case "변경":
            nicknameTextField.text = nickname.text
            saveButton.setTitle("저장", for: .normal)
            saveButton.backgroundColor = UIColor(named: "mainOrange")
            view.addSubview(nicknameTextField)
            nicknameTextField.delegate = self
            view.addSubview(line1)
            nicknameTextField.snp.makeConstraints{
             $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
             $0.left.equalToSuperview().offset(24)
             $0.width.equalTo(264)
             $0.height.equalTo(23)
            }
            line1.snp.makeConstraints{
                $0.top.equalTo(nicknameTextField.snp.bottom).offset(3)
                $0.left.equalToSuperview().offset(24)
                $0.width.equalTo(264)
                $0.height.equalTo(1)
            }
        case "취소":
            saveButton.setTitle("변경", for: .normal)
            nicknameTextField.removeFromSuperview()
            line1.removeFromSuperview()
        default:
            if nicknameTextField.text == UserDefaultManager.shared.nickname {
                self.saveButton.setTitle("변경", for: .normal)
                self.saveButton.backgroundColor = UIColor(named: "300")
                self.nicknameTextField.removeFromSuperview()
            } else {
                sendNickName(nickname: nicknameTextField.text ?? UserDefaultManager.shared.nickname)
            }
            
        }
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        if nicknameTextField.text!.count < 8 {
            nicknameWarnLabel.removeFromSuperview()
            nicknameWarnImageView.removeFromSuperview()
            nicknameSameWarnLabel.removeFromSuperview()
            nicknameWarnImageView.removeFromSuperview()
            if nicknameTextField.text?.count == 0 {
                saveButton.setTitle("취소", for: .normal)
                saveButton.backgroundColor = UIColor(named: "300")
            }
            else {
                saveButton.setTitle("저장", for: .normal)
                saveButton.backgroundColor = UIColor(named: "mainOrange")
            }
        }
        
    }
    
    @objc func backBtnTap() {
        let mainVC = MainViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func sendNickName(nickname: String) {
        print("sendNickName : \(nickname)")
        
        // 요청 URL 설정
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)", // 예시: 인증 토큰
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "nickname": nickname
        ]

        let urlString = "http://juinjang1227.com:8080/api/nickname"

        AF.request(urlString, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: AuthInterceptor())
            .responseString(encoding: .utf8) { response in
                switch response.result {
                case .success(let value):
                    print("Success: \(value)")
                    if let data = value.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let code = json["code"] as? String {
                        print("Success: \(code)")
                        if code == "NICKNAME4002" {
                            self.view.addSubview(self.nicknameWarnImageView)
                            self.view.addSubview(self.nicknameSameWarnLabel)
                            self.nicknameWarnImageView.snp.makeConstraints{
                                $0.top.equalTo(self.line1.snp.bottom).offset(9)
                                $0.left.equalToSuperview().offset(24)
                                $0.height.equalTo(16)
                            }
                            self.nicknameSameWarnLabel.snp.makeConstraints{
                                $0.top.equalTo(self.line1.snp.bottom).offset(9)
                                $0.left.equalTo(self.nicknameWarnImageView.snp.right).offset(3)
                            }
                        } else if code == "COMMON200" {
                            self.saveButton.setTitle("변경", for: .normal)
                            self.saveButton.backgroundColor = UIColor(named: "300")
                            self.nicknameTextField.removeFromSuperview()
                            self.line1.removeFromSuperview()
                            self.nicknameWarnLabel.removeFromSuperview()
                            self.nicknameWarnImageView.removeFromSuperview()
                            self.nickname.text = self.nicknameTextField.text
                            UserDefaultManager.shared.nickname = nickname
                            self.nicknameSameWarnLabel.removeFromSuperview()
                            self.nicknameWarnImageView.removeFromSuperview()
                        } else {
                            self.nicknameSameWarnLabel.removeFromSuperview()
                            self.nicknameWarnImageView.removeFromSuperview()
                        }
                    } else {
                        print("Failed to extract code from response value.")
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "설정"
        
        let backButtonItem = UIBarButtonItem(image: UIImage(named:"arrow-right"), style: .plain, target: self, action: #selector(backBtnTap))
        backButtonItem.tintColor = ColorStyle.darkGray
        backButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = backButtonItem
    }
    
    func setConstraint() {
        profileImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(66)
        }
        editButton.snp.makeConstraints{
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(editButton.snp.bottom).offset(28)
            $0.left.equalToSuperview().offset(24)
        }
        nickname.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(24)
        }
        saveButton.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.right.equalToSuperview().inset(21)
            $0.height.equalTo(29)
            $0.width.equalTo(64)
        }
        logInfoLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(79)
            $0.left.equalToSuperview().offset(24)
        }
        logImageView.snp.makeConstraints{
            $0.top.equalTo(logInfoLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(24)
            $0.height.width.equalTo(20)
        }
        logInfoMailLabel.snp.makeConstraints{
            $0.top.equalTo(logInfoLabel.snp.bottom).offset(8)
            $0.left.equalTo(logImageView.snp.right).offset(8)
        }
        line2.snp.makeConstraints {
            $0.top.equalTo(logInfoMailLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(4)
        }
        useButton.snp.makeConstraints {
            $0.top.equalTo(line2.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        useImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        useLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalTo(useImageView.snp.right).offset(8)
        }
        qnaButton.snp.makeConstraints {
            $0.top.equalTo(useButton.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        qnaImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        qnaLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalTo(qnaImageView.snp.right).offset(8)
        }
        line3.snp.makeConstraints {
            $0.top.equalTo(qnaImageView.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(4)
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(line3.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(23)
        }
        line4.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(25)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(4)
        }
        accountDeleteButton.snp.makeConstraints {
            $0.top.equalTo(line4.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        accountDeleteLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(23)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("email :\(UserDefaultManager.shared.email)")
        //getUserInfo()
        loadProfileImage()
        designNavigationBar()
        view.addSubview(profileImageView)
        view.addSubview(editButton)
        
        view.addSubview(nicknameLabel)
        view.addSubview(nickname)
        view.addSubview(saveButton)
        view.addSubview(line1)
        view.addSubview(logInfoLabel)
        view.addSubview(logImageView)
        view.addSubview(logInfoMailLabel)
        view.addSubview(line2)
        
        view.addSubview(useButton)
        useButton.addSubview(useImageView)
        useButton.addSubview(useLabel)
        
        view.addSubview(qnaButton)
        qnaButton.addSubview(qnaImageView)
        qnaButton.addSubview(qnaLabel)
        view.addSubview(line3)
        
        view.addSubview(logoutButton)
        view.addSubview(line4)
        
        view.addSubview(accountDeleteButton)
        accountDeleteButton.addSubview(accountDeleteLabel)
        
        view.backgroundColor = .white
        //setUserInfo()
        addTarget()
        setConstraint()
    }
}

//MARK: - Extension
extension SettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard nicknameTextField.text!.count < 8
        else {
            view.addSubview(nicknameWarnImageView)
            view.addSubview(nicknameWarnLabel)
            nicknameWarnImageView.snp.makeConstraints{
                $0.top.equalTo(line1.snp.bottom).offset(9)
                $0.left.equalToSuperview().offset(24)
                $0.height.equalTo(16)
            }
            nicknameWarnLabel.snp.makeConstraints{
                $0.top.equalTo(line1.snp.bottom).offset(9)
                $0.left.equalTo(nicknameWarnImageView.snp.right).offset(3)
            }
            return false
        }
        
        nicknameWarnLabel.removeFromSuperview()
        nicknameWarnImageView.removeFromSuperview()
        return true
    }
}
