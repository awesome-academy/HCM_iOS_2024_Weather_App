//
//  CustomNavigationBar.swift
//  Weather_App
//
//  Created by An Bảo on 24/03/2024.
//

import UIKit

extension UIViewController {
    func customizeNavigationController() {
        navigationController?.navigationBar.backgroundColor = .blueGreenCustom
    }
    
    func customizeSearchController(searchController: UISearchController) {
        if let searchBarTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchBarTextField.backgroundColor = .blueGreenCustom
            searchBarTextField.backgroundColor = .white
            searchBarTextField.textColor = .black
            searchBarTextField.tintColor = .black
            if let searchIcon = searchBarTextField.leftView as? UIImageView {
                searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
                searchIcon.tintColor = .black
            }
        }
        searchController.searchBar.backgroundColor = .blueGreenCustom
        searchController.searchBar.addShadow()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
    }
}

