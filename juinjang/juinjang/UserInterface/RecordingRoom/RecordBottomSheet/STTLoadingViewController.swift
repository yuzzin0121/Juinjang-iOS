//
//  STTLoadingViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import Lottie
import Speech

class STTLoadingViewController: UIViewController {
    
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
    
    lazy var sttConversionLabel = UILabel().then {
        $0.text = "speech to text 변환 중..."
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textWhite")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
//    lazy var loadingImage = UIImageView().then {
//        $0.image = UIImage(named: "record-loading")
//        $0.contentMode = .scaleAspectFill
//    }
    lazy var animationView = LottieAnimationView(name: "Animation - 1707961785957.json").then {
        $0.frame = CGRect(x: 156, y: 184, width: 73, height: 76)
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
    }
    
    weak var bottomSheetViewController: BottomSheetViewController?
    var imjangId: Int
    var fileURL: URL
    
    init(imjangId: Int, fileURL: URL) {
        self.imjangId = imjangId
        self.fileURL = fileURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomSheetView.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
        startSTT()
    }
    
    // 재생 화면으로 전환
    func showPlaybackVC(transcript: String) {
        let recordPlaybackVC = RecordPlaybackViewController()
        recordPlaybackVC.bottomSheetViewController = bottomSheetViewController
        bottomSheetViewController?.transitionToViewController(recordPlaybackVC)
    }
    
    func startSTT() {
        transcribeAudio() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let script):
                print("STT 성공")
                print(UserDefaultManager.shared.accessToken)
//                showPlaybackVC(transcript: script)
            case .failure(let failure):
                bottomSheetViewController?.transitionToViewController(self)
            }
        }
    }
    
    // 음성 파일에 대해 Speech To Text
    private func transcribeAudio(completionHandler: @escaping (Result<String, STTError>) -> Void) {
        print("STT 시작")
        // 음성 인식 권한 확인
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR")), recognizer.isAvailable else {
            print("Speech recognizer is not available")
            completionHandler(.failure(STTError.isNotAvailable))
            return
        }
        
        // url통해 음성 파일에 대한 음성 인식 요청 객체 생성
        let request = SFSpeechURLRecognitionRequest(url: fileURL)
        recognizer.recognitionTask(with: request) { result, error in
            guard let result, error == nil else {
                print("There was an error: \(error!.localizedDescription)")
                completionHandler(.failure(STTError.resultError))
                return
            }

            if result.isFinal {
                print("Transcription: \(result.bestTranscription.formattedString)")
                completionHandler(.success(result.bestTranscription.formattedString))
            }
        }
        completionHandler(.failure(STTError.resultError))
    }
    
    func addSubViews() {
        view.addSubview(bottomSheetView)
        animationView.play()
        [sttConversionLabel/*,
         loadingImage*/, animationView].forEach { bottomSheetView.addSubview($0) }
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(bottomSheetHeight)
        }
        
        // STT 변환 Label
        sttConversionLabel.snp.makeConstraints {
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
            $0.top.equalTo(bottomSheetView.snp.top).offset(87)
        }
        
        // 로딩 ImageView
//        loadingImage.snp.makeConstraints {
//            $0.top.equalTo(sttConversionLabel.snp.bottom).offset(78)
//            $0.centerX.equalTo(bottomSheetView.snp.centerX)
//        }
    }
}
