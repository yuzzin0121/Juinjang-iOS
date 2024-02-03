//
//  CheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/20/24.
//

import UIKit
import SnapKit

class CheckListViewController: UIViewController, ExpandedScoreCellDelegate {
    
    var buttonStates: [Int: Bool] = [:]
    
    func buttonTapped(at index: Int) {
        // 해당 버튼의 상태를 딕셔너리에 업데이트
        buttonStates[index] = !buttonStates[index, default: false]

        // 필요한 작업 수행
        // 예: 특정 인덱스의 버튼 상태를 가져와 사용
        let buttonState = buttonStates[index] ?? false
        print("Button at index \(index) tapped. State: \(buttonState)")
    }
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews()
        setupLayout()
        registerCell()
        NotificationCenter.default.addObserver(self, selector: #selector(didStoppedParentScroll), name: NSNotification.Name("didStoppedParentScroll"), object: nil)
    }
    @objc
    func didStoppedParentScroll() {
        DispatchQueue.main.async {
            self.tableView.isScrollEnabled = true
        }
    }
    
    // 키보드 내리기
    func hideKeyboardWhenTappedArround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addSubViews() {
        view.addSubview(tableView)
    }
    
    func setupLayout() {
        // 테이블 뷰
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        tableView.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
        tableView.register(ExpandedScoreTableViewCell.self, forCellReuseIdentifier: ExpandedScoreTableViewCell.identifier)
        tableView.register(ExpandedCalendarTableViewCell.self, forCellReuseIdentifier: ExpandedCalendarTableViewCell.identifier)
        tableView.register(ExpandedTextFieldTableViewCell.self, forCellReuseIdentifier: ExpandedTextFieldTableViewCell.identifier)
        tableView.register(ExpandedDropdownTableViewCell.self, forCellReuseIdentifier: ExpandedDropdownTableViewCell.identifier)
    }
    
    // -MARK: 체크리스트 입력값 UserDefaults로 관리
    // 정수 형식으로 값을 저장하는 함수
    func saveValueForCategory(categoryIndex: Int, itemIndex: Int, value: Any) {
        let key = "Category\(categoryIndex)_Item\(itemIndex)_Value"
        UserDefaults.standard.set(value, forKey: key)
    }

    // 저장된 값을 불러오는 함수
    func loadValueForCategory(categoryIndex: Int, itemIndex: Int) -> Any? {
        let key = "Category\(categoryIndex)_Item\(itemIndex)_Value"
        return UserDefaults.standard.value(forKey: key)
    }
}

extension CheckListViewController : UITableViewDelegate, UITableViewDataSource  {
    
