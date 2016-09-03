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
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    var banks:[Bank] = banksData
    var banksArray = [Bank]()
    var filteredBanks = [Bank]()
    
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve Data
        publicDatabase = container.publicCloudDatabase
        getData()
        
        // Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    func getData() { //https://www.reddit.com/r/swift/comments/2txhvb/fetching_record_data_in_cloudkit/
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Banks", predicate: predicate)
        print("QUEUERY")
        print(query)
        publicDatabase?.performQuery(query, inZoneWithID: nil, completionHandler: ({results, error in
                                        
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue()) {
                    print("PROBLEMS, PROBLEMS, PROBLEMS")
                }
            } else {
                if results!.count > 0 {
                    
                    for data in results! {
                        let bankName = data.objectForKey("Name") as! String
                        print(bankName)
                        let bank = Bank(name: bankName)
                        self.banksArray.append(bank)
                    }
                    self.tableView.reloadData()
                    var record = results![0] as CKRecord
                    self.currentRecord = record
                                                
                    dispatch_async(dispatch_get_main_queue()) {
                        let name = record.objectForKey("Name") as! String
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        print("NO MATCH")
                    }
                }
            }
        }))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBanks.count
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BanksViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

