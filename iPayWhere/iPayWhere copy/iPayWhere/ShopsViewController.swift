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
import Social

class ShopsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate {
    
    weak var activityIndicatorView: UIActivityIndicatorView! //https://dzone.com/articles/displaying-an-activity-indicator-while-loading-tab
    
    @IBOutlet var tableView: UITableView!
    
    var shopsArray = [Shop]()
    var filteredShops = [Shop]()
    var data = [CKRecord]()
    
    let container = CKContainer.default()
    var publicDatabase: CKDatabase?
    var currentRecord: CKRecord?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedCell = ""
    
    @IBOutlet var bannerView: GADBannerView!
    
    func isICloudContainerAvailable()->Bool {
        let currentToken = FileManager.default.ubiquityIdentityToken
        if(currentToken != nil){
            return true
        }
        else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rate my app
        rateMe()
        
        // Social Media Call Out
        tweetMe()
        
        if(isICloudContainerAvailable() == false) {
            let alert = UIAlertView()
            alert.message = "Please sign into iCloud in your Settings."
            alert.addButton(withTitle: "OK")
            alert.show()
        }
        loadTable()
        
        
        //Logo
        //let image = UIImage(named: "Icon-App-29x29")
        //navigationItem.titleView = UIImageView(image: image)
        
        // Loading icon
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
        //loadTable()
        
        
        // Initialize the pull to refresh control.
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl!.addTarget(self, action: #selector(ShopsViewController.refresh(_:)), for: UIControlEvents.valueChanged)
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
        let query = CKQuery(recordType: "Stores", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Name", "Photo"]
        operation.resultsLimit = 5000;
        
        var newShops = [Shop]()
        operation.recordFetchedBlock = { record in
    
            var shopImage = UIImage(named:"nothing")
            if record["Photo"] != nil {
                let imageAsset = record["Photo"] as? CKAsset
                let imageData = NSData(contentsOf: imageAsset!.fileURL)
                shopImage = UIImage(data: imageData as! Data)
            }
            
            let shopName = record.object(forKey: "Name") as? String
            
            let shop = Shop(name: shopName, image: shopImage)
            
            if record["Photo"] != nil {
                newShops.insert(shop, at: 0)
            } else {
                newShops.append(shop)
            }
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.shopsArray = newShops
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
//        let cloudKitQuery = CKQuery(recordType: "Stores", predicate: predicate)
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
//                    print("retrieving data error")
//                    // handle error
//                }
//                else
//                {
//                    // clean objects array if you need to
//                    
//                    self.data.removeAll()
//                    
//                    
//                    if queryObjects!.count == 0
//                    {
//                        print("not objects to query")
//                        // do nothing
//                    }
//                    else
//                    {
//                        // attach found objects to your object array
//                        print("found objects")
//                        self.data = queryObjects!
//                        self.retrieveData()
//                    }
//                }
//            }
//        }
//    }
//    
//    func retrieveData() {
//        print("retrieve data")
//        self.shopsArray = [Shop]()
//        for data in self.data {
//            let shopName = data.object(forKey: "Name") as! String
//            let shop = Shop(name: shopName)
//            self.activityIndicatorView.stopAnimating()
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//            self.shopsArray.append(shop)
//            self.shopsArray.sort{
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
            return filteredShops.count
        }
        //print(shopsArray.count)
        return shopsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopCell
            
            let shop: Shop
            if searchController.isActive && searchController.searchBar.text != "" {
                shop = filteredShops[(indexPath as NSIndexPath).row]
            } else {
                shop = shopsArray[(indexPath as NSIndexPath).row]
            }
            
            cell.shop = shop
            return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Text") {
        filteredShops = shopsArray.filter({ (shop) -> Bool in
            return (shop.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedCell = filteredShops[(indexPath as NSIndexPath).row].name!
        } else {
            selectedCell = shopsArray[(indexPath as NSIndexPath).row].name!
        }
        
        performSegue(withIdentifier: "toSelectedShopMap", sender: self)
    }
    
    @IBAction func allShopsMapButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "toAllShopsMap", sender: self)
    }
    
    @IBAction func unwindToShopTable(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectedShopMap"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! ShopViewController
            targetController.shopSelected = selectedCell
        }
        
        if segue.identifier == "toAllShopsMap"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AllShopsViewController
            targetController.allShopsArray = shopsArray
        }
    }
    

    
    
