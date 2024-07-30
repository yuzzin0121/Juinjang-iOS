//
//  CompareViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/26/24.
//

import UIKit
import Then
import DGCharts
import Alamofire

class CompareViewController : BaseViewController, SendCompareImjangData, SendSearchCompareImjangData {
    
    func sendData(isSelected: Bool, compareImjangId: Int, compareImjangName: String) {
        print("sendData")
        isCompared = isSelected
        getReportInfo(limjangId: compareImjangId, accessToken: UserDefaultManager.shared.accessToken)
        isCompare()
        compareLabel2.text = compareImjangName
        chartCompareLabel2.text = compareImjangName
    }
    
    var isCompared : Bool = false
    var imjangId : Int
    var comparedImjangId : Int = 0
    
    var indoorRate1 : Float = 0.0
    var locationRate1 : Float = 0.0
    var publicRate1 : Float = 0.0
    
    var indoorRate2 : Float = 0.0
    var locationRate2 : Float = 0.0
    var publicRate2 : Float = 0.0
    
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named:"PaperTexture")
    }
    
    var compareLabel1 = UILabel().then {
        $0.text = "판교푸르지오월드마크"
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.textColor = UIColor(named: "juinjang")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var vsImageView = UIImageView().then {
        $0.image = UIImage(named: "VS")
    }
    var compareLabel2 = UILabel().then {
        $0.text = "비교건물명"
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var compareView1 = UIImageView().then {
        $0.image = UIImage(named: "compareView1")
    }
    
    var compareView2 = UIImageView().then {
        $0.image = UIImage(named: "compareView2")
        $0.tintColor = UIColor(named: "300")
    }
    var closeButton = UIButton().then {
        $0.setImage(UIImage(named: "xButton"), for: .normal)
    }
    var chartCompareImageView1 = UIImageView().then {
        $0.image = UIImage(named: "chartCompare1")
    }
    var chartCompareLabel1 = UILabel().then {
        $0.text = "판교푸르지오월드마크"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var chartCompareImageView2 = UIImageView().then {
        $0.image = UIImage(named: "chartCompare2")
    }
    var chartCompareLabel2 = UILabel().then {
        $0.text = "비교건물명"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var insideLabel1 = UILabel().then {
        $0.text = "실내"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var insideLabel2 = UILabel().then {
        $0.text = "실내"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var insideRateLabel1 = UILabel().then {
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    lazy var insideRateLabel2 = UILabel().then {
        $0.text = "4.5"
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var publicSpaceLabel1 = UILabel().then {
        $0.text = "공용 공간"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var publicSpaceLabel2 = UILabel().then {
        $0.text = "공용 공간"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var publicSpaceRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "grayStar")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    lazy var publicSpaceRateLabel2 = UILabel().then {
        $0.text = "4.5"
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var locationConditionLabel1 = UILabel().then {
        $0.text = "입지 여건"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var locationConditionRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "grayStar")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var locationConditionLabel2 = UILabel().then {
        $0.text = "입지 여건"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var locationConditionRateLabel2 = UILabel().then {
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var totalLabel1 = UILabel().then {
        $0.text = "총점"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var totalRateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "star")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "juinjang")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var totalLabel2 = UILabel().then {
        $0.text = "총점"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = UIColor(named: "300")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var totalRateLabel2 = UILabel().then {
        $0.textColor = UIColor(named: "juinjang")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var compareViewEmpty = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "compare-empty"), for: .normal)
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var radarChartView = RadarChartView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.webLineWidth = 0
        $0.innerWebLineWidth = 1.5
        $0.innerWebColor = .clear
        $0.frame = CGRect(x: 60, y: 300, width: 300, height: 300)
        $0.highlightPerTapEnabled = false
        
        let xAxis = $0.xAxis
        xAxis.labelFont = UIFont(name: "Pretendard-SemiBold`", size: 14) ?? .systemFont(ofSize: 14)
        xAxis.labelTextColor = UIColor(red: 0.292, green: 0.292, blue: 0.292, alpha: 1)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = XAxisFormatter()
        xAxis.axisLineColor = UIColor(named: "juinjang")!
        
        let yAxis = $0.yAxis
        yAxis.labelCount = 5
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        yAxis.valueFormatter = YAxisFormatter()
        
        $0.rotationEnabled = false
        $0.legend.enabled = false
    }
    
    var compareDataSet2 = RadarChartDataSet(
        entries: [
            RadarChartDataEntry(value: 2.8),
            RadarChartDataEntry(value: 4.0),
            RadarChartDataEntry(value: 3.2)
        ]
    ).then {
        $0.fillColor = .clear
    }
    
    func isCompare() {
        print("이즈컴페어 : \(isCompared)")
        if isCompared == true {
            compareViewEmpty.isHidden = true
            compareView2.isHidden = false
            closeButton.isHidden = false
            compareLabel2.isHidden = false
            chartCompareLabel1.isHidden = false
            chartCompareImageView1.isHidden = false
            chartCompareLabel2.isHidden = false
            chartCompareImageView2.isHidden = false
            view.addSubview(compareView2)
            compareView2.addSubview(insideLabel2)
            compareView2.addSubview(insideRateLabel2)
            compareView2.addSubview(publicSpaceLabel2)
            compareView2.addSubview(publicSpaceRateLabel2)
            compareView2.addSubview(locationConditionLabel2)
            compareView2.addSubview(locationConditionRateLabel2)
            compareView2.addSubview(totalLabel2)
            compareView2.addSubview(totalRateLabel2)
            view.addSubview(closeButton)
            view.addSubview(compareLabel2)
            view.addSubview(chartCompareLabel1)
            view.addSubview(chartCompareImageView1)
            view.addSubview(chartCompareLabel2)
            view.addSubview(chartCompareImageView2)
            compareView2.snp.makeConstraints{
                $0.top.equalTo(compareLabel1.snp.bottom).offset(12)
                $0.right.equalToSuperview().inset(24)
            }
            closeButton.snp.makeConstraints{
                $0.right.equalToSuperview().inset(18)
                $0.top.equalTo(compareView2.snp.top).offset(-10)
                $0.height.equalTo(22)
            }
            compareLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(77)
                $0.centerX.equalTo(compareView2)
            }
            chartCompareImageView1.snp.makeConstraints{
                $0.top.equalTo(compareView1.snp.bottom).offset(28)
                $0.left.equalToSuperview().offset(21)
                $0.height.equalTo(11)
            }
            chartCompareLabel1.snp.makeConstraints{
                $0.top.equalTo(compareView1.snp.bottom).offset(25)
                $0.left.equalTo(chartCompareImageView1.snp.right).offset(4)
                $0.height.equalTo(17)
            }
            chartCompareImageView2.snp.makeConstraints{
                $0.top.equalTo(chartCompareImageView1.snp.bottom).offset(8)
                $0.left.equalToSuperview().offset(21)
                $0.height.equalTo(11)
            }
            chartCompareLabel2.snp.makeConstraints{
                $0.top.equalTo(chartCompareLabel1.snp.bottom).offset(2)
                $0.left.equalTo(chartCompareImageView2.snp.right).offset(4)
                $0.height.equalTo(17)
            }
            insideLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(12)
                $0.left.equalToSuperview().offset(12)
                $0.height.equalTo(20)
            }
            insideRateLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(12)
                $0.left.equalToSuperview().offset(110)
                $0.height.equalTo(20)
            }
            
            publicSpaceLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(36)
                $0.left.equalToSuperview().offset(12)
                $0.height.equalTo(20)
            }
            publicSpaceRateLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(36)
                $0.left.equalToSuperview().offset(110)
                $0.height.equalTo(20)
            }
            locationConditionLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(60)
                $0.left.equalToSuperview().offset(12)
                $0.height.equalTo(20)
            }
            locationConditionRateLabel2.snp.makeConstraints{
                $0.top.equalToSuperview().offset(60)
                $0.left.equalToSuperview().offset(110)
                $0.height.equalTo(20)
            }
            totalLabel2.snp.makeConstraints{
                $0.bottom.equalToSuperview().inset(12)
                $0.left.equalToSuperview().offset(12)
                $0.height.equalTo(20)
            }
            totalRateLabel2.snp.makeConstraints{
                $0.bottom.equalToSuperview().inset(12)
                $0.left.equalToSuperview().offset(110)
                $0.height.equalTo(20)
            }
        }
    }
    
    func getReportInfo(limjangId: Int, accessToken: String) {
        print("비교매물")
        print(limjangId)
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
                if let json = value as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let limjangDto = result["limjangDto"] as? [String: Any],
                   let reportDTO = result["reportDTO"] as? [String: Any] {
                    print("Response2 JSON: \(json)")
                    do {
                        let decoder = JSONDecoder()
                        let reportData = try JSONSerialization.data(withJSONObject: reportDTO, options: [])
                        let reportDto = try decoder.decode(ReportDTO.self, from: reportData)
                        self.setData(reportDto: reportDto)
                        
                    } catch {
                        print("JSON2 디코딩 에러: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func setData(reportDto: ReportDTO) {
        updateRate(rate: String(format: "%.2f", reportDto.indoorRate), label: insideRateLabel2)
        updateRate(rate: String(format: "%.2f", reportDto.locationConditionsRate), label: locationConditionRateLabel2)
        updateRate(rate: String(format: "%.2f", reportDto.publicSpaceRate), label: publicSpaceRateLabel2)
        updateRate(rate: String(format: "%.2f", reportDto.totalRate), label: totalRateLabel2)
        
        
        compareDataSet2 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: Double(reportDto.indoorRate)),
                RadarChartDataEntry(value: Double(reportDto.locationConditionsRate)),
                RadarChartDataEntry(value: Double(reportDto.publicSpaceRate))
            ]
        )
        
        compareDataSet2.fillAlpha = CGFloat(0.7)
        compareDataSet2.fillColor = .white
        setCompareData()
    }
    
    func updateRate(rate: String, label: UILabel){
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "grayStar")
        if label == totalRateLabel1 || label == totalRateLabel2 {
            text1.image = UIImage(named: "star")
        }
        let text2 = " " + rate
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        label.attributedText = text3
    }
    
    func setData(indoor: Float, location: Float, publicSpace: Float) {
        indoorRate1 = indoor
        locationRate1 = location
        publicRate1 = publicSpace
    }
    
    func setCompareData() {
        let dataSet1 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 1.0),
                RadarChartDataEntry(value: 1.0),
                RadarChartDataEntry(value: 1.0)
            ]
        )
        let dataSet2 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 2.0),
                RadarChartDataEntry(value: 2.0),
                RadarChartDataEntry(value: 2.0)
            ]
        )
        let dataSet3 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 3.0),
                RadarChartDataEntry(value: 3.0),
                RadarChartDataEntry(value: 3.0)
            ]
        )
        let dataSet4 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 4.0),
                RadarChartDataEntry(value: 4.0),
                RadarChartDataEntry(value: 4.0)
            ]
        )
        let dataSet5 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 5.0),
                RadarChartDataEntry(value: 5.0),
                RadarChartDataEntry(value: 5.0)
            ]
        )
        
        let compareDataSet1 = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: Double(indoorRate1)),
                RadarChartDataEntry(value: Double(locationRate1)),
                RadarChartDataEntry(value: Double(publicRate1))
            ]
        )
        
        let data = RadarChartData(dataSets: [dataSet5, dataSet4, dataSet3, dataSet2, dataSet1,  compareDataSet2,compareDataSet1])
        radarChartView.data = data
        
        dataSet1.lineWidth = 0
        dataSet2.lineWidth = 0
        dataSet3.lineWidth = 0
        dataSet4.lineWidth = 0
        dataSet5.lineWidth = 0
        compareDataSet1.lineWidth = 0
        compareDataSet2.lineWidth = 0
        
        // entries의 값을 가져옴
        let entries = compareDataSet2.entries.map { entry in
            return (entry as? RadarChartDataEntry)?.value ?? 0.0
        }
        
        if (entries.filter { $0 == 0 }.count == 2) {
            compareDataSet2.lineWidth = 1
            compareDataSet2.setColor(.white)
        } else {
            compareDataSet2.lineWidth = 0 // 기본 lineWidth 값을 설정
        }
        
        let dataColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 0.3)
        
        dataSet1.fillColor = dataColor
        dataSet2.fillColor = dataColor
        dataSet3.fillColor = dataColor
        dataSet4.fillColor = dataColor
        dataSet5.fillColor = dataColor
        compareDataSet1.fillAlpha = CGFloat(0.55)
        compareDataSet1.fillColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 1)
        
        
        dataSet1.drawFilledEnabled = true
        dataSet2.drawFilledEnabled = true
        dataSet3.drawFilledEnabled = true
        dataSet4.drawFilledEnabled = true
        dataSet5.drawFilledEnabled = true
        compareDataSet1.drawFilledEnabled = true
        compareDataSet2.drawFilledEnabled = true
        
        dataSet1.valueFormatter = DataSetValueFormatter()
        dataSet2.valueFormatter = DataSetValueFormatter()
        dataSet3.valueFormatter = DataSetValueFormatter()
        dataSet4.valueFormatter = DataSetValueFormatter()
        dataSet5.valueFormatter = DataSetValueFormatter()
        compareDataSet1.valueFormatter = DataSetValueFormatter()
        compareDataSet2.valueFormatter = DataSetValueFormatter()
    }
    
    
    func addTarget() {
        compareViewEmpty.addTarget(self, action: #selector(compareButtonTap), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeBtnTap), for: .touchUpInside)
    }
    @objc private func compareButtonTap() {
        //비교할 매물이 없을 때
        /*let popupViewController = NoMaemullPopupViewController(ment: "비교할 매물이 아직 없어요.\n다른 매물이 생기면 다시 와주세요!")
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)*/
        
        //비교할 매물이 있을 때
        let vc = SelectMaemullViewController(imjangId: imjangId)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func closeBtnTap() {
        isCompared = false
        compareViewEmpty.isHidden = false
        compareView2.isHidden = true
        closeButton.isHidden = true
        compareLabel2.isHidden = true
        chartCompareLabel1.isHidden = true
        chartCompareImageView1.isHidden = true
        chartCompareLabel2.isHidden = true
        chartCompareImageView2.isHidden = true
        
        compareDataSet2.fillColor = .clear
        setCompareData()
    }
    
    func setConstraint() {
        backgroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        compareLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(77)
            $0.centerX.equalTo(compareView1)
            $0.height.equalTo(20)
        }
        vsImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(11)
            $0.width.equalTo(18)
        }
        
        compareView1.snp.makeConstraints{
            $0.top.equalTo(compareLabel1.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(24)
        }
        
        insideLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        insideRateLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(110)
            $0.height.equalTo(20)
        }
        
        publicSpaceLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(36)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        publicSpaceRateLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(36)
            $0.left.equalToSuperview().offset(110)
            $0.height.equalTo(20)
        }
        locationConditionLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        locationConditionRateLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(110)
            $0.height.equalTo(20)
        }
        totalLabel1.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(12)
            $0.left.equalToSuperview().offset(12)
            $0.height.equalTo(20)
        }
        totalRateLabel1.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(12)
            $0.left.equalToSuperview().offset(110)
            $0.height.equalTo(20)
        }
        
        compareViewEmpty.snp.makeConstraints{
            $0.top.equalTo(compareLabel1.snp.bottom).offset(12)
            $0.right.equalToSuperview().inset(24)
        }
        
        radarChartView.snp.makeConstraints {
            $0.top.equalTo(compareView1.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(350)
            $0.width.equalTo(700)
        }
        
    }
    
    init(imjangId: Int) {
        self.imjangId = imjangId
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "reportBG")
        view.addSubview(backgroundImageView)
        view.addSubview(compareLabel1)
        view.addSubview(vsImageView)
        view.addSubview(compareView1)
        compareView1.addSubview(insideLabel1)
        compareView1.addSubview(insideRateLabel1)
        compareView1.addSubview(publicSpaceLabel1)
        compareView1.addSubview(publicSpaceRateLabel1)
        compareView1.addSubview(locationConditionLabel1)
        compareView1.addSubview(locationConditionRateLabel1)
        compareView1.addSubview(totalLabel1)
        compareView1.addSubview(totalRateLabel1)
        view.addSubview(compareViewEmpty)
        isCompare()
        
        view.addSubview(radarChartView)
        setCompareData()
        
        addTarget()
        setConstraint()
    }
}
