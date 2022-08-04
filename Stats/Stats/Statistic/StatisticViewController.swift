//
//  StatisticViewController.swift
//  Stats
//
//  Created by max on 03.05.2022.
//

import Foundation
import TinyConstraints
import UIKit

class StatisticViewController: UIViewController, PageViewControllerDelegate {
    
    private var thePageVC: PageViewController!
    
    private lazy var pageViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Metric.pageVCBackgroundColor
        return view
    }()
    
    private let items = Metric.pageVCItems
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: items)
        control.height(SegmentedControl.height)
        control.selectedSegmentIndex = SegmentedControl.selectedSegmentIndex
        control.layer.cornerRadius = SegmentedControl.layerCornerRadius
        control.layer.masksToBounds = true
        control.layer.borderColor = SegmentedControl.borderColor
        control.layer.backgroundColor = SegmentedControl.backgroundColor
        let titleSelectedTextAttributes = [NSAttributedString.Key.foregroundColor: SegmentedControl.selectedTextColor]
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: SegmentedControl.normalTextColor]
        control.setTitleTextAttributes(titleTextAttributes, for: .normal)
        control.setTitleTextAttributes(titleSelectedTextAttributes, for: .selected)
        
        control.addTarget(self, action: #selector(handleSegmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        thePageVC = PageViewController(selectHandler: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// function sets selected state in UISegmentedControl
    /// - Parameter page: selected  segment
    func setSelectedState(page: Int) {
        segmentedControl.selectedSegmentIndex = page
    }
    
    @objc
    func handleSegmentedControlValueChanged(_ sender: UISegmentedControl){
        
        thePageVC.goToPage(index: sender.selectedSegmentIndex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        segmentedControl.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets(top: SegmentedControl.topInsect, left: SegmentedControl.leftInsect, bottom: SegmentedControl.bottomInsect, right: SegmentedControl.rightInsect), usingSafeArea: true)

        view.addSubview(pageViewContainer)
        pageViewContainer.top(to: segmentedControl, segmentedControl.bottomAnchor)
        pageViewContainer.leftToSuperview()
        pageViewContainer.rightToSuperview()
        pageViewContainer.bottomToSuperview()
        
        addChild(thePageVC)
        pageViewContainer.addSubview(thePageVC.view)
        thePageVC.view.edgesToSuperview()
        thePageVC.didMove(toParent: self)
    }
}

extension StatisticViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension StatisticViewController {
    enum Metric {
        static let pageVCItems: [String] = ["All", "My country", "All countries"]
        static let pageVCBackgroundColor: UIColor = .white
    }
    enum SegmentedControl {
        static let height: CGFloat = 36
        static let selectedSegmentIndex: Int = 0
        static let layerCornerRadius: CGFloat = 8
        static let backgroundColor: CGColor = UIColor.darkGray.cgColor
        static let borderColor: CGColor = UIColor.darkGray.cgColor
        static let selectedTextColor: UIColor = UIColor.darkGray
        static let normalTextColor: UIColor = UIColor.white
        static let topInsect: CGFloat = 20
        static let leftInsect: CGFloat = 20
        static let rightInsect: CGFloat = 20
        static let bottomInsect: CGFloat = 20
    }
}


