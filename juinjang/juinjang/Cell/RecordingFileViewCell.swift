//
//  RecordingFileViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/6/24.
//

import UIKit
import SnapKit
import Then
import AVFoundation

protocol RecordingTableViewCellDelegate: AnyObject{
    func updateRecordingFileName(_ newName: String)
}

class RecordingFileViewCell: UITableViewCell {
    
    var audioPlayer: AVAudioPlayer?
    var recordingURL: URL?
    
    let recordingFileNameLabel = UILabel().then {
        $0.font = .pretendard(size: 18, weight: .semiBold)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    let recordedDateLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = UIColor(named: "gray1")
    }
    
    var recordedTimeLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = UIColor(named: "textBlack")
        $0.textAlignment = .right
    }
    
    var playButton = UIButton().then {
        $0.setImage(UIImage(named: "play"), for: .normal)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [recordingFileNameLabel, recordedDateLabel, recordedTimeLabel, playButton].forEach {
            addSubview($0)
        }
        setConstraints()
        playButton.isUserInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //var playButtonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.setData(fileTitle: nil, time: nil, date: nil)
        //self.setData(fileItem: nil)
    }
    
    //데이터 넣기
    func setData(fileItem: RecordResponse?) {
        guard let fileItem = fileItem else { return }
        recordingFileNameLabel.text = fileItem.recordName
        recordedDateLabel.text = DateFormatterManager.shared.formattedUpdatedDate(fileItem.updatedAt)
        recordedTimeLabel.text = String.formatSeconds(fileItem.recordTime)
    }

    func setData(fileTitle: String?, time : String!, date: String?) {
        recordingFileNameLabel.text = fileTitle
        recordedTimeLabel.text = time
        recordedDateLabel.text = date
    }
    
    
    func setConstraints() {
        recordingFileNameLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(contentView).offset(24)
            $0.trailing.equalTo(recordedDateLabel.snp.leading).offset(-12)
        }
        
        playButton.snp.makeConstraints {
            $0.trailing.equalTo(-24)
            $0.centerY.equalTo(contentView)
            $0.width.height.equalTo(24)
        }
        
        recordedTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(playButton.snp.leading).offset(-14)
            $0.centerY.equalTo(contentView)
            $0.height.equalTo(22)
            //$0.width.equalTo(34)
        }
        
        recordedDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.height.equalTo(22)
            $0.trailing.equalTo(recordedTimeLabel.snp.leading).offset(-12)
        }
    }

}
