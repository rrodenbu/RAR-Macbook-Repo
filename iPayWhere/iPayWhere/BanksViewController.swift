//
//  BanksViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/1/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import CloudKit
import GoogleMobileAds

var refreshControl: UIRefreshControl!

class BanksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate {

    weak var activityIndicatorView: UIActivityIndicatorView! //https://dzone.com/articles/displaying-an-activity-indicator-while-loading-tab
    @IBOutlet var tableView: UITableView!
    
    var banksArray = [Bank]()
    var filteredBanks = [Bank]()
    var data = [CKRecord]()
    
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedCell = ""
    
    @IBOutlet var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loading icon
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.activityIndicatorView = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        //Loading advertisement
        self.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.bannerView.rootViewController = self
        var request: GADRequest = GADRequest()
        self.bannerView.loadRequest(request)
        tableView.addSubview(bannerView)
        
        // Retrieve Data
        publicDatabase = container.publicCloudDatabase
        getData()
        
        // Initialize the pull to refresh control.
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(BanksViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        // Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(searchController.searchBar.frame));

    }
    
    func refresh(sender:AnyObject) {
        getData()
    }
    
    func cloudKitLoadRecords(result: (objects: [CKRecord]?, error: NSError?) -> Void){
        
        // predicate
        var predicate = NSPredicate(value: true)
        
        // query
        let cloudKitQuery = CKQuery(recordType: "Banks", predicate: predicate)
        
        // records to store
        var records = [CKRecord]()
        
        //operation basis
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        // recurrent operations function
        var recurrentOperationsCounter = 101
        func recurrentOperations(cursor: CKQueryCursor?){
            let recurrentOperation = CKQueryOperation(cursor: cursor!)
            recurrentOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
                records.append(record)
            }
            recurrentOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error:NSError?) -> Void in
                if ((error) != nil)
                {
                    result(objects: nil, error: error)
                }
                else
                {
                    if cursor != nil
                    {
                        recurrentOperations(cursor!)
                    }
                    else
                    {
                        result(objects: records, error: nil)
                    }
                }
            }
            publicDatabase.addOperation(recurrentOperation)
        }
        
        // initial operation
        let initialOperation = CKQueryOperation(query: cloudKitQuery)
        initialOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
            records.append(record)
        }
        initialOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error:NSError?) -> Void in
            if ((error) != nil)
            {
                result(objects: nil, error: error)
            }
            else
            {
                if cursor != nil
                {
                    recurrentOperations(cursor!)
                }
                else
                {
                    result(objects: records, error: nil)
                }
            }
        }
        publicDatabase.addOperation(initialOperation)
    }
    
    func getData() { //https://www.reddit.com/r/swift/comments/2txhvb/fetching_record_data_in_cloudkit/
        
        cloudKitLoadRecords() { (queryObjects, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil
                {
                    // handle error
                }
                else
                {
                    // clean objects array if you need to
                    self.data.removeAll()
                    
                    if queryObjects!.count == 0
                    {
                        // do nothing
                    }
                    else
                    {
                        // attach found objects to your object array
                        self.data = queryObjects!
                        self.retrieveData()
                    }
                }
            }
        }
    }
    
    func retrieveData() {
        self.banksArray = [Bank]()
        for data in self.data {
            let bankName = data.objectForKey("Name") as! String
            let bank = Bank(name: bankName)
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.banksArray.append(bank)
            self.banksArray.sortInPlace{
                $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending
            }
        }
        self.tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 32
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBanks.count
        }
        print(banksArray.count)
        return banksArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("BankCell", forIndexPath: indexPath) as! BankCell
            
            let bank: Bank
            if searchController.active && searchController.searchBar.text != "" {
                bank = filteredBanks[indexPath.row]
            } else {
                bank = banksArray[indexPath.row]
            }
            
            cell.bank = bank
            return cell
    }

    func filterContentForSearchText(searchText: String, scope: String = "Text") {
        filteredBanks = banksArray.filter({ (bank) -> Bool in
            return (bank.name?.lowercaseString.containsString(searchText.lowercaseString))!
        })
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchController.active && searchController.searchBar.text != "" {
            selectedCell = filteredBanks[indexPath.row].name!
        } else {
            selectedCell = banksArray[indexPath.row].name!
        }
        
        performSegueWithIdentifier("toSelectedBankMap", sender: self)
    }

    @IBAction func allBanksMapButton(sender: AnyObject) {
        performSegueWithIdentifier("toAllBanksMap", sender: self)
    }
    
    @IBAction func unwindToBankTable(segue: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSelectedBankMap"{
            let DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! BankViewController
            targetController.bankSelected = selectedCell
        }
        
        if segue.identifier == "toAllBanksMap"{
            let DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! AllBanksViewController
            targetController.allBanksArray = banksArray
        }
    }

}

extension BanksViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

