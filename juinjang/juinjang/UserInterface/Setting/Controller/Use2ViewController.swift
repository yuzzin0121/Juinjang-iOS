//
//  UseViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//

import UIKit
import Then
import SnapKit

class Use2ViewController : BaseViewController {
   private let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.indicatorStyle = .black
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = UIColor(named: "100")
    }
    
    private let contentLabel1 = UILabel().then {
        $0.text = "주인장 개인정보 처리방침"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let contentLabel2 = UILabel().then {
        $0.text = "개인정보처리방침 \n주인장은 개인정보보호법 등 관련 법령에 따라 이용자의 개인정보를 보호하고, 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보처리방침을 수립합니다.\n개인정보처리방침은 이용자가 언제나 쉽게 열람할 수 있도록 서비스 초기화면을 통해 공개하고 있으며 관련법령, 지침, 고시 또는 밥먹공서비스 정책의 변경에 따라 달라질 수 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel3 = UILabel().then {
        $0.text = "1. 개인정보의 수집/이용\n주인장은 다음과 같이 개인정보를 수집합니다. 처리하고 있는 개인정보는 다음의 수집/이용 목적 이외의 용도로는 활용되지 않으며, 수집/이용 목적이 변경되는 경우에는 개인정보보호법에 따라 별도의 동의를 받는 등 필요한 조치를 이행합니다.\n(1) 회원가입 시 본인인증 및 회원가입 유형에 따라 다음의 개인정보를 수집 이용합니다.\n- 타사 계정을 이용한 회원가입 시: 닉네임, 이메일주소, 계정 식별자\n*타사 계정 가입 시 제3자로부터 제공받는 개인정보는 다음과 같습니다.\n- 네이버: CI, 이메일주소, 카카오 계정 식별자, 닉네임\n- Apple: CI, 이메일주소, Apple ID식별자\n(3) 서비스 이용과정에서 아래 자동 수집 정보가 생성되어 수집 저장, 조합, 분석될 수 있습니다.\n- IP주소, 쿠키, 방문기록, 서비스 이용기록(검색이력, 서비스 사용이력 등)\n(4) 주인장은 서비스 제공을 위하여 수집한 모든 개인정보와 생성정보를 아래 목적으로 이용합니다\n- 회원 가입 의사 확인, 이용자 동의 의사 확인, 회원제 서비스 제공, 회원관리\n- 이용자 식별, 학생인증\n- 민원처리 및 고객상담\n- 고지사항 전달\n- 불법 및 부정이용 방지, 부정 사용자 차단 및 관리\n- 서비스 방문 및 이용기록 통계 및 분석\n- 서비스 만족도 조사 및 관리\n- 맞춤 서비스, 개인화 서비스 제공\n- 마케팅 및 프로모션 활용(광고성/이벤트 정보 제공), 맞춤형 광고 제공"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel4 = UILabel().then {
        $0.text = "2. 개인정보 파기절차 및 방법\n(1) 주인장은 이용자의 개인정보를 원칙적으로 보유/이요기간 경과, 처리목적 달성, 서비스 이용약관에 따른 계약 해지 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n(2) 이용자로부터 동의 받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는 해당 개인정보를 별도의 데이터페이서(DB)로 옮기거나 보관장소를 달리하여 보존합니다.\n① 다른 법령에 따라 개인정보를 보관하는 경우는 다음과 같습니다.| 법령 | 수집/이용 목적 | 수집 항목 | 보유/이용기간 |\n| --- | --- | --- | --- |\n| 통신비밀보호법 | 통신사실 확인자료 제공 | 로그기록, 접속지 정보 등 | 3개월 |\n| 전자상거래 등에서의 소비자 보호에 관한 법률 | 표시/광고에 관한 기록 | 표시/광고 기록 | 6개월 |\n|  | 소비자 불만 또는 분쟁 처리에 관한 기록 | 소비자 식별정보, 분쟁 처리 기록 | 3년 |\n② 주인장 내부정책에 의하여 이용자의 동의를 받아 개인정보를 보관하는 경우는 다음과 같습니다\n| 수집 이용 목적 | 수집 항목 | 보유/이용기간 |\n| --- | --- | --- |\n| 회원가입 남용(부정거래), 서비스 부정사용 확인 및 방지 | 이메일 주소, 기기정보, CI/DI | 회원탈퇴 후 3년 |\n(3) 주인장은 1년 동안 주인장서비스를 이용하지 않은 이용자의 개인정보는 ‘개인정보보호법 제39조의 6(개인정보의 파기에 대한 특례)’에 근거하여 이용자에게 사정통지하고 휴면회원으로 전환하며 개인정보를 별도 분리하여 저장합니다.\n이용자는 언제든지 휴면 해제 후 서비스를 이용할 수 있으며, 휴면회원으로 전환된 날로부터 1년 이상 휴면 해제하지 않는 경우 주인장의 계정 탈퇴와 함께 분리 보관된 이용자의 개인정보를 파기합니다. 주인장은 휴면회원 전환 30일전, 개인정보가 분리되어 저장/관리된다는 사실, 서비스 미이용 기간 만료일, 분리 저장하는 개인정보의 항목을 전자우편 등의 방법으로 알리며, 휴면회원 전환 및 탈퇴 처리 시에도 동일한 방법으로 즉시 이용자에게 알랍니다.\n(4) 개인정보 파기의 절차 및 방법은 다음과 같습니다.\n①파기절차\n주인장은 파기 사유가 발생한 개인정보를 개인정보 보호책임자의 승인 절차를 거쳐 파기합니다.\n②파기방법\n주인장은 전자적 파일형태로 기록/저장된 개인정보는 기록을 재생할 수 없도록 기술적인 방법 또는 물리적인 방법을 이용하여 파기하며, 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각 등을 통하여 파기합니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel5 = UILabel().then {
        $0.text = "3. 이용자의 권리와 그 행사방법\n(1) 이용자는 ‘설정 > 내 정보’에서 직접 자신의 개인정보를 열람, 정정, 삭제, 처리정지 또는 가입 해지하는 것을 원칙으로 하며, 주인장은 이를 위한 기능을 제공합니다.\n(2) 이용자는 유선 또는 메일을 통해 개인정보의 열람, 정정, 삭제, 처리정지 또는 가입 해지를 요청할 수 있으며,\n(3) 주인장은 다음에 해당하는 경우 개인정보의 열람, 정정, 삭제, 처리정지 등을 거절할 수 있습니다.\n① 법률에 따라 열람, 정정, 삭제, 처리정지 등이 금지되거나 제한되는 경우\n② 다른 사람의 생명, 신체를 해할 우려가 있거나 다른 사람의 재산과 그 밖의 이익을 부당하게 침해할 우려가 있는 경우\n(4) 이용자가 개인정보의 오류에 대한 정정을 요청한 경우에는 정정을 완료하기 전까지 당해 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리 결과를 제3자에게 지체없이 통지하여 정정이 이루어지도록 하겠습니다.\n(5) 이용자는 자신의 개인정보를 최신의 상태로 유지해야 하며, 이용자의 부정확한 정보 입력으로 발생하는 문제의 책임은 이용자 자신에게 있습니다.\n(6) 타인의 개인정보를 도용한 회원가입의 경우 이용자 자격을 상실하거나 관련 개인정보보호 법령에 의해 처벌받을 수 있습니다.\n(7) 이용자는 전자우편, 비밀번호 등에 대한 보안을 유지할 책임이 있으며 제3자에게 이를 양도하거나 대여 할 수 없습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel6 = UILabel().then {
        $0.text = "4. 개인정보의 기술적/관리적 보호대책\n주인장은 이용자의 개인정보를 처리함에 있어 개인정보가 분실, 도난, 유출, 변조, 훼손 등이 되지 않도록 안전성을 확보하기 위하여 다음과 같이 기술적/관리적 보호대책을 강구하고 있습니다.\n(1) 비밀번호의 암호화\n이용자의 비밀번호는 일방향 암호화하여 저장 및 관리되고 있으며, 개인정보의 확인, 변경은 비밀번호를 알고있는 본인에 의해서만 가능합니다.\n(2) 해킹 등에 대비한 대책\n① 주인장은 해킹, 컴퓨터 바이러스 등 정보통신망 침입에 의해 이용자의 개인정보가 유출되거나 훼손되는 것을 막기 위해 최선을 다하고 있습니다.\n② 최신 백신프로그램을 이용하여 이용자들의 개인정보나나 자료가 유출되거나 손상되지 않도록 방지하고 있습니다.\n③ 만일의 사태에 대비하여 침입차단 시스템을 이용하여 보안에 최선을 다하고 있습니다.\n④ 민감한 개인정보는 암호화 통신 등을 통하여 네트워크상에서 개인정보를 안전하게 전송할 수 있도록 하고 있습니다.\n(3) 개인정보 처리 최소화 및 교육\n주인장은 개인정보 관련 처리 담당자를 최소한으로 제한하며, 개인정보 처리자에 대한 교육 등 관리적 조치를 통해 법령 및 내부방침 등의 준수를 강조하고 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel7 = UILabel().then {
        $0.text = "5. 개인정보 보호 책임자\n(1) 주인장은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 고객님의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n- 개인정보 보호 책임자: 여민경\n- 전자우편: juinjang1227@gmail.com"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel8 = UILabel().then {
        $0.text = "6. 고지의 의무\n(1) 현 개인정보처리방침은 법령, 정부의 정책 또는 주인장내부정책 등 필요에 의하여 변경될 수 잇으며, 내용추가, 삭제 및 수정이 있을 시에는 개정 최소 7일전부터 ‘공지사항’을 통해 고지할 것 입니다. 다만, 이용자 권리의 중요한 변경이 있을 경우에는 최소 30일 전에 고지합니다.\n(2) 현 개인정보처리방침은 2024년 1월 26일부터 적용되며, 변경 전의 개인정보처리방침은 공지사항을 통해서 확인하실 수 있습니다.\n- 공고일자 2024년 1월 26일\n- 시행일자 2024년 1월 26일"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
//MARK: - 함수
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "주인장 개인정보 처리방침"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(named:"arrow-left"), style: .plain, target: self, action: #selector(tapCloseButton))
        closeButtonItem.tintColor = UIColor(named: "300")
        closeButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    @objc func tapCloseButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func setConstraint() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(46)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(33)
        }
        contentLabel1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
        }
        contentLabel2.snp.makeConstraints {
            $0.top.equalTo(contentLabel1.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel3.snp.makeConstraints {
            $0.top.equalTo(contentLabel2.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel4.snp.makeConstraints {
            $0.top.equalTo(contentLabel3.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel5.snp.makeConstraints {
            $0.top.equalTo(contentLabel4.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel6.snp.makeConstraints {
            $0.top.equalTo(contentLabel5.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel7.snp.makeConstraints {
            $0.top.equalTo(contentLabel6.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        contentLabel8.snp.makeConstraints {
            $0.top.equalTo(contentLabel7.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentLabel1)
        scrollView.addSubview(contentLabel2)
        scrollView.addSubview(contentLabel3)
        scrollView.addSubview(contentLabel4)
        scrollView.addSubview(contentLabel5)
        scrollView.addSubview(contentLabel6)
        scrollView.addSubview(contentLabel7)
        scrollView.addSubview(contentLabel8)
        contentLabel3.asFont(targetString: "1. 개인정보의 수집/이용", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel4.asFont(targetString: "2. 개인정보 파기절차 및 방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel5.asFont(targetString: "3. 이용자의 권리와 그 행사방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel6.asFont(targetString: "4. 개인정보의 기술적/관리적 보호대책", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel7.asFont(targetString: "5. 개인정보 보호 책임자", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel8.asFont(targetString: "6. 고지의 의무", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        view.backgroundColor = .white
        setConstraint()
    }
}
