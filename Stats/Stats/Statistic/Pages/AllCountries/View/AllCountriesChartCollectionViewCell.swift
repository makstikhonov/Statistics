//
//  AllCountriesChartViewCell.swift
//  Stats
//
//  Created by max on 12.07.2022.
//

import UIKit
import TinyConstraints
import Charts

class AllCountriesChartCollectionViewCell: UICollectionViewCell, ChartViewDelegate{
    
    private lazy var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = RoundedView.radius
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var lineChartView: LineChartView = {
       let chartView = LineChartView()
        chartView.backgroundColor = LineChart.backgroundColor
        chartView.layer.masksToBounds = true
        chartView.layer.cornerRadius = LineChart.radius
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = true
        chartView.leftAxis.valueFormatter = YAxisValueFormatter()
        chartView.xAxis.enabled = true
        chartView.xAxis.valueFormatter = XAxisValueFormatter()
        chartView.animate(yAxisDuration: LineChart.animationDuration)
        
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(roundedView)
        roundedView.edgesToSuperview()
        
        roundedView.addSubview(lineChartView)
        lineChartView.edgesToSuperview()
        
        addSubview(titleLabel)
        titleLabel.left(to: contentView, contentView.leftAnchor, offset: TitleLabel.leftOffset)
        titleLabel.top(to: contentView, contentView.topAnchor, offset: TitleLabel.topOffset)
    }
    func configure(with data: ChartItem) {
       
        let set1 = LineChartDataSet(entries: data.convert(), label: data.description)
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.setColor(.systemCyan)
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        
        lineChartView.data = data
    }
    
}
extension AllCountriesChartCollectionViewCell {
    
    enum RoundedView {
        static let radius: CGFloat = 10.0
    }
    
    enum TitleLabel {
        static let leftOffset: CGFloat = 20
        static let topOffset: CGFloat = 20
    }
    
    enum LineChart {
        static let radius: CGFloat = 10.0
        static let backgroundColor: UIColor = .systemGray3
        static let animationDuration: Double = 1
    }
}

/// Class to format X axis in Charts. X axis shows in years/months
final class XAxisValueFormatter: IndexAxisValueFormatter {
    
    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let date = Date(timeIntervalSince1970: value)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy/MM"
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
}

/// Class to format Y axis in Charts. X axis shows big values in KMBTPE format. For example 1000 - 1K
final class YAxisValueFormatter: IndexAxisValueFormatter {
    
    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        return Int(value).abbreviated
    }
}

extension Int {
    var abbreviated: String {
        let abbrev = "KMBTPE"
        return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
}
