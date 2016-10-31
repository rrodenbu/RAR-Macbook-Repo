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
        self.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.bannerView.rootViewController = self
        let request: GADRequest = GADRequest()
        self.bannerView.load(request)
        tableView.addSubview(bannerView)
        
        // Retrieve Data
        publicDatabase = container.publicCloudDatabase
        getData()
        
        // Initialize the pull to refresh control.
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.neonYellow()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(BanksViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        // Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height);

    }
    
    func refresh(_ sender:AnyObject) {
        getData()
    }
    
    func cloudKitLoadRecords(_ result: @escaping (_ objects: [CKRecord]?, _ error: NSError?) -> Void){
        
        // predicate
        var predicate = NSPredicate(value: true)
        
        // query
        let cloudKitQuery = CKQuery(recordType: "Banks", predicate: predicate)
        
        // records to store
        var records = [CKRecord]()
        
        //operation basis
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        // recurrent operations function
        var recurrentOperationsCounter = 101
        func recurrentOperations(_ cursor: CKQueryCursor?){
            let recurrentOperation = CKQueryOperation(cursor: cursor!)
            recurrentOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
                records.append(record)
            }
            recurrentOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error: Error?) -> Void in
                if ((error) != nil)
                {
                    result(nil, error as NSError?)
                }
                else
                {
                    if cursor != nil
                    {
                        recurrentOperations(cursor!)
                    }
                    else
                    {
                        result(records, nil)
                    }
                }
            }
            publicDatabase.add(recurrentOperation)
        }
        
        // initial operation
        let initialOperation = CKQueryOperation(query: cloudKitQuery)
        initialOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
            records.append(record)
        }
        initialOperation.queryCompletionBlock = { (cursor:CKQueryCursor?, error: Error?) -> Void in
            if ((error) != nil)
            {
                result(nil, error as NSError?)
            }
            else
            {
                if cursor != nil
                {
                    recurrentOperations(cursor!)
                }
                else
                {
                    result(records, nil)
                }
            }
        }
        publicDatabase.add(initialOperation)
    }
    
    func getData() { //https://www.reddit.com/r/swift/comments/2txhvb/fetching_record_data_in_cloudkit/
        
        cloudKitLoadRecords() { (queryObjects, error) -> Void in
            DispatchQueue.main.async {
                if error != nil
                {
                    print("ERROROROOROOROROROOR")
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
            let bankName = data.object(forKey: "Name") as! String
            let bank = Bank(name: bankName)
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.banksArray.append(bank)
            self.banksArray.sort{
                $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
            }
        }
        self.tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
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
            return filteredBanks.count
        }
        print(banksArray.count)
        return banksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell", for: indexPath) as! BankCell
            
            let bank: Bank
            if searchController.isActive && searchController.searchBar.text != "" {
                bank = filteredBanks[(indexPath as NSIndexPath).row]
            } else {
                bank = banksArray[(indexPath as NSIndexPath).row]
            }
            
            cell.bank = bank
            return cell
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "Text") {
        filteredBanks = banksArray.filter({ (bank) -> Bool in
            return (bank.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedCell = filteredBanks[(indexPath as NSIndexPath).row].name!
        } else {
            selectedCell = banksArray[(indexPath as NSIndexPath).row].name!
        }
        
        performSegue(withIdentifier: "toSelectedBankMap", sender: self)
    }

    @IBAction func allBanksMapButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "toAllBanksMap", sender: self)
    }
    
    @IBAction func unwindToBankTable(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectedBankMap"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! BankViewController
            targetController.bankSelected = selectedCell
        }
        
        if segue.identifier == "toAllBanksMap"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AllBanksViewController
            targetController.allBanksArray = banksArray
        }
    }

}

extension BanksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

