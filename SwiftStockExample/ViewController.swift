//
//  ViewController.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/16.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.
//

import UIKit
import CoreData
import SwiftGifOrigin
import DZNEmptyDataSet

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    //core data var
    var managedObjectContext : NSManagedObjectContext!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var scrollView : UIScrollView!
    var searchResults: [StockSearchResult] = []
    var subViews : [UIView] = []
    var stockArray: [Stock] = []
    var symbolArray : [String] = ["BAC","FB","AAPL","MSFT","GE","TWTR"]
    var stock : Stock!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpInterface()
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView() 
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib(nibName: "StockCell", bundle: Bundle.main), forCellReuseIdentifier: "stockCell")
        tableView.rowHeight = 60
        searchBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stockArray.removeAll(keepingCapacity: false)
        fetchSymbolYahooFinanceWithString(symbolArray, completion: {
            (stockArray) in
            
            
        })

    }
    
    func setUpInterface(){
        
        self.view.backgroundColor = .clear
       
        
        self.tableView.separatorColor = ColorSheet().orangeBloomberg
        self.searchBar.backgroundColor = UIColor.black
        self.searchBar.tintColor = ColorSheet().stockGreen
        self.searchBar.barStyle = .black
        self.searchBar.placeholder = "search using stock symbol"
        self.searchBar.layer.borderColor = ColorSheet().stockGreen.cgColor
        self.searchBar.layer.borderWidth = 2
        self.searchBar.layer.cornerRadius = 15
        
        let navTitleImageView = UIImageView(image: UIImage(named: "ExchangeIconMain"))
        self.navigationItem.titleView = navTitleImageView
        
        let BGImageGIF = UIImage.gif(name: "StockBoard3")
      
        let BGImageGIFImageView = UIImageView(image: BGImageGIF)
        BGImageGIFImageView.addBlurEffect()
        BGImageGIFImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(BGImageGIFImageView)
        self.view.sendSubview(toBack: BGImageGIFImageView)
    }
    //scroll Setup
    
    func setUpScrollView(){
        
       scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/8))
        scrollView.contentSize = CGSize(width: self.scrollView.bounds.width*3.5, height: self.scrollView.bounds.height)
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.blue
        scrollView.delegate = self
        scrollView.clipsToBounds = true
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        // add scroll- subs
        setUpScrollChild()
    }
    
    // sub scrolls setup
    func setUpScrollChild(){
        let labelSpace = 170
        let labelHeight: CGFloat = 50
        let labelWidth: CGFloat = 140
        let frameWidth = self.view.bounds.width
        let count = stockArray.count
        if  count != 0 {
        for i in 0...(self.stockArray.count - 1){
            
            let subView = UIView(frame: CGRect(x: (CGFloat(i * labelSpace) + frameWidth), y: 40.0, width: labelWidth, height:labelHeight))
            
            let subLabelHeight: CGFloat = 40
            let subLabelWidth: CGFloat = 60
            let stockComp = StockComponent.init(stock: stockArray[i])
            
            let symLabel = UILabel(frame: CGRect(x: 2 , y: 10, width: subLabelWidth, height: subLabelHeight))
            symLabel.text = stockComp?.symbol
            
            
            let trendImage = UIImageView(frame: CGRect(x: 55 , y: 20, width: subLabelWidth/4, height: subLabelHeight/3))
            trendImage.image = stockComp?.changeImage
            
            let priceLabel = UILabel(frame: CGRect(x: 80 , y: 10, width: subLabelWidth, height: subLabelHeight))
            priceLabel.text = stockComp?.price
            
            symLabel.textColor = UIColor.white
            priceLabel.textColor = UIColor.white
            
            subView.addSubview(priceLabel)
            subView.addSubview(symLabel)
            subView.addSubview(trendImage)
            
            subViews.insert(subView, at: i)
            self.scrollView.addSubview(subView)
        }
        } else {
            print("no stocks")
        }
    }
    
    
    // scrollview subViews animation
    
    func srollSubAnimation() {
        
        UIView.animate(withDuration: 10, delay: 1, options: [.repeat , .curveLinear], animations: {
            if self.stockArray.count != 0 {
                for i in 0...(self.stockArray.count - 1){
                    self.subViews[i].center.x = -1400 + self.subViews[i].center.x
                }
            } else {
                print("no stock to move")
            }
        }, completion: nil)
    }
   
    
    
  //all stock fetch method
    
    func searchYahooFinanceWithString(_ searchText: String) {
        
        SwiftStockKit.fetchStocksFromSearchTerm(term: searchText) { (stockInfoArray) -> () in
            
            self.searchResults = stockInfoArray
            self.tableView.reloadData()

            
        }
    
    }
    
    
    
    
    func fetchSymbolYahooFinanceWithString(_ symbolArray: [String], completion: @escaping ([Stock])->()) {
        DispatchQueue.global().async {
            for sym in symbolArray{
                
                SwiftStockKit.fetchStockForSymbol(symbol: sym, completion: {
                    stock -> () in
                    self.stock = stock
                    self.stockArray.append(self.stock)
                    
                })
                
               
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                print("--------")
                print(self.stockArray.count)
                
                completion(self.stockArray)
                self.setUpScrollView()
                self.srollSubAnimation()
                
            })
        }
        
       
        
        
        
    }
    
   

    
    
    
    // Search code
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let length = searchText.characters.count
        
        if length > 0 {
            searchYahooFinanceWithString(searchText)
        } else {
            searchResults.removeAll()
            tableView.reloadData()
        }
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        tableView.reloadData()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        tableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    
    //SearchBar stuff
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(_ sender: Notification) {
            let userInfo = sender.userInfo
            let keyboardHeight = (userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
            tableViewBottomConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            
        
    }
    
    func keyboardWillHide(_ sender: Notification) {
            let userInfo = sender.userInfo
            let _ = (userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
            tableViewBottomConstraint.constant = 0.0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            
        
    }
    
    
    //TableView stuff
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller: DetailViewController = storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        controller.companyName = searchResults[indexPath.row].name!
        controller.stockSymbol = searchResults[indexPath.row].symbol!
        navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: StockCell = tableView.dequeueReusableCell(withIdentifier: "stockCell") as! StockCell
        
            cell.assetType.textColor = ColorSheet().orangeBloomberg
            cell.symbolLbl.text = searchResults[indexPath.row].symbol
            cell.companyLbl.text = searchResults[indexPath.row].name
            let exchange = searchResults[indexPath.row].exchange!
            let assetType = searchResults[indexPath.row].assetType!
            cell.assetType.text = assetType
            cell.exchangeLbl.text = exchange
            cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    /// empty data func
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Search using stock symbol"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Click search result to see stock detail."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyStock")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Remember to click + button to add stock"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let ac = UIAlertController(title: "The \("+") button is in yellow ", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default))
        present(ac, animated: true)
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