    /*
     Functions for rating the app alert
     */
    
    var iMinSessions = 1
    var iTryAgainSessions = 3
    
    func rateMe() {
        let neverRate = UserDefaults.standard.bool(forKey: "neverRate")
        let numLaunches = UserDefaults.standard.integer(forKey: "numLaunches") + 1
//        print("NUMBER OF LAUNCHES:")
//        print(numLaunches)
        
        if (!neverRate && (numLaunches == 3 || numLaunches == 5 || numLaunches == 9))
        {
            showRateMe()
        }
        else if (numLaunches > 9) {
            UserDefaults.standard.set(true, forKey: "neverRate")
        }
        UserDefaults.standard.set(numLaunches, forKey: "numLaunches")
    }
    
    func rateApp(){
        let appID = "1153347253"
        let link:String = "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        UIApplication.shared.openURL(URL(string : link)!)
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: "Rate Me.", message: "Help spread Apple Pay. Give me suggestions.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Rate", style: UIAlertActionStyle.default, handler: { alertAction in
            UserDefaults.standard.set(true, forKey: "neverRate")
            //UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id959379869")!)
            //UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=<\(appID)>")!)
            let appID = "1153347253" // Your AppID
           //itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=<\(appID)
            print("want to rate")
            //UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!);
            /*if let checkURL = NSURL(string: "itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1153347253&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software") {
                if UIApplication.shared.openURL(checkURL) {
                    print("url successfully opened")
                }
                print("broken")
            }*/
            self.rateApp()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        //alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
        //    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
        //    alert.dismissViewControllerAnimated(true, completion: nil)
        //}))
        
        alert.addAction(UIAlertAction(title: "I won't help.", style: UIAlertActionStyle.default, handler: { alertAction in
            OperationQueue.main.addOperation({
                alert.dismiss(animated: true, completion: nil)
            })
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*
     Functions for tweeting the apps
     */
    
    func tweetMe() {
        let neverTweet = UserDefaults.standard.bool(forKey: "neverTweet")
        let numLaunches = UserDefaults.standard.integer(forKey: "numLaunches")
        
        if ((numLaunches == 4 || numLaunches == 6) && !neverTweet)
        {
            showTweetMe()
        }
        else if (numLaunches > 6) {
            UserDefaults.standard.set(true, forKey: "neverTweet")
        }
    }
    
    func showTweetMe() {
        UserDefaults.standard.set(true, forKey: "neverTweet")
        let optionMenu = UIAlertController(title: "Socialize.", message: "Help your friends start using Apple Pay.", preferredStyle: .actionSheet)
        
        let tweetAction = UIAlertAction(title: "Tweet.", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {

                let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)

                tweetSheet?.setInitialText("Find places that accept Apple Pay @iPayWhere! 🤑 #ApplePayFinder #iPayWhere")
                
                self.present(tweetSheet!, animated: true, completion: nil)
            } else {
                let alert = UIAlertView()
                alert.message = "Login to Twitter account in Settings."
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            

        })
        let facebookAction = UIAlertAction(title: "Facebook.", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in

            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposer?.setInitialText("Find places that accept Apple Pay with @iPayWere! 🤑 #ApplePayFinder #iPayWhere")
                
                self.present(facebookComposer!, animated: true, completion: nil)
            }else {
                let alert = UIAlertView()
                alert.message = "Login to Facebook account in Settings."
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "I won't help.", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(tweetAction)
        optionMenu.addAction(facebookAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }

}

extension ShopsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

