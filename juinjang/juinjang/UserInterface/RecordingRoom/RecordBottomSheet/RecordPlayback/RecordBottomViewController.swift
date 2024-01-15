//
//  RecordBottomViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/15.
//

import UIKit
import SnapKit

class RecordBottomViewController: UIViewController, UITextFieldDelegate {
    
    weak var topViewController: RecordTopViewController?

    lazy var titleTextField = UITextField().then {
        $0.text = "녹음_001"
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "textWhite")
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    lazy var currentTimeLabel = UILabel().then {
        $0.text = "오후 4:00"
        $0.textColor = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 1)
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    lazy var rewindButton = UIButton().then {
        $0.setImage(UIImage(named: "rewind"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
    }
    
    lazy var recordButton = UIButton().then {
        $0.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(startRecordPressed(_:)), for: .touchUpInside)
    }
    
    lazy var fastForwardButton = UIButton().then {
        $0.setImage(UIImage(named: "fast-forward"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "textBlack")
        addSubViews()
        setupLayout()
        titleTextField.delegate = self
    }
    
    func addSubViews() {
        [titleTextField,
         currentTimeLabel,
         rewindButton,
         recordButton,
         fastForwardButton].forEach { view.addSubview($0) }
    }
    
    func setupLayout() {
        titleTextField.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view.snp.top).offset(24)
        }
        
        currentTimeLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
        }
    
        rewindButton.snp.makeConstraints {
//            $0.top.equalTo(currentTimeLabel.snp.bottom).offset(152)
            $0.trailing.equalTo(recordButton.snp.leading).offset(-40)
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalTo(view.snp.bottom).offset(-88)
        }
        
        recordButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
//            $0.top.equalTo(currentTimeLabel.snp.bottom).offset(140)
            $0.bottom.equalTo(view.snp.bottom).offset(-76)
        }
        
        fastForwardButton.snp.makeConstraints {
            $0.leading.equalTo(recordButton.snp.trailing).offset(40)
//            $0.top.equalTo(currentTimeLabel.snp.bottom).offset(152)
            $0.height.equalTo(36)
            $0.width.equalTo(36)
            $0.bottom.equalTo(view.snp.bottom).offset(-88)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 필드가 수정되면 title을 수정
        updateTitle(textField.text)
        topViewController?.updateTitle(textField.text)
    }

    func updateTitle(_ newTitle: String?) {
        if let title = newTitle {
            print("녹음 파일 제목: \(title)")
            titleTextField.text = title
        }
    }
    
    @objc func startRecordPressed(_ sender: UIButton) {
        if recordButton.isSelected {
            recordButton.setImage(UIImage(named: "being-recorded-button"), for: .normal)
        } else {
            recordButton.setImage(UIImage(named: "record-button"), for: .normal)
        }
        recordButton.isSelected.toggle()
    }
}
