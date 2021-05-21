//
//  LocationSearchTable.swift
//  OCKSample
//
//  Created by Abigail Mortell on 11/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    var matchingItems:[MKMapItem] = []
    var map: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let map = map,
              let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = map.region
        let search = MKLocalSearch(request: request)
        search.start {
            response, _ in guard let response = response else {
                return
            }
        self.matchingItems = response.mapItems
        self.tableView.reloadData()
        }
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(format:"%@%@%@%@%@%@%@",
                                 selectedItem.subThoroughfare ?? "",
                                 firstSpace,
                                 selectedItem.thoroughfare ?? "",
                                 comma,
                                 selectedItem.locality ?? "",
                                 secondSpace,
                                 selectedItem.administrativeArea ?? ""
                                 )
        return addressLine
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
