//
//  CheckListViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/20/24.
//

import UIKit
import SnapKit

class CheckListViewController: UIViewController {
    
    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.bounces = true
    }
    
    lazy var contentView = UIView()
    
    lazy var completedButton = UIButton().then {
        $0.setImage(UIImage(named: "completed-button"), for: .normal)
    }
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(CategoryItemTableViewCell.self, forCellReuseIdentifier: CategoryItemTableViewCell.identifier)
        $0.register(ExpandedTableViewCell.self, forCellReuseIdentifier: ExpandedTableViewCell.identifier)

    }
    
    var CategoryItems: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews()
        setupLayout()
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
        [scrollView,
         completedButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [tableView].forEach { contentView.addSubview($0) }
    }
    
    func setupLayout() {
        // 스크롤 뷰
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        // 컨텐트 뷰
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView)
            $0.bottom.equalTo(tableView.snp.bottom)
        }
        
        completedButton.snp.makeConstraints {
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-26)
            $0.bottom.equalTo(view.snp.bottom).offset(-26)
            $0.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        view.bringSubviewToFront(completedButton)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(63*4)
        }
    }
    
    var categories: [Category] = [
        Category(image: UIImage(named: "deadline-item")!, name: "기한", items: [
            //CalendarItem(content: "입주 가능 날짜는 어떻게 되나요?"),
            //CalendarItem(content: "잔금은 언제까지 치뤄야 하나요?")
        ]),
        Category(image: UIImage(named: "location-conditions-item")!, name: "입지여건", items: [
            ScoreItem(content: "역세권인가요?"),
            //ScoreItem(content: "지하철 노선도를 선택해 주세요."),
            ScoreItem(content: "버스 주요노선이 지역중심부에 접근이 용이한가요?"),
            ScoreItem(content: "공립 어린이집 혹은 유치원이 충분히 가까운가요?"),
            ScoreItem(content: "초등학교가 반경 5분~10분 이내에 있나요?"),
            ScoreItem(content: "중학교가 반경 3km내에 있나요?"),
            ScoreItem(content: "응급상황 발생 시 찾아갈 의료시설이 갖춰져 있나요?"),
            ScoreItem(content: "대형마트, 시장이 도보로 이용 가능한가요?"),
            ScoreItem(content: "여러 브랜드의 편의점이 근거리에 분포해있나요?"),
            ScoreItem(content: "입주자가 사용하는 은행이 근거리에 분포해있나요?"),
            //ScoreItem(content: "건물뷰를 골라주세요."),
            ScoreItem(content: "동향/서향/남향/북향"),
            ScoreItem(content: "창문이 적절한 위치와 적절한 갯수를 갖추고 있나요?"),
            ScoreItem(content: "빛이 잘 들어오나요?"),
            ScoreItem(content: "근처에 술집, 노래방 등의 유흥시설이 가까운가요?"),
            ScoreItem(content: "주변에 변전소, 고압선, 레미콘 공장등이 가까운가요?"),
            ScoreItem(content: "단지 내 위험을 대비한 안전장치가 구비되어 있나요?"),
            ScoreItem(content: "찾고 계신 매물의 노후 정도가 괜찮은 편인가요?"),
            //ScoreItem(content: "건축년도를 입력해 주세요.")
        ]),
        Category(image: UIImage(named: "public-space-item")!, name: "공용공간", items: [
            //ScoreItem(content: "주차공간이 세대 당 몇 대인가요?"),
            ScoreItem(content: "단지 내 놀이터가 잘 갖춰져 있나요?"),
            ScoreItem(content: "단지 내 cctv가 설치된 놀이터가 있나요?"),
            ScoreItem(content: "단지 내 헬스장이 있나요?"),
            //ScoreItem(content: "단지 내 노인정이 있나요?"),
            ScoreItem(content: "출퇴근 시 엘리베이터 사용이 여유롭나요?"),
            ScoreItem(content: "단지 내 택배를 안전하게 받을 수 있는 공간이 있나요?"),
            ScoreItem(content: "단지 내 유모차 이동이 자유롭나요?")
        ]),
        Category(image: UIImage(named: "indoor-item")!, name: "실내", items: [
            //ScoreItem(content: "시스템 에어컨 / 설치형에어컨 / 기타"),
            ScoreItem(content: "냉난방 시스템이 장 작동하나요?"),
            ScoreItem(content: "창문은 이중창인가요?"),
            ScoreItem(content: "복도형 구조 / 거실중앙형 구조 / 기타"),
            ScoreItem(content: "베란다 확장을 했나요?"),
            ScoreItem(content: "현관 앞 공용공간이 충분한가요?"),
            ScoreItem(content: "현관에 중간문을 설치할 수 있나요?"),
            ScoreItem(content: "신발장 넒이는 적절한가요?"),
            ScoreItem(content: "현관에 짐을 보관할 수 있는 창고가 있나요?"),
            ScoreItem(content: "거실 바닥 마감 상태가 양호한가요?"),
            ScoreItem(content: "거실 벽면 마감 상태가 양호한가요?"),
            ScoreItem(content: "거실 베란다 창호와 방충망 상태가 양호한가요?"),
            ScoreItem(content: "주방 바닥 마감 상태가 양호한가요?"),
            ScoreItem(content: "주방 벽면 마감 상태가 양호한가요?"),
            ScoreItem(content: "주방 통기성이 양호한가요?"),
            ScoreItem(content: "주방 옆 펜트리가 있나요?"),
            ScoreItem(content: "주방 싱크대 수압은 괜찮은 편인가요?"),
            ScoreItem(content: "방의 크기는 적당한가요?"),
            //ScoreItem(content: "방의 갯수는 몇 개인가요?"),
            ScoreItem(content: "방의 바닥 마감 상태가 양호한가요?"),
            ScoreItem(content: "방의 벽면 마감 상태가 양호한가요?"),
            ScoreItem(content: "방 안에 붙방이장이 설치되어 있나요?"),
            ScoreItem(content: "화장실의 바닥 마감 상태가 양호한가요?"),
            ScoreItem(content: "화장실의 벽면 마감 상태가 양호한가요?"),
            ScoreItem(content: "화장실 수는 적당한 편인가요?"),
            ScoreItem(content: "환풍기가 정상적으로 작동하나요?"),
            ScoreItem(content: "화장실 세면대 수압의 상태는 어떤가요?"),
            ScoreItem(content: "욕조/샤워부스가 따로 마련되어 있나요?"),
            ScoreItem(content: "소방대피시설이 잘 갖춰져 있나요?")
        ]),
    ]
}


