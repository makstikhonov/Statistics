//
//  MyCountryViewController.swift
//  Stats
//
//  Created by max on 03.05.2022.
//

import UIKit
import TinyConstraints

class MyFavouriteCountryViewController: UIViewController, ListOfCountriesViewControllerDelegate, MyFavouriteCountryViewInput {
    
    var output: MyFavouriteCountryViewOutput!
    
    var pageVC: PageViewController!
    private var countryData: [MyFavouriteCountryItemWrapper]?
    
    init (pageVC: PageViewController){
        super.init(nibName: nil, bundle: nil)
        self.pageVC = pageVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource <MyFavouriteCountrySection,  MyFavouriteCountryItemWrapper>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot <MyFavouriteCountrySection,  MyFavouriteCountryItemWrapper>
    
    private var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionalLayout())
        collectionView.frame = self.view.frame
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(MyFavouriteCountryStatisticViewCell.self, forCellWithReuseIdentifier: Metrics.statisticCellIdentifier)
        collectionView.register(MyFavouriteCountryMapViewCell.self, forCellWithReuseIdentifier: Metrics.mapCellIdentifier)
        collectionView.register(MyFavouriteCountryDefaultCell.self, forCellWithReuseIdentifier: Metrics.defaultCellIdentifier)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    func configureCollectionViewDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, dataItem) -> UICollectionViewCell? in
            switch dataItem {
            case .info(let info):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Metrics.statisticCellIdentifier, for: indexPath) as! MyFavouriteCountryStatisticViewCell
                cell.configure(with: info.country)
                return cell
            case .map(let mapData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Metrics.mapCellIdentifier, for: indexPath) as! MyFavouriteCountryMapViewCell
                cell.configure(with: mapData.country)
                return cell
            case .none:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Metrics.defaultCellIdentifier, for: indexPath) as! MyFavouriteCountryDefaultCell
                cell.button.addTarget(self, action: #selector(self.didTapOnDefaultCell), for: .touchUpInside)
                return cell
            }
        })
    }
    
    func getCompositionalLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
            switch MyFavouriteCountrySection.allCases[sectionNumber] {
            case .info:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
                                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
                
                return section
                
            case .map:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
                
                return section
                
            case .none:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
                
                return section
            }
        }
        return layout
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureCollectionViewDataSource()
        defaultCellInit()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
    
    func didSelectCountry(with data: Country) {
        pageVC.goToPage(index: 1)
        countryData = [MyFavouriteCountryItemWrapper.info(InfoItem(country: data)), MyFavouriteCountryItemWrapper.map(MapItem(country: data))]
        applySnapshot(data: countryData)
    }
    
    func gotoAllCountriesList() {
        pageVC.goToPage(index: 2)
    }
    
    @objc
    func didTapOnDefaultCell(){
        output.didTapOnDefaultCell()
    }
    
    /// Shows cell with button at first screen launch
    private func defaultCellInit() {
        let defaultCell = [MyFavouriteCountryItemWrapper.none]
        applySnapshot(data: defaultCell)
    }
    
    func applySnapshot(data: [MyFavouriteCountryItemWrapper]?) {
        
        guard let itemsData = data else {return}
        self.snapshot = DataSourceSnapshot()
        
        for section in MyFavouriteCountrySection.allCases {
            let items = itemsData.filter {
                switch $0 {
                case .info(let item):
                    return item.section == section
                case .map(let data):
                    return data.section == section
                case .none:
                    return section == .none
                }
            }
            self.snapshot.appendSections([section])
            self.snapshot.appendItems(items)
        }
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }
    
}

extension MyFavouriteCountryViewController {
    enum Metrics {
        static let statisticCellIdentifier: String = "CollectionViewStatCell"
        static let defaultCellIdentifier: String = "CollectionViewDefaultCell"
        static let mapCellIdentifier: String = "CollectionViewMapCell"
        
    }
    
    
}
