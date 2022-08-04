//
//  AllCountriesCollectionViewController.swift
//  Stats
//
//  Created by max on 29.07.2022.
//

import Foundation
import UIKit



class AllCountriesCollectionViewController: UIViewController, AllCountriesViewInput {
    
    var output: AllCountriesViewOutput!
    var mergeResults = [AllCountriesItemWrapper]()
    
    typealias DataSource = UICollectionViewDiffableDataSource <AllCountriesSection,  AllCountriesItemWrapper>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot <AllCountriesSection,  AllCountriesItemWrapper>
    
    private var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionalLayout())
        collectionView.frame = self.view.frame
        collectionView.register(AllCountriesDataCollectionViewCell.self, forCellWithReuseIdentifier: Metric.allCountriesDataCellIdentifier)
        collectionView.register(AllCountriesChartCollectionViewCell.self, forCellWithReuseIdentifier: Metric.allCountriesChartsCellIdentifier)
        collectionView.register(AllCountriesHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Metric.allCountriesHeaderViewIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    func configureCollectionViewDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, dataItem) -> UICollectionViewCell? in
            switch dataItem {
            case .charts(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Metric.allCountriesChartsCellIdentifier, for: indexPath) as! AllCountriesChartCollectionViewCell
                cell.configure(with: item)
                return cell
            case .data(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Metric.allCountriesDataCellIdentifier, for: indexPath) as! AllCountriesDataCollectionViewCell
                cell.configure(with: data)
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Metric.allCountriesHeaderViewIdentifier, for: indexPath) as? AllCountriesHeaderViewCell else {
              fatalError()
            }
            headerView.configure(with: "\(AllCountriesSection.allCases[indexPath.section].rawValue)".capitalized)
            return headerView
          }
    }
    
    func getCompositionalLayout() -> UICollectionViewLayout{
        
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
           
            switch AllCountriesSection.allCases[sectionNumber] {
            case .charts:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                    section.boundarySupplementaryItems = [header]
                
                return section
            case .data:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
                let section = NSCollectionLayoutSection(group: group)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                    section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
        
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureCollectionViewDataSource()
        output.obtainAllCountriesDataForCharts()
        output.obtainAllCountriesData()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
    
    /// function applies new data to the cells
    /// - Parameter data: new data array
    func applySnapshot(data: [AllCountriesItemWrapper]?) {
        
        guard let itemsData = data else {return}
        self.snapshot = DataSourceSnapshot()
        
        for section in AllCountriesSection.allCases {
            let items = itemsData.filter {
                switch $0 {
                case .charts(let item):
                    return item.section == section
                case .data(let data):
                    return data.section == section
                }
            }
            self.snapshot.appendSections([section])
            self.snapshot.appendItems(items)
        }
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }
}

extension AllCountriesCollectionViewController {
    enum Metric {
        static let allCountriesDataCellIdentifier: String = "AllCountriesDataViewCell"
        static let allCountriesChartsCellIdentifier: String = "CollectionChartCell"
        static let allCountriesHeaderViewIdentifier: String = "HeaderView"
    }
}
