//
//  GasStationsViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/5/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import CloudKit
import GoogleMobileAds

class GasStationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate {
    
    weak var activityIndicatorView: UIActivityIndicatorView! //https://dzone.com/articles/displaying-an-activity-indicator-while-loading-tab
    
    @IBOutlet var tableView: UITableView!
    
    var gasStationsArray = [GasStation]()
    var filteredGasStations = [GasStation]()
    var data = [CKRecord]()
    
    let container = CKContainer.default()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedCell = ""
    
    @IBOutlet var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loading icon
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.activityIndicatorView = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        //Loading advertisement
        self.bannerView.adUnitID = "ca-app-pub-6433292677244522/6849368295"
        self.bannerView.rootViewController = self
        let request: GADRequest = GADRequest()
        self.bannerView.load(request)
        tableView.addSubview(bannerView)
        
        // Retrieve Data
        publicDatabase = container.publicCloudDatabase
        loadTable()
        
        
        // Initialize the pull to refresh control.
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl!.addTarget(self, action: #selector(GasStationsViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        //tableView.addSubview(refreshControl)
        
        // Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height);
        
    }
    
    func refresh(_ sender:AnyObject) {
        //loadTable()
        if refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    func loadTable() {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "Name", ascending: true)
        let query = CKQuery(recordType: "Gas", predicate: pred)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Name", "Photo"]
        operation.resultsLimit = 100;
        
        var newGasStations = [GasStation]()
        operation.recordFetchedBlock = { record in
            
            var gasStationImage = UIImage(named:"nothing")
            if record["Photo"] != nil {
                let imageAsset = record["Photo"] as? CKAsset
                let imageData = NSData(contentsOf: imageAsset!.fileURL)
                gasStationImage = UIImage(data: imageData as! Data)
            }
            
            let gasStationName = record.object(forKey: "Name") as? String
            
            let gasStation = GasStation(name: gasStationName, image: gasStationImage)
            
            if record["Photo"] != nil {
                newGasStations.insert(gasStation, at: 0)
            } else {
                newGasStations.append(gasStation)
            }
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.gasStationsArray = newGasStations
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    self.tableView.reloadData()
                } else {
                    let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of gas stations; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
//    func cloudKitLoadRecords(_ result: @escaping (_ objects: [CKRecord]?, _ error: NSError?) -> Void){
//        
//        // predicate
//        var predicate = NSPredicate(value: true)
//        
//        // query
//        let cloudKitQuery = CKQuery(recordType: "Gas", predicate: predicate)
//        
//        // records to store
//        var records = [CKRecord]()
//        
//        //operation basis
//        let publicDatabase = CKContainer.default().publicCloudDatabase
//        
//        // recurrent operations function
//        var recurrentOperationsCounter = 101
//        func recurrentOperations(_ cursor: CKQueryCursor?){
//            let recurrentOperation = CKQueryOperation(cursor: cursor!)
//            recurrentOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
//
//            }
//            recurrentOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error: Error?) -> Void in
//                if ((error) != nil)
//                {
//                    result(nil, error as NSError?)
//                }
//                else
//                {
//                    if cursor != nil
//                    {
//                        recurrentOperations(cursor!)
//                    }
//                    else
//                    {
//                        result( records, nil)
//                    }
//                }
//            }
//            publicDatabase.add(recurrentOperation)
//        }
//        
//        // initial operation
//        let initialOperation = CKQueryOperation(query: cloudKitQuery)
//        initialOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
//            records.append(record)
//
//            let gasStationName = record.object(forKey: "Name") as! String
//            let gasStations = GasStation(name: gasStationName)
//            self.activityIndicatorView.stopAnimating()
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//            self.gasStationsArray.append(gasStations)
//            self.gasStationsArray.sort{
//                $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
//            }
//            DispatchQueue.main.async{
//                self.tableView.reloadData()
//            }
//            
//        }
//        initialOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error: Error?) -> Void in
//            if ((error) != nil)
//            {
//                result(nil, error as NSError?)
//            }
//            else
//            {
//                if cursor != nil
//                {
//                    recurrentOperations(cursor!)
//                }
//                else
//                {
//                    result(records, nil)
//                }
//            }
//        }
//        publicDatabase.add(initialOperation)
//    }
//    
//    func getData() { //https://www.reddit.com/r/swift/comments/2txhvb/fetching_record_data_in_cloudkit/
//        cloudKitLoadRecords() { (queryObjects, error) -> Void in
//            DispatchQueue.main.async {
//                if error != nil
//                {
//                    // handle error
//                }
//                else
//                {
//                    // clean objects array if you need to
//                    
//                    self.data.removeAll()
//                    
//                    self.activityIndicatorView.stopAnimating()
//                    if queryObjects!.count == 0
//                    {
//                        // do nothing
//                    }
//                    else
//                    {
//                        refreshControl!.endRefreshing()
//                        return
//                        // attach found objects to your object array
//                    }
//                }
//            }
//        }
//    }
    
//    func retrieveData() {
//        self.gasStationsArray = [GasStation]()
//        for data in self.data {
//            let gasStationName = data.object(forKey: "Name") as! String
//            let gasStations = GasStation(name: gasStationName)
//            self.activityIndicatorView.stopAnimating()
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//            self.gasStationsArray.append(gasStations)
//            self.gasStationsArray.sort{
//                $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
//            }
//        }
//        self.tableView.reloadData()
//        refreshControl!.endRefreshing()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return gasStationsArray.count
        }
        print(gasStationsArray.count)
        return gasStationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            print("here2")
            self.activityIndicatorView.stopAnimating()
            let cell = tableView.dequeueReusableCell(withIdentifier: "GasStationCell", for: indexPath) as! GasStationCell
            
            let gasStation: GasStation
            if searchController.isActive && searchController.searchBar.text != "" {
                gasStation = filteredGasStations[(indexPath as NSIndexPath).row]
            } else {
                gasStation = gasStationsArray[(indexPath as NSIndexPath).row]
                
            }
            
            cell.gasStation = gasStation
            return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Text") {
        filteredGasStations = gasStationsArray.filter({ (shop) -> Bool in
            return (shop.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedCell = filteredGasStations[(indexPath as NSIndexPath).row].name!
        } else {
            selectedCell = gasStationsArray[(indexPath as NSIndexPath).row].name!
        }
        
        performSegue(withIdentifier: "toSelectedGasStationMap", sender: self)
    }
    
    @IBAction func allGasStationssMapButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "toAllGasStationsMap", sender: self)
    }
    
    @IBAction func unwindToGasStationTable(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectedGasStationMap"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! GasStationViewController
            targetController.gasStationSelected = selectedCell
        }
        
        if segue.identifier == "toAllGasStationsMap"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AllGasStationsViewController
            targetController.allGasStationsArray = gasStationsArray
        }
    }
    
}

extension GasStationsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
