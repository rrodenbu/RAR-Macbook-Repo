//
//  ShopsViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/4/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import CloudKit
import GoogleMobileAds

class ShopsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate {
    
    weak var activityIndicatorView: UIActivityIndicatorView! //https://dzone.com/articles/displaying-an-activity-indicator-while-loading-tab
    
    @IBOutlet var tableView: UITableView!
    
    var shopsArray = [Shop]()
    var filteredShops = [Shop]()
    var data = [CKRecord]()
    
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedCell = ""
    
    @IBOutlet var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rate my app
        print("rateme call")
        rateMe()
        
        //Logo
        //let image = UIImage(named: "Icon-App-29x29")
        //navigationItem.titleView = UIImageView(image: image)
        
        // Loading icon
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
        let cloudKitQuery = CKQuery(recordType: "Stores", predicate: predicate)
        
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
        self.shopsArray = [Shop]()
        for data in self.data {
            let shopName = data.objectForKey("Name") as! String
            let shop = Shop(name: shopName)
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.shopsArray.append(shop)
            self.shopsArray.sortInPlace{
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
            return filteredShops.count
        }
        //print(shopsArray.count)
        return shopsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ShopCell", forIndexPath: indexPath) as! ShopCell
            
            let shop: Shop
            if searchController.active && searchController.searchBar.text != "" {
                shop = filteredShops[indexPath.row]
            } else {
                shop = shopsArray[indexPath.row]
            }
            
            cell.shop = shop
            return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "Text") {
        filteredShops = shopsArray.filter({ (shop) -> Bool in
            return (shop.name?.lowercaseString.containsString(searchText.lowercaseString))!
        })
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchController.active && searchController.searchBar.text != "" {
            selectedCell = filteredShops[indexPath.row].name!
        } else {
            selectedCell = shopsArray[indexPath.row].name!
        }
        
        performSegueWithIdentifier("toSelectedShopMap", sender: self)
    }
    
    @IBAction func allShopsMapButton(sender: AnyObject) {
        performSegueWithIdentifier("toAllShopsMap", sender: self)
    }
    
    @IBAction func unwindToShopTable(segue: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSelectedShopMap"{
            let DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! ShopViewController
            targetController.shopSelected = selectedCell
        }
        
        if segue.identifier == "toAllShopsMap"{
            let DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! AllShopsViewController
            targetController.allShopsArray = shopsArray
        }
    }
    
    /*
     Functions for rating the app alert
     */
    
    var iMinSessions = 3
    var iTryAgainSessions = 6
    
    func rateMe() {
        let neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
        var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
        print(numLaunches)
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: "Rate Me", message: "I am a one-man-team developer, all reviews help. I'll do my best to implement your suggestions.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Rate iPay Where", style: UIAlertActionStyle.Default, handler: { alertAction in
            UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=<1153347253>")!)
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

extension ShopsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

