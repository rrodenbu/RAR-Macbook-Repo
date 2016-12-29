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
    var arrayCount = 30
    var allRetrieved = false
    var allRetrieved2 = false
    var allRetrieved3 = false
    var allRetrieved4 = false
    var allRetrieved5 = false
    var allRetrieved6 = false
    var allRetrieved7 = false
    var allRetrieved8 = false
    var allRetrieved9 = false
    var allRetrieved10 = false
    var allRetrieved11 = false
    
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
        //tableView.addSubview(bannerView)
        
        // Retrieve Data
        publicDatabase = container.publicCloudDatabase
        
        loadTable()
//        // Initialize the pull to refresh control.
//        refreshControl = UIRefreshControl()
//        refreshControl?.backgroundColor = UIColor.white
//        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl!.addTarget(self, action: #selector(BanksViewController.refresh(_:)), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refreshControl)
        
        // Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height);

    }
    
//    func refresh(_ sender:AnyObject) {
////        loadTable()
//        if refreshControl.isRefreshing
//        {
//            refreshControl.endRefreshing()
//        }
//    }
    
    func loadTable() {
        print("loading table")
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "Name", ascending: true)
        let query = CKQuery(recordType: "Banks", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Name", "Photo"]
        operation.resultsLimit = arrayCount;
        
        var newBanks = [Bank]()
        operation.recordFetchedBlock = { record in
            print("inside fetching")
            var bankImage = UIImage(named:"nothing")
            if record["Photo"] != nil {
                let imageAsset = record["Photo"] as? CKAsset
                let imageData = NSData(contentsOf: imageAsset!.fileURL)
                bankImage = UIImage(data: imageData as! Data)
            }
            
            let bankName = record.object(forKey: "Name") as? String
            
            let bank = Bank(name: bankName, image: bankImage)
            
            if record["Photo"] != nil {
                newBanks.insert(bank, at: 0)
            } else {
                newBanks.append(bank)
                self.banksArray.append(bank)
            }
        }
        print("here")
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            print("adding to table")
            DispatchQueue.main.async {
                print("async")
                if error == nil {
                    self.banksArray = newBanks
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    self.tableView.reloadData()
                } else {
                    let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of banks; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
                print("here why?")
            }
            self.activityIndicatorView.stopAnimating()
            print("done loading data 2")
        }
        print("done loading data")
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
//    func cloudKitLoadRecords(_ result: @escaping (_ objects: [CKRecord]?, _ error: NSError?) -> Void){
//        
//        // predicate
//        var predicate = NSPredicate(value: true)
//        
//        // query
//        let cloudKitQuery = CKQuery(recordType: "Banks", predicate: predicate)
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
//                records.append(record)
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
//        self.banksArray = [Bank]()
//        for data in self.data {
//            let bankName = data.object(forKey: "Name") as! String
//            let bank = Bank(name: bankName)
//            self.activityIndicatorView.stopAnimating()
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//            self.banksArray.append(bank)
//            self.banksArray.sort{
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
            return filteredBanks.count
        }
        return banksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            print(indexPath[1])
            if(indexPath[1] == 1 && allRetrieved == false) {
                print("LOADING MORE1")
                arrayCount += 100
                allRetrieved = true
                loadTable()
            }
            if(indexPath[1] == 4 && allRetrieved2 == false) {
                print("LOADING MORE2")
                arrayCount += 200
                allRetrieved2 = true
                loadTable()
            }
            if(indexPath[1] == 5 && allRetrieved3 == false) {
                print("LOADING MORE3")
                arrayCount += 100
                allRetrieved3 = true
                loadTable()
            }
            if(indexPath[1] == 6 && allRetrieved4 == false) {
                print("LOADING MORE4")
                arrayCount += 100
                allRetrieved4 = true
                loadTable()
            }
            if(indexPath[1] == 7 && allRetrieved5 == false) {
                print("LOADING MORE5")
                arrayCount += 100
                allRetrieved5 = true
                loadTable()
            }
            if(indexPath[1] == 8 && allRetrieved6 == false) {
                print("LOADING MORE6")
                arrayCount += 100
                allRetrieved6 = true
                loadTable()
            }
            if(indexPath[1] == 9 && allRetrieved7 == false) {
                print("LOADING MORE7")
                arrayCount += 200
                allRetrieved7 = true
                loadTable()
            }
            
            if(indexPath[1] == 10 && allRetrieved8 == false) {
                print("LOADING MORE8")
                arrayCount += 200
                allRetrieved8 = true
                loadTable()
            }
            if(indexPath[1] == 11 && allRetrieved9 == false) {
                print("LOADING MORE9")
                arrayCount += 200
                allRetrieved9 = true
                loadTable()
            }
            if(indexPath[1] == 12 && allRetrieved10 == false) {
                print("LOADING MORE9")
                arrayCount += 200
                allRetrieved10 = true
                loadTable()
            }
            if(indexPath[1] == 13 && allRetrieved11 == false) {
                print("LOADING MORE9")
                arrayCount += 300
                allRetrieved11 = true
                loadTable()
            }
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
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
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