    // section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    // row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories[section].isExpanded {
            return 1 + categories[section].items.count // section이 확장된 경우, 카테고리 셀과 확장된 항목들이 나타남
        } else {
            return 1 // section이 확장되지 않은 경우, 카테고리 셀만 나타남
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as? CategoryItemTableViewCell else { return UITableViewCell() }
            
            let category = categories[indexPath.section]
            cell.categoryImage.image = categories[indexPath.section].image
            cell.categoryLabel.text = categories[indexPath.section].name
            
            // section 확장 유무에 따라서 화살표 이미지 변경
            let arrowImage = category.isExpanded ? UIImage(named: "contraction-items") : UIImage(named: "expand-items")
            cell.expandButton.setImage(arrowImage, for: .normal)
            
            return cell
            
        } else {
            // 카테고리 셀 클릭 시 펼쳐질 셀
            let category = categories[indexPath.section]
            
            if let calendarItem = category.items[indexPath.row - 1] as? CalendarItem {
                // CalendarItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedCalendarTableViewCell.identifier, for: indexPath) as? ExpandedCalendarTableViewCell else { return UITableViewCell() }
                // 선택된 날짜를 저장하고 불러오기
                cell.saveSelectedDate()
                cell.selectedDate = cell.loadSelectedDate() ?? Date()
                
                cell.calendarItems = [CalendarItem(content: calendarItem.content, inputDate: calendarItem.inputDate, isSelected: calendarItem.isSelected)]
                cell.contentLabel.text = calendarItem.content
//                cell.selectedDate = cell.calendarItems[index]
                
                // 선택 상태에 따라 배경색 설정
                cell.backgroundColor = calendarItem.isSelected ? UIColor(named: "lightOrange") : UIColor.white
                
                // 저장된 날짜가 없으면 기본값으로 설정
                cell.selectedDate = cell.loadSelectedDate() ?? Date()
                
                print(cell.calendarItems)
                
                
                return cell
            } else if let scoreItem = category.items[indexPath.row - 1] as? ScoreItem {
                // ScoreItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedScoreTableViewCell.identifier, for: indexPath) as? ExpandedScoreTableViewCell else { return UITableViewCell() }
                
                cell.contentLabel.text = scoreItem.content
                cell.score = scoreItem.score
                cell.delegate = self
//                // 버튼의 초기 상태 설정
//                for buttonTag in 1...5 {
//                    cell.answerButton[buttonTag].isSelected = cell.buttonStates[buttonTag] ?? false
//                }
                
                // 선택 상태에 따라 배경색 설정
                cell.backgroundColor = scoreItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
                            
                return cell
            } else if let inputItem = category.items[indexPath.row - 1] as? InputItem {
                // InputItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedTextFieldTableViewCell.identifier, for: indexPath) as? ExpandedTextFieldTableViewCell else { return UITableViewCell() }
                
                cell.contentLabel.text = inputItem.content
                cell.inputAnswer = inputItem.inputAnswer
                // 선택 상태에 따라 배경색 설정
                cell.backgroundColor = inputItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
                
                return cell
            } else if let selectionItem = category.items[indexPath.row - 1] as? SelectionItem {
                // SelectionItem인 경우
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedDropdownTableViewCell.identifier, for: indexPath) as? ExpandedDropdownTableViewCell else { return UITableViewCell() }
                
                cell.contentLabel.text = selectionItem.content
                cell.options = selectionItem.options
                cell.selectedOption = selectionItem.selectAnswer
                // 선택 상태에 따라 배경색 설정
                cell.backgroundColor = selectionItem.isSelected ? UIColor(named: "lightOrange") : UIColor.clear
                
                return cell
            } 
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var category = categories[indexPath.section]
        
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryItemTableViewCell {
            // 카테고리 셀을 눌렀을 때
            if indexPath.row == 0 {
                if categories[indexPath.section].isExpanded == true {
                    categories[indexPath.section].isExpanded = false
                    // 테이블 뷰 리로드
                    tableView.reloadSections([indexPath.section], with: .automatic)
                } else {
                    categories[indexPath.section].isExpanded = true
                }
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedCalendarTableViewCell {
            // 확장된 캘린더 셀을 눌렀을 때
            if let selectedDate = cell.selectedDate, var item = category.items[indexPath.row - 1] as? CalendarItem {
                item.inputDate = selectedDate
                item.isSelected = true
            } else {
                // 캐스팅 실패 또는 selectedDate가 nil인 경우 처리
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedScoreTableViewCell {
            // 확장 점수 셀을 눌렀을 때
            if let selectedAnswer = cell.score, var item = category.items[indexPath.row - 1] as? ScoreItem {
                item.score = selectedAnswer
                item.isSelected = true
            } else {
                // 캐스팅 실패 또는 selectedAnswer가 nil인 경우 처리
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedTextFieldTableViewCell {
            // 확장 입력 셀을 눌렀을 때
            if let inputAnswer = cell.inputAnswer, var item = category.items[indexPath.row - 1] as? InputItem {
                item.inputAnswer = inputAnswer
                item.isSelected = true
            } else {
                // 캐스팅 실패 또는 inputAnswer가 nil인 경우 처리
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? ExpandedDropdownTableViewCell {
            // 확장 드롭다운 셀을 눌렀을 때
            if let selectedOption = cell.selectedOption, var item = category.items[indexPath.row - 1] as? SelectionItem {
                item.selectAnswer = selectedOption
                item.isSelected = true
            } else {
                // 캐스팅 실패 또는 selectedOption이 nil인 경우 처리
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 0 else {
            // 카테고리 셀의 높이
            return 63
        }

        let category = categories[indexPath.section]
        let selectedItem = category.items[indexPath.row - 1]

        switch selectedItem {
        case is CalendarItem:
            return 443
        case is ScoreItem, is InputItem:
            return 98
        case is SelectionItem:
            return 114
        default:
            return UITableView.automaticDimension
        }
    }
}
