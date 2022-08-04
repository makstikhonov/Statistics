//
//  PageViewController.swift
//  Stats
//
//  Created by max on 03.05.2022.
//

import Foundation
import UIKit

protocol PageViewControllerDelegate: AnyObject {
    func setSelectedState(page: Int)
}

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
 
    private var pages: [UIViewController] = []
    var selectHandler: PageViewControllerDelegate!
    private var currentIndex: Int {	
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(selectHandler: PageViewControllerDelegate){
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.selectHandler = selectHandler
        
        let myCountryViewController = MyFavouriteCountryModuleAssembly(pageVC: self).configureModule()
        let listOfCountriesViewController = UINavigationController(rootViewController: ListOfCountriesModuleAssembly(delegate: myCountryViewController).configureModule())
        let allCountriesViewController = AllCountriesModuleAssembly().configureModule()

        pages = [allCountriesViewController, myCountryViewController, listOfCountriesViewController]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        view.backgroundColor = .white
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        let previousIndex = currentIndex - 1
                guard previousIndex >= 0 else {
                    return nil
                }

        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let nextIndex = currentIndex + 1
                guard nextIndex < pages.count else {
                    return nil
                }

        return pages[nextIndex]
    }
    
    
    /// function swithes pages in UIPageViewController
    /// - Parameter index: page index
    func goToPage(index: Int) {
        var direction: UIPageViewController.NavigationDirection{
            if index > currentIndex {
                return .forward
            }
            return .reverse
        }
        
        setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
        selectHandler.setSelectedState(page: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == true {
            selectHandler.setSelectedState(page: currentIndex)
        }
    }
}
