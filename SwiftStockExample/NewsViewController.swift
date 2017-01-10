//
//  NewsViewController.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/16.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.

//

import UIKit
import CoreData
import ExpandingMenu
import Alamofire
import SWXMLHash
import DZNEmptyDataSet
import ActiveLabel



class NewsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,AlertController,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    var symbol: String = String()
    var CDStocks : [NSManagedObject] = []
    var symbolArray : [String] = []
    var NewsArray : [News] = []
    
    var cellSelected :Bool!
    
    
    

    @IBOutlet weak var tableView: UITableView!
    var context: NSManagedObjectContext!

  
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         retrieveCDStock()
       
         }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "NEWS"
        setUpInterface()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        tableView.tableFooterView = UIView()
       
        context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedContext
       
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //interface
    func setUpInterface(){
        
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.layer.backgroundColor = UIColor.clear.cgColor
        self.tableView.separatorColor = ColorSheet().orangeBloomberg
        let BGImageGIF = UIImage(named: "StockWatch")
        
        let BGImageView = UIImageView(image: BGImageGIF)
        BGImageView.addBlurEffect()
        BGImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(BGImageView)
        self.view.sendSubview(toBack: BGImageView)
    }
    
    // basic tableview func
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.NewsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(NewsArray.count)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
       
             cell.title.text = NewsArray[indexPath.row].title
        if NewsArray[indexPath.row].description != ""
        {
        cell.desc.text = NewsArray[indexPath.row].description
        } else {
           
            cell.desc.text = NewsArray[indexPath.row].link

            
                   }
        
    
        cell.pubDate.text = NewsArray[indexPath.row].date
        
        cell.backgroundColor = UIColor.clear
        cell.title.textColor = ColorSheet().orangeBloomberg
        cell.desc.textColor = UIColor.white
        cell.pubDate.textColor = UIColor.white

        
        return cell
    }
  
       ////// Empty cell
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Your Customized News"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Search and add stock in stock tab first ."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyNews")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Then select the pick button to start"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Hurray", style: .default))
        present(ac, animated: true)
    }
    
   ///////
    
    var expandedCells = [Int]()
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
         let cell = tableView.cellForRow(at: indexPath) as! NewsCell
       
        if (expandedCells.contains(indexPath.row)) {
            expandedCells = expandedCells.filter({ $0 != indexPath.row})
            
            cell.arrowImg.image = UIImage(named: "Up Arrow")
            
        }
            // Otherwise, add the button to the array
        else {
            expandedCells.append(indexPath.row)
            cell.arrowImg.image = UIImage(named: "Down Arrow")
            

        }
        

        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedCells.contains(indexPath.row) {
            return 300
        } else {
            return 120
        }
    }
       ////////

    
    
    
    // retrieve data
    
    func retrieveCDStock (){
        
        self.symbolArray.removeAll(keepingCapacity: false)
        self.tableView.reloadData()
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<CDStock> = CDStock.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            DispatchQueue.global().async {
                for result in searchResults as [NSManagedObject] {
                    self.CDStocks.append(result)
                    self.symbolArray.append(result.value(forKey: "symbol") as! String)
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 , execute: {
                    print(self.symbolArray.count)
                    self.createExpandableMenu()
                })
            }
            
        } catch {
            showAlert(title: "Error", message: "Can't fetch data")
        }
        
    }
    
    // create expandable menu
    
    func createExpandableMenu(){
        
        var items : [ExpandingMenuItem] = []

        
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint(x:0,y:0), size: menuButtonSize), centerImage: UIImage(named: "menu")!, centerHighlightedImage: UIImage(named: "menu")!)
        menuButton.center = CGPoint(x:self.view.bounds.width - 32.0, y:self.view.bounds.height - 90)
        view.addSubview(menuButton)
        
        for sym in symbolArray {
        
        let item = ExpandingMenuItem(size: menuButtonSize, title: "\(sym)", image: UIImage(named: "item")!, highlightedImage: UIImage(named: "item")!, backgroundImage: UIImage(named: "item"), backgroundHighlightedImage: UIImage(named: "item")) { () -> Void in
            self.navigationItem.title = "\(sym)"
            
            
          
                let url = "http://finance.yahoo.com/rss/headline?s=\(sym)"
            SwiftStockKit.fetchNewsfromSymBol(url: url, completion: {
                newsArr in
                self.NewsArray.removeAll(keepingCapacity: false)
                self.tableView.reloadData()
                for news in newsArr{
                    
                    self.NewsArray.append(news)
                    if self.NewsArray.count > 0{
                        self.tableView.reloadData()
                    }

                    
                }
            })

           
        
        }
            item.titleColor = UIColor.orange
            items.append(item)
        
    }
        menuButton.addMenuItems(items)
        
        


        
    }

   
}
