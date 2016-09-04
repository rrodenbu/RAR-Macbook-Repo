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
    
    func getData() { //https://www.reddit.com/r/swift/comments/2txhvb/fetching_record_data_in_cloudkit/
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Banks", predicate: predicate)
        
        publicDatabase?.performQuery(query, inZoneWithID: nil, completionHandler: ({results, error in
                                        
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue()) {
                    print("PROBLEMS, PROBLEMS, PROBLEMS")
                }
            } else {
                if results!.count > 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.data = results!
                        self.retrieveData()
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        print("NO MATCH")
                    }
                }
            }
        }))
    }
    
    func retrieveData() {
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
        
        performSegueWithIdentifier("toMapSegue", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMapSegue"{
            var DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! BankViewController
            targetController.bankSelected = selectedCell
        }
    }

}

extension BanksViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

