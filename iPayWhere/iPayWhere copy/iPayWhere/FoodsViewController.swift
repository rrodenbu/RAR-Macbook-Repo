//
//  FoodsViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/4/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import CloudKit
import GoogleMobileAds

class FoodsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate {
    
    weak var activityIndicatorView: UIActivityIndicatorView! //https://dzone.com/articles/displaying-an-activity-indicator-while-loading-tab
    
    @IBOutlet var tableView: UITableView!
    
    var foodsArray = [Food]()
    var filteredFoods = [Food]()
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
        refreshControl!.addTarget(self, action: #selector(FoodsViewController.refresh(_:)), for: UIControlEvents.valueChanged)
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
        let query = CKQuery(recordType: "Restaurants", predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Name", "Photo"]
        operation.resultsLimit = 5000;
        
        var newFoods = [Food]()
        operation.recordFetchedBlock = { record in
            print("fetching")
            var foodImage = UIImage(named:"nothing")
            if record["Photo"] != nil {
                let imageAsset = record["Photo"] as? CKAsset
                let imageData = NSData(contentsOf: imageAsset!.fileURL)
                foodImage = UIImage(data: imageData as! Data)
            }
            
            let foodName = record.object(forKey: "Name") as? String
            
            let food = Food(name: foodName, image: foodImage)
            
            if record["Photo"] != nil {
                newFoods.insert(food, at: 0)
            } else {
                newFoods.append(food)
            }
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.foodsArray = newFoods
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    self.tableView.reloadData()
                } else {
                    let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of shops; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
            self.activityIndicatorView.stopAnimating()
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }

    
//    func cloudKitLoadRecords(_ result: @escaping (_ objects: [CKRecord]?, _ error: NSError?) -> Void){
//        
//        // predicate
//        var predicate = NSPredicate(value: true)
//        
//        // query
//        let cloudKitQuery = CKQuery(recordType: "Restaurants", predicate: predicate)
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
//                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
//                print(record)
//                records.append(record)
//            }
//            recurrentOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error: Error?) -> Void in
//                if ((error) != nil)
//                {
//                    result( nil, error as NSError?)
//                }
//                else
//                {
//                    if cursor != nil
//                    {
//                        recurrentOperations(cursor!)
//                    }
//                    else
//                    {
//                        result(records, nil)
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
//        
//        cloudKitLoadRecords() { (queryObjects, error) -> Void in
//            DispatchQueue.main.async {
//                if error != nil
//                {
//                    // handle error
//                }
//                else
//                {
//                    // clean objects array if you need to
//                    self.data.removeAll()
//                    
//                    if queryObjects!.count == 0
//                    {
//                        // do nothing
//                    }
//                    else
//                    {
//                        // attach found objects to your object array
//                        self.data = queryObjects!
//                        self.retrieveData()
//                    }
//                }
//            }
//        }
//    }
//    
//    func retrieveData() {
//        self.foodsArray = [Food]()
//        for data in self.data {
//            let foodName = data.object(forKey: "Name") as! String
//            let food = Food(name: foodName)
//            self.activityIndicatorView.stopAnimating()
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//            self.foodsArray.append(food)
//            self.foodsArray.sort{
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
            return filteredFoods.count
        }
        print(foodsArray.count)
        return foodsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
            
            let food: Food
            if searchController.isActive && searchController.searchBar.text != "" {
                food = filteredFoods[(indexPath as NSIndexPath).row]
            } else {
                food = foodsArray[(indexPath as NSIndexPath).row]
            }
            
            cell.food = food
            return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Text") {
        filteredFoods = foodsArray.filter({ (shop) -> Bool in
            return (shop.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedCell = filteredFoods[(indexPath as NSIndexPath).row].name!
        } else {
            selectedCell = foodsArray[(indexPath as NSIndexPath).row].name!
        }
        
        performSegue(withIdentifier: "toSelectedFoodMap", sender: self)
    }
    
    @IBAction func allFoodsMapButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "toAllFoodsMap", sender: self)
    }
    
    @IBAction func unwindToFoodTable(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectedFoodMap"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! FoodViewController
            targetController.foodSelected = selectedCell
        }
        
        if segue.identifier == "toAllFoodsMap"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AllFoodsViewController
            targetController.allFoodsArray = foodsArray
        }
    }
    
}

extension FoodsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