extension CheckListViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories[section].isExpanded {
            return 1 + categories[section].items.count // 확장된 경우, 카테고리 셀과 확장된 항목들
        } else {
            return 1 // 비확장된 경우, 카테고리 셀만
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTableViewCell.identifier, for: indexPath) as! CategoryItemTableViewCell
                
                cell.categoryLabel.text = categories[indexPath.section].name
                
                return cell
            }else {
                //클릭시 펼쳐질 셀
                let cell: ExpandedTableViewCell = tableView.dequeueReusableCell(withIdentifier: ExpandedTableViewCell.identifier, for: indexPath) as! ExpandedTableViewCell
                
                let scoreItem = categories[indexPath.section].items[indexPath.row - 1] as? ScoreItem
                cell.contentLabel.text = scoreItem?.content

                return cell
            }
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryItemTableViewCell else {return}
        guard let index = tableView.indexPath(for: cell) else { return }

        if index.row == indexPath.row {
           if index.row == 0 {
               if categories[indexPath.section].isExpanded == true {
                   categories[indexPath.section].isExpanded = false
                   cell.expandButton.setImage(UIImage(named: "contraction-items"), for: .normal)
                   let section = IndexSet.init(integer: indexPath.section)
                   tableView.reloadSections(section, with: .fade)
                   
               } else {
                   categories[indexPath.section].isExpanded = true
                   cell.expandButton.setImage(UIImage(named: "expand-items"), for: .normal)
                   let section = IndexSet.init(integer: indexPath.section)
                   tableView.reloadSections(section, with: .fade)
               }
           }
        }
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 63
        } else {
            return 100
        }
    }
}
