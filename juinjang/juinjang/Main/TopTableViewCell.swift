//
//  TopTableViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 12/31/23.
//

import UIKit

public protocol TypographyExtensions: UILabel {
    
    var lineHeight: CGFloat? { get set }
}

class TopTableViewCell: UITableViewCell {
    
    static let identifier = "TopTableViewCell"
    //MARK: - 변수 설정
    //환영멘트
    var greetLabel = UILabel().then {
        $0.text = "반가워요, 땡땡님\n오늘은 어떤 집으로 가볼까요?"
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.lineHeight = 33.6
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0.0
    }
    
    //나의 임장노트
    var myNoteButton = UIButton().then {
        $0.backgroundColor = UIColor(named: "juinjang")
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
        //$0.alpha = 0.0
    }
    
    var myNoteLabel = UILabel().then {
        $0.text = "나의 임장노트"
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-ExtraBold", size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var myNoteImageView = UIImageView().then {
        $0.image = UIImage(named:"threeLogo")
    }
    
   //새 페이지 펼치기
    var newImjangButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "newPage"), for: .normal)
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
       // $0.alpha = 0.0
    }
    
    var newPageImageView = UIImageView().then {
        $0.image = UIImage(named:"newPageLable")
        $0.contentMode = .scaleAspectFit
    }
    
    var newPageLabel = UILabel().then {
        $0.text = "새 페이지 펼치기"
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-ExtraBold", size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        autoLayout()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    
    //MARK: - 함수 구현
    private func addContentView() {
        contentView.addSubview(greetLabel)
        greetLabel.asColor(targetString: "땡땡", color: UIColor.juinjang)
        
        contentView.addSubview(myNoteButton)
        myNoteButton.addSubview(myNoteLabel)
        myNoteButton.addSubview(myNoteImageView)
        
        contentView.addSubview(newImjangButton)
        newImjangButton.addSubview(newPageImageView)
        newImjangButton.addSubview(newPageLabel)
        newPageLabel.asColor(targetString: "새 페이지", color: UIColor.juinjang)
    }
        
    private func autoLayout() {
        //환영멘트
        greetLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(76)
            $0.left.right.equalToSuperview().inset(24)
            
        }
        UIView.animate(withDuration: 1.5, delay: 0.6, options: .curveEaseIn, animations: {
            self.greetLabel.alpha = 1.0
        }, completion: nil)
        
        //나의 임장노트
        myNoteButton.snp.makeConstraints{
            $0.top.equalTo(greetLabel.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(99)
        }
        
        UIView.animate(withDuration: 1.5, delay: 0.8, options: .curveEaseIn, animations: {
            self.myNoteButton.alpha = 1.0
        }, completion: nil)
        
        myNoteLabel.snp.makeConstraints{
            $0.top.equalTo(myNoteButton.snp.top).offset(36)
            $0.left.equalTo(myNoteButton.snp.left).offset(24)
            $0.width.equalTo(113)
        }
        
        myNoteImageView.snp.makeConstraints{
            $0.top.equalTo(myNoteButton.snp.top).offset(28)
            $0.right.equalTo(myNoteButton.snp.right).offset(-28)
        }
        
        //새 페이지 구현
        newImjangButton.snp.makeConstraints{
            $0.top.equalTo(myNoteButton.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(136)
        }
        
        UIView.animate(withDuration: 1.5, delay: 1.0, options: .curveEaseIn, animations: {
            self.newImjangButton.alpha = 1.0
        }, completion: nil)
        
        newPageLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(87)
            $0.right.equalToSuperview().inset(22)
        }
    }
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        } else {
            return 260
        }
    }*/
}

//MARK: - extension
extension UILabel {
    func asColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}

extension UILabel: TypographyExtensions {
    public var lineHeight: CGFloat? {
        get { nil }
        set {
            // Values.
            let lineHeight = newValue ?? font.lineHeight
            let baselineOffset = (lineHeight - font.lineHeight) / 2.0 / 2.0
            
            // Paragraph style.
            let mutableParagraphStyle = NSMutableParagraphStyle()
            mutableParagraphStyle.minimumLineHeight = lineHeight
            mutableParagraphStyle.maximumLineHeight = lineHeight
            
            // Set.
            attributedText = NSAttributedString(
                string: text ?? "",
                attributes: [
                    .baselineOffset : baselineOffset,
                    .paragraphStyle : mutableParagraphStyle
                ]
            )
        }
    }
}
