//
//  ExpandedCalendarTableViewCell.swift
//  juinjang
//
//  Created by 임수진 on 1/22/24.
//

import UIKit
import FSCalendar

class ExpandedCalendarTableViewCell: UITableViewCell, FSCalendarDelegate, FSCalendarDataSource {

    static let identifier = "ExpandedCalendarTableViewCell"
    
    var selectedDate: Date?
    
    lazy var questionImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "question-image")
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .regular)
        $0.textColor = UIColor(named: "textBlack")
    }
    
    // 달력
    lazy var calendar = FSCalendar()
    
    let today = Date()
    private var calendarCurrent: Calendar = Calendar.current
    private var currentPage: Date?
    private var dateComponents = DateComponents()
    
    lazy var moveToPreviousButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(named: "move-to-previous-button"), for: .normal)
        $0.addTarget(self, action: #selector(moveToPrev(_:)), for: .touchUpInside)
    }
    
    lazy var moveToNextButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(named: "move-to-next-button"), for: .normal)
        $0.addTarget(self, action: #selector(moveToNext(_:)), for: .touchUpInside)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        [questionImage, contentLabel, calendar].forEach { contentView.addSubview($0) }
        [moveToPreviousButton, moveToNextButton].forEach { calendar.addSubview($0)}
        setupLayout()
        calendarStyle()
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = .white
        // Configure the view for the selected state
    }
    
    func setupLayout() {
        // 질문 구분 imageView
        questionImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(25)
//            $0.centerY.equalToSuperview()
            $0.height.equalTo(6)
            $0.width.equalTo(6)
        }
        
        // 질문 Label
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalToSuperview().offset(16)
//            $0.centerY.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        // 달력
        calendar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.width.equalTo(342)
            $0.height.equalTo(356)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-30)
        }
        
        moveToPreviousButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(107)
            $0.top.equalToSuperview().offset(24)
        }
        
        moveToNextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-107)
            $0.top.equalToSuperview().offset(24)
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {

    }
    
    func calendarStyle(){

        // 언어를 한국어로 변경
        calendar.locale = Locale(identifier: "ko_KR")
            
        // 상단 헤더 뷰
        calendar.headerHeight = 66 // YYYY년 M월 표시부 영역 높이
        calendar.weekdayHeight = 41 // 날짜 표시부 행의 높이
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 헤더 좌, 우측 흐릿한 글씨 삭제
        calendar.appearance.headerDateFormat = "YYYY.MM" // 헤더 표시 형식
        calendar.appearance.headerTitleColor = .black // 헤더 색
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24) // 타이틀 폰트 크기
        
        // 날짜 부분
        calendar.backgroundColor = .white // 배경색
        calendar.appearance.weekdayTextColor = .black // 요일 글씨 색
        calendar.appearance.selectionColor = .clear // 선택되었을 때 배경색
        calendar.appearance.titleSelectionColor = .black // 선택되었을 때 텍스트 색
        calendar.appearance.titleWeekendColor = .black //주말 날짜 색
        calendar.appearance.titleDefaultColor = .black //기본 날짜 색
            
        // 오늘 날짜
        calendar.appearance.titleTodayColor = .black // Today에 표시되는 특정 글자색
        calendar.appearance.todayColor = .clear // Today에 표시되는 선택 전 동그라미 색
        calendar.appearance.todaySelectionColor = .none  // Today에 표시되는 선택 후 동그라미 색

        // Month 폰트
        calendar.appearance.headerTitleFont = .pretendard(size: 18, weight: .bold)
            
        // day 폰트
        calendar.appearance.titleFont = .pretendard(size: 14, weight: .medium)
        
        // 테두리
        calendar.layer.cornerRadius = 9.97
    }
    
    // 달력 페이지 이동
    @objc func moveToNext(_ sender: UIButton) {
        self.moveCurrentPage(moveUp: true)
    }
    @objc func moveToPrev(_ sender: UIButton) {
        self.moveCurrentPage(moveUp: false)
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        dateComponents.month = moveUp ? 1 : -1
        currentPage = calendarCurrent.date(byAdding: dateComponents, to: currentPage ?? today)
        calendar.setCurrentPage(currentPage!, animated: true)
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 현재 선택된 날짜의 테두리를 변경
        if let currentSelectedDate = selectedDate,
           let currentSelectedCell = calendar.cell(for: currentSelectedDate, at: monthPosition) {
            currentSelectedCell.layer.borderWidth = 0.0 // 이전에 선택된 날짜의 테두리 초기화
        }
        
        // 새로운 날짜에 대한 테두리 색상 변경
        if let cell = calendar.cell(for: date, at: monthPosition) {
            cell.layer.cornerRadius = 9.97
            cell.layer.borderWidth = 1.5
            cell.layer.borderColor = UIColor(named: "mainOrange")?.cgColor // 원하는 색상으로 변경
        }

        // 현재 선택된 날짜 업데이트
        selectedDate = date
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 선택되지 않은 날짜의 테두리 초기화
        if let cell = calendar.cell(for: date, at: monthPosition) {
            cell.layer.borderWidth = 0.0
        }
    }
}
