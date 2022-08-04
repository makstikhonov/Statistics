//
//  MyFavouriteCountryPresenter.swift
//  Stats
//
//  Created by max on 15.07.2022.
//

import Foundation

class MyFavouriteCountryPresenter: MyFavouriteCountryViewOutput {

    weak var view: MyFavouriteCountryViewInput?
    
    func didTapOnDefaultCell() {
        view?.gotoAllCountriesList()
    }
}
