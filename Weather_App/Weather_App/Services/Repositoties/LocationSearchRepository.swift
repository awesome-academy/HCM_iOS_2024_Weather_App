//
//  LocationSearchRepository.swift
//  Weather_App
//
//  Created by ho.bao.an on 29/03/2024.
//

import Foundation
import MapKit

final class LocationSearchRepository {
    static func getSearchResults(for searchText: String, completion: @escaping ([MKMapItem]?, Error?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.start { responseSearch, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let responseSearch = responseSearch else {
                completion(nil, nil)
                return
            }
            completion(responseSearch.mapItems, nil)
        }
    }
}
