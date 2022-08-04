//
//  ListOfCountriesViewController.swift
//  Stats
//
//  Created by max on 03.05.2022.
//

import UIKit
import TinyConstraints

protocol ListOfCountriesViewControllerDelegate: AnyObject {
    
    func didSelectCountry(with data: Country)
}

class ListOfCountriesViewController: UIViewController, UICollectionViewDelegate, ListOfCountriesViewInput , UISearchResultsUpdating{

    private var timer: Timer?
    private var searchController: UISearchController!
    var filteredData: [Country] = []
    var countriesData: [Country] = []
    
    var output: ListOfCountriesViewOutput!
    
    enum Section: Hashable {
        
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource <Section,  Country>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot <Section, Country>
    
    private var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionalLayout())
        collectionView.frame = self.view.frame
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(ListOfCountriesCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white

        return collectionView
    }()

    weak var delegate: ListOfCountriesViewControllerDelegate!
    
    func searchControllerSetup() {
        
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Metrics.searchBarPlaceholderText
        
        searchController.searchBar.searchTextField.layer.cornerRadius = Metrics.searchBarTextFieldCornerRadius
        searchController.searchBar.searchTextField.clipsToBounds = false
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.barTintColor = .clear
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.searchTextField.textColor = .systemGray6
        
        let barAppearance = UINavigationBarAppearance()
            barAppearance.configureWithTransparentBackground()
            barAppearance.backgroundColor = .clear
            barAppearance.shadowColor = nil
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
            navigationController?.navigationBar.standardAppearance = barAppearance
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { Timer in
            searchController.showsSearchResultsController = true
            self.refreshFiltered()
        })
    }
    
    func refreshFiltered(){
        let searchBarText = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
        
        if !searchBarText.isEmpty {
            self.output.obtainFilteredResults(searchText: searchBarText, dataToSearch: self.countriesData) { result in
                self.filteredData = result
                self.applySnapshot(data: result)
            }
        }
        else {
            self.applySnapshot(data: self.countriesData)
        }
    }
    
    func getCompositionalLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
            
            return section
        }
        return layout
    }
    
    func configureCollectionViewDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, country) -> ListOfCountriesCollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ListOfCountriesCollectionViewCell
            cell.configure(with: country)
            return cell
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = dataSource.itemIdentifier(for: indexPath) else {return}
        
        delegate.didSelectCountry(with: data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchControllerSetup()
        setupViews()
        configureCollectionViewDataSource()
        output.obtainCountriesData()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
        
    }
    
    func applySnapshot(data: [Country]) {
        
        self.snapshot = DataSourceSnapshot()
        self.snapshot.appendSections([Section.main])
        self.snapshot.appendItems(data)
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }
    
    func updateSelectedCell(indexPath: IndexPath) {
        guard let charItem = self.dataSource.itemIdentifier(for: IndexPath(row: indexPath.row, section: indexPath.section)) else { return }

        self.snapshot = self.dataSource.snapshot()
        self.snapshot.reloadItems([charItem])
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }
}

extension ListOfCountriesViewController {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard searchController.isActive else {
            output.obtainFlagForTheCountry(indexPath: indexPath, countryCode: countriesData[indexPath.row].countryCode.lowercased())
            return
        }
        if indexPath.row < filteredData.count  {
            output.obtainFlagForTheCountry(indexPath: indexPath, countryCode: filteredData[indexPath.row].countryCode.lowercased())
        }
    }
}

extension ListOfCountriesViewController {
    enum Metrics {
        static let searchBarPlaceholderText: String = "Type country`s name"
        static let searchBarTextFieldCornerRadius: CGFloat = 10.0
        static let searchBarHeight: CGFloat = 48
    }
}
