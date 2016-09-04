//
//  BanksViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/1/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import CloudKit

class BanksViewController: UITableViewController, UISearchDisplayDelegate, UISearchBarDelegate {

    weak var activityIndicatorView: UIActivityIndicatorView! //https://dzone.com/articles/displaying-an-activity-indicator-while-loading-tab
    
    var banksArray = [Bank]()
    var filteredBanks = [Bank]()
    var data = [CKRecord]()
    
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedCell = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loading icon
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.activityIndicatorView = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        // Retrieve Data
        publicDatabase = container.publicCloudDatabase
        getData()
        
        // Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(searchController.searchBar.frame));
        
        // Initialize the pull to refresh control.
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.candyGreen()
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

    }
    /*
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (rows == nil) {
            activityIndicatorView.startAnimating()
            AppDelegate.operationQueue.addOperationWithBlock() {
                NSThread.sleepForTimeInterval(3)
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    self.activityIndicatorView.stopAnimating()
                    self.rows = ["One", "Two", "Three", "Four", "Five"]
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    self.tableView.reloadData()
                }
            }
        }
    }*/
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
                //print("-> cloudKitLoadRecords - recurrentOperations - fetch \(recurrentOperationsCounter++)")
                records.append(record)
            }
            recurrentOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error:NSError?) -> Void in
                if ((error) != nil)
                {
                    //print("-> cloudKitLoadRecords - recurrentOperations - error - \(error)")
                    result(objects: nil, error: error)
                }
                else
                {
                    if cursor != nil
                    {
                        //print("-> cloudKitLoadRecords - recurrentOperations - records \(records.count) - cursor \(cursor!.description)")
                        recurrentOperations(cursor!)
                    }
                    else
                    {
                        //print("-> cloudKitLoadRecords - recurrentOperations - records \(records.count) - cursor nil - done")
                        result(objects: records, error: nil)
                    }
                }
            }
            publicDatabase.addOperation(recurrentOperation)
        }
        
        // initial operation
        let initialOperation = CKQueryOperation(query: cloudKitQuery)
        initialOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
            //print("-> cloudKitLoadRecords - initialOperation - fetch \(initialOperationCounter++)")
            records.append(record)
        }
        initialOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error:NSError?) -> Void in
            if ((error) != nil)
            {
                //print("-> cloudKitLoadRecords - initialOperation - error - \(error)")
                result(objects: nil, error: error)
            }
            else
            {
                if cursor != nil
                {
                    //print("-> cloudKitLoadRecords - initialOperation - records \(records.count) - cursor \(cursor!.description)")
                    recurrentOperations(cursor!)
                }
                else
                {
                    //print("-> cloudKitLoadRecords - initialOperation - records \(records.count) - cursor nil - done")
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
        }
        self.tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBanks.count
        }
        print(banksArray.count)
        return banksArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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

