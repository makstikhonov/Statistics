//
//  MyFavouriteCountryModuleAssembly.swift
//  Stats
//
//  Created by max on 15.07.2022.
//

import Foundation
import UIKit

class MyFavouriteCountryModuleAssembly   {
    
    private var pageVC: PageViewController!

    init(pageVC: PageViewController) {
        self.pageVC = pageVC;
    }
    
    func configureModule() -> MyFavouriteCountryViewController{
        
        let view = MyFavouriteCountryViewController(pageVC: pageVC)
        let presenter = MyFavouriteCountryPresenter()
        
        view.output = presenter
        presenter.view = view
        
        return view
    }
    
}
