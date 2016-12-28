//
//  TableViewController.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/22/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import MapKit

class SearchResultController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var matchingItems:[MKMapItem] = [] {
        didSet {
            searchDisplayController?.searchResultsTableView.reloadData()
        }
    }
    var mapView: MKMapView? = nil
    
    var locationDelegate: SetLocationLabelDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        //navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        //searchDisplayController?.delegate = self
        searchDisplayController?.searchResultsTableView.delegate = self
        searchDisplayController?.searchResultsTableView.dataSource = self
        
        //searchDisplayController?.searchResultsTableView.isHidden = true
        
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("user did change searchText was called text: \(searchText)")
        updateSearchResultsForSearchController()
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String!) -> Bool {
        print("Search Display Controller shouldreload table search text: \(searchString)")
        return true
        
    }
    
    @IBAction func dismissSelf(_ sender: UIBarButtonItem) {
        //performSegue(withIdentifier: "goBack", sender: self)
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    func updateSearchResultsForSearchController() {
        guard let mapView = mapView,
            let searchBarText = searchBar.text else { self.matchingItems.removeAll(); return }
        print("searchBar text: \(searchBarText)")
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            
            DispatchQueue.main.async {
                //print(response.mapItems)
                self.matchingItems = response.mapItems
            }
        }
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        //print(tableView == self.tableView)
        var cell: UITableViewCell? = nil
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell");
        } else {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        }
        let selectedItem = matchingItems[indexPath.row].placemark
        cell?.textLabel?.text = selectedItem.name
        cell?.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        
       
        return cell!
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(matchingItems[indexPath.row])
        let selectedItem = matchingItems[indexPath.row].placemark

        locationDelegate?.location = selectedItem.name!
        locationDelegate?.location2 = parseAddress(selectedItem: selectedItem)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
