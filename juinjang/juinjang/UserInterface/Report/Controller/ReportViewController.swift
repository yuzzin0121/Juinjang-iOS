//
//  ReportViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/22/24.
//

import UIKit
import Then
import SnapKit

import Tabman
import Pageboy

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKShare
import SafariServices

import Alamofire

class ReportViewController : BaseViewController {
    
    let templateId = 103560
    var safariViewController : SFSafariViewController?
    var checkListViewController: CheckListViewController?
    
    //MARK: - 총 평점 멘트, 가격, 주소
    var totalGradeLabel = UILabel().then {
        $0.text = "판교푸르지오월드마크"
        $0.textColor = UIColor(named: "600")
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    var imjangLabel = UILabel().then {
        $0.text = "판교푸르지오월드마크"
    }
    var priceLabel = UILabel().then {
        $0.text = "30억 1천만원"
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
    }
    var addressLabel = UILabel().then {
        $0.text = "경기도 성남시 분당구 삼평동 741"
        $0.textColor = UIColor(named: "450")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    var imjangId: Int
    var indoorRate: Float = 0.0
    var indoorKeyWord : String = ""
    var locationConditionsRate : Float = 0.0
    var locationConditionsWord : String = ""
    var publicSpaceRate : Float = 0.0
    var publicSpaceKeyWord : String = ""
    var savedCheckListItems: [CheckListAnswer]
    var checkListDatadelegate: SendCheckListData?
   // var reportId : Int = 0
    var totalRate : Float = 0.0
   
    //MARK: - 그래프
    let tabViewController = TabViewController()
    
    func getReportInfo(limjangId: Int, accessToken: String) {
        print("hi")
        // 기본 URL
        let baseURL = "http://juinjang1227.com:8080/api/report/\(limjangId)"
        
        // 요청 헤더 구성
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // Alamofire를 사용하여 GET 요청
        AF.request(baseURL, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("리포트 value : \(value)")
                if let json = value as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let limjangDto = result["limjangDto"] as? [String: Any],
                   let reportDTO = result["reportDTO"] as? [String: Any] {
                    print("Response JSON: \(json)")
                    do {
                        let decoder = JSONDecoder()
                        let reportData = try JSONSerialization.data(withJSONObject: reportDTO, options: [])
                        let reportDto = try decoder.decode(ReportDTO.self, from: reportData)
                        self.setData(reportDto: reportDto)
                        
                    } catch {
                        print("JSON2 디코딩 에러: \(error.localizedDescription)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        let limjangData = try JSONSerialization.data(withJSONObject: limjangDto, options: [])
                        let detailDto = try decoder.decode(DetailDto.self, from: limjangData)
                        self.setData(detailDto: detailDto)
                        
                    } catch {
                        print("JSON1 디코딩 에러: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func setConstraint() {
        totalGradeLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.left.equalToSuperview().offset(24)
        }
        priceLabel.snp.makeConstraints{
            $0.top.equalTo(totalGradeLabel.snp.bottom).offset(13)
            $0.left.equalToSuperview().offset(24)
        }
        addressLabel.snp.makeConstraints{
            $0.top.equalTo(priceLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(24)
        }
       
        tabViewController.view.snp.makeConstraints{
            $0.top.equalTo(addressLabel.snp.bottom).offset(33)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "주인장 리포트"
        
        //let shareButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareBtnTap))
        let backButtonItem = UIBarButtonItem(image: UIImage(named:"arrow-left"), style: .plain, target: self, action: #selector(backBtnTap))
        backButtonItem.tintColor = UIColor(named: "300")
        backButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // 네비게이션 아이템에 백 버튼 아이템 설정
        //self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backButtonItem
        //self.navigationItem.rightBarButtonItem = shareButtonItem
    }
    
    func changeItem() {
        self.navigationItem.rightBarButtonItem = .none
    }
    
    func setData(detailDto: DetailDto) {
        imjangLabel.text = detailDto.nickname
        let star = NSTextAttachment()
        star.image = UIImage(named: "bigStar")
        let attrString = NSMutableAttributedString(string: "\(String(format: "%.2f", totalRate))점입니다")
        let range = ("\(String(format: "%.2f", totalRate))점입니다" as NSString).range(of: "\(String(format: "%.2f", totalRate))점")
        attrString.addAttribute(.foregroundColor, value: UIColor(named: "juinjang")!, range: range)
        let text3 = NSMutableAttributedString(string: "\(imjangLabel.text ?? "판교푸르지오월드마크")의\n총점은 ")
        text3.append(NSAttributedString(attachment: star))
        text3.append(NSAttributedString(attributedString: attrString))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        text3.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text3.length))
        totalGradeLabel.attributedText = text3
        setPriceLabel(priceList: detailDto.priceList)
        addressLabel.text = "\(detailDto.address) \(detailDto.addressDetail)"
        
        tabViewController.compareVC.compareLabel1.text = detailDto.nickname
        tabViewController.compareVC.chartCompareLabel1.text = detailDto.nickname
    }
    
    func setData(reportDto: ReportDTO) {
        indoorKeyWord = reportDto.indoorKeyWord
        indoorRate = reportDto.indoorRate
        
        locationConditionsWord = reportDto.locationConditionsWord
        locationConditionsRate = reportDto.locationConditionsRate
        
        publicSpaceKeyWord = reportDto.publicSpaceKeyWord
        publicSpaceRate = reportDto.publicSpaceRate
        
        totalRate = reportDto.totalRate
        
        let graphVC = tabViewController.graphVC
        graphVC.updateLabel(with: indoorKeyWord, status2: locationConditionsWord, status3: publicSpaceKeyWord)
        graphVC.updateRate(rate: String(format: "%.2f", indoorRate), label: graphVC.indoorRateLabel)
        graphVC.updateRate(rate: String(format: "%.2f", locationConditionsRate), label: graphVC.locationRateLabel)
        graphVC.updateRate(rate: String(format: "%.2f", publicSpaceRate), label: graphVC.publicRateLabel)
        graphVC.setData(indoor: indoorRate, location: locationConditionsRate, publicSpace: publicSpaceRate)
        
        let compareVC = tabViewController.compareVC
        compareVC.updateRate(rate: String(format: "%.2f", indoorRate), label: compareVC.insideRateLabel1)
        compareVC.updateRate(rate: String(format: "%.2f", locationConditionsRate), label: compareVC.locationConditionRateLabel1)
        compareVC.updateRate(rate: String(format: "%.2f", publicSpaceRate), label: compareVC.publicSpaceRateLabel1)
        compareVC.updateRate(rate: String(format: "%.2f", totalRate), label: compareVC.totalRateLabel1)
        compareVC.setData(indoor: indoorRate, location: locationConditionsRate, publicSpace: publicSpaceRate)

    }
    
    func setPriceLabel(priceList: [String]) {
        switch priceList.count {
        case 1:
            let priceString = priceList[0]
            priceLabel.text = priceString.formatToKoreanCurrencyWithZero()
        case 2:
            let priceString1 = priceList[0].formatToKoreanCurrencyWithZero()
            let priceString2 = priceList[1].formatToKoreanCurrencyWithZero()
            priceLabel.text = "\(priceString1) • 월 \(priceString2)"
            priceLabel.asColor(targetString: "• 월", color: ColorStyle.mainStrokeOrange)
        default:
            priceLabel.text = "편집을 통해 가격을 설정해주세요."
        }
    }
    
    @objc func backBtnTap() {
        NotificationCenter.default.post(name: NSNotification.Name("ReloadTableView"), object: nil)
        checkListDatadelegate?.sendData(
            savedCheckListItems: savedCheckListItems
        )
        self.navigationController?.popViewController(animated: true)
//        let mainVC = ImjangNoteViewController()
//        navigationController?.pushViewController(mainVC, animated: true)
    }
    @objc func shareBtnTap() {
        if ShareApi.isKakaoTalkSharingAvailable() {
            // 카카오톡으로 카카오톡 공유 가능
            ShareApi.shared.shareCustom(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {(sharingResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("shareCustom() success.")
                    if let sharingResult = sharingResult {
                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        else {
            // 카카오톡 미설치: 웹 공유 사용 권장
            // Custom WebView 또는 디폴트 브라우져 사용 가능
            // 웹 공유 예시 코드
            if let url = ShareApi.shared.makeCustomUrl(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {
                self.safariViewController = SFSafariViewController(url: url)
                self.safariViewController?.modalTransitionStyle = .crossDissolve
                self.safariViewController?.modalPresentationStyle = .overCurrentContext
                self.present(self.safariViewController!, animated: true) {
                    print("웹 present success")
                }
            }
        }
    }
    
    func updateUI(with items: [CheckListAnswer]) {
        self.savedCheckListItems = items
    }
    
    init(imjangId: Int, savedCheckListItems: [CheckListAnswer]) {
        self.imjangId = imjangId
        self.savedCheckListItems = savedCheckListItems
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        getReportInfo(limjangId: imjangId, accessToken: UserDefaultManager.shared.accessToken)
        print(imjangId)
        view.backgroundColor = .white
        
        view.addSubview(totalGradeLabel)
        view.addSubview(priceLabel)
        view.addSubview(addressLabel)
        
        addChild(tabViewController)
        tabViewController.imjangId = imjangId
        view.addSubview(tabViewController.view)
        tabViewController.didMove(toParent: self)
        
        setConstraint()
    }
}

protocol SendCheckListData {
    func sendData(savedCheckListItems: [CheckListAnswer])
}
