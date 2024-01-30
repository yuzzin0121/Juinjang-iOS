//
//  GraphViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/26/24.
//
import UIKit
import Then
import DGCharts
import Charts

class GraphViewController : UIViewController {
    
    var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named:"PaperTexture")
    }
    
    var label1 = UILabel().then {
        $0.text = "이곳은 한 마디로..."
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 0.6)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var noteImageView = UIImageView().then {
        $0.image = UIImage(named:"노트점선")
    }
    
    var houseimageView = UIImageView().then {
        $0.image = UIImage(named: "house")
    }
    var houseLabel = UILabel().then {
        $0.text = "상당히 쾌적한 실내"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var rateLabel1 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "reportStar")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var buildingimageView = UIImageView().then {
        $0.image = UIImage(named: "building")
    }
    var buildingLabel = UILabel().then {
        $0.text = "훌륭한 공용공간"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var rateLabel2 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "reportStar")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var locationimageView = UIImageView().then {
        $0.image = UIImage(named: "location")
    }
    var locationLabel = UILabel().then {
        $0.text = "좋은 편인 입지 여건"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = UIColor(named: "500")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var rateLabel3 = UILabel().then {
        let text1 = NSTextAttachment()
        text1.image = UIImage(named: "reportStar")
        let text2 = " " + "4.5"
        let text3 = NSMutableAttributedString(string: "")
        text3.append(NSAttributedString(attachment: text1))
        text3.append(NSAttributedString(string: text2))
        $0.attributedText = text3
        $0.textColor = UIColor(named: "300")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var graphImageView = UIImageView().then {
        $0.image = UIImage(named: "삼각그래프")
    }
    
    var graphContainerView = UIView().then{
        $0.backgroundColor = .white
    }
    
    var radarChartView = RadarChartView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.webLineWidth = 0
        $0.innerWebLineWidth = 1.5
        $0.innerWebColor = .clear
        $0.frame = CGRect(x: 60, y: 300, width: 300, height: 300)
       
        
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
    
    func setData() {
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
                RadarChartDataEntry(value: 3.0),
                RadarChartDataEntry(value: 2.8),
                RadarChartDataEntry(value: 4.0)
            ]
        )
        
        let data = RadarChartData(dataSets: [dataSet5, dataSet4, dataSet3, dataSet2, dataSet1, compareDataSet1])
        radarChartView.data = data
        
        dataSet1.lineWidth = 0
        dataSet2.lineWidth = 0
        dataSet3.lineWidth = 0
        dataSet4.lineWidth = 0
        dataSet5.lineWidth = 0
        compareDataSet1.lineWidth = 0
        
        let dataColor = UIColor(red: 1, green: 0.386, blue: 0.158, alpha: 0.3)
        let dataColor1 = UIColor.red
        dataSet1.colors = [dataColor]
        
        dataSet1.fillColor = dataColor
        dataSet1.drawFilledEnabled = true
        
        dataSet2.fillColor = dataColor
        dataSet2.drawFilledEnabled = true
        dataSet3.drawFilledEnabled = true
        dataSet4.drawFilledEnabled = true
        dataSet5.drawFilledEnabled = true
        compareDataSet1.drawFilledEnabled = true
        dataSet3.fillColor = dataColor
        dataSet4.fillColor = dataColor
        dataSet5.fillColor = dataColor
        compareDataSet1.fillColor = dataColor1
        
        dataSet1.valueFormatter = DataSetValueFormatter()
        dataSet2.valueFormatter = DataSetValueFormatter()
        dataSet3.valueFormatter = DataSetValueFormatter()
        dataSet4.valueFormatter = DataSetValueFormatter()
        dataSet5.valueFormatter = DataSetValueFormatter()
        
        compareDataSet1.valueFormatter = DataSetValueFormatter()
    }
    
    func setConstraint() {
        backgroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        label1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(70)
            $0.left.equalToSuperview().offset(24)
        }
        
        noteImageView.snp.makeConstraints{
            $0.top.equalTo(label1.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(128)
        }
        
        houseimageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview()
            $0.height.equalTo(18)
        }
        houseLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.left.equalTo(houseimageView.snp.right).offset(8)
            $0.height.equalTo(24)
        }
        rateLabel1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        buildingimageView.snp.makeConstraints{
            $0.top.equalTo(houseimageView.snp.bottom).offset(25)
            $0.left.equalToSuperview()
            $0.height.equalTo(18)
        }
        buildingLabel.snp.makeConstraints{
            $0.top.equalTo(houseLabel.snp.bottom).offset(18)
            $0.left.equalTo(buildingimageView.snp.right).offset(8)
            $0.height.equalTo(24)
        }
        rateLabel2.snp.makeConstraints{
            $0.top.equalTo(rateLabel1.snp.bottom).offset(19)
            $0.right.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        locationimageView.snp.makeConstraints{
            $0.top.equalTo(buildingimageView.snp.bottom).offset(24)
            $0.left.equalToSuperview()
            $0.height.equalTo(18)
        }
        locationLabel.snp.makeConstraints{
            $0.top.equalTo(buildingLabel.snp.bottom).offset(18)
            $0.left.equalTo(locationimageView.snp.right).offset(8)
            $0.height.equalTo(24)
        }
        rateLabel3.snp.makeConstraints{
            $0.top.equalTo(rateLabel2.snp.bottom).offset(19)
            $0.right.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        radarChartView.snp.makeConstraints {
            $0.top.equalTo(noteImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(350)
            $0.width.equalTo(700)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "reportBG")
        view.addSubview(backgroundImageView)
        view.addSubview(label1)
        view.addSubview(noteImageView)
        
        noteImageView.addSubview(houseimageView)
        noteImageView.addSubview(houseLabel)
        houseLabel.asColor(targetString: "상당히 쾌적한", color: UIColor(named: "juinjang"))
        noteImageView.addSubview(rateLabel1)
        
        noteImageView.addSubview(buildingimageView)
        noteImageView.addSubview(buildingLabel)
        buildingLabel.asColor(targetString: "훌륭한", color: UIColor(named: "juinjang"))
        noteImageView.addSubview(rateLabel2)
        
        noteImageView.addSubview(locationimageView)
        noteImageView.addSubview(locationLabel)
        locationLabel.asColor(targetString: "좋은 편인", color: UIColor(named: "juinjang"))
        noteImageView.addSubview(rateLabel3)
        
        view.addSubview(radarChartView)
        setData()
        
        setConstraint()
    }
}


class DataSetValueFormatter: ValueFormatter {
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        ""
    }
}

class XAxisFormatter: AxisValueFormatter {
    
    let titles = [" \n실내","입지\n여건","공용\n공간"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value) % titles.count
        return titles[index]
    }
}


class YAxisFormatter: AxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        ""
    }
}
