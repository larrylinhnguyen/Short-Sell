//
//  DetailViewController.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/116.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.
//

import UIKit
import CoreData


class DetailViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ChartViewDelegate, AlertController {

    @IBOutlet weak var collectionView: UICollectionView!
    var companyName: String = String()
    var stockSymbol: String = String()
    var stock: Stock?
    var chartView: ChartView!
    var chart: SwiftStockChart!
    var CDStocks : [NSManagedObject] = []
    var stockArray :[Stock] = []
    var symbolArray : [String] = []
   
    
    var context : NSManagedObjectContext!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        context = (UIApplication.shared.delegate  as! AppDelegate).coreDataStack.managedContext
        navigationItem.title = companyName
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "StockDataCell", bundle: Bundle.main), forCellWithReuseIdentifier: "stockDataCell")
        automaticallyAdjustsScrollViewInsets = false
        
        chartView = ChartView.create()
        chartView.delegate = self
       
        chartView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(chartView)
        
        collectionView.addConstraint(NSLayoutConstraint(item: chartView, attribute: .height, relatedBy: .equal, toItem:collectionView, attribute: .height, multiplier: 1.0, constant: -(collectionView.bounds.size.height - 230)))
        collectionView.addConstraint(NSLayoutConstraint(item: chartView, attribute: .width, relatedBy: .equal, toItem:collectionView, attribute: .width, multiplier: 1.0, constant: 0))
        collectionView.addConstraint(NSLayoutConstraint(item: chartView, attribute: .top, relatedBy: .equal, toItem:collectionView, attribute: .top, multiplier: 1.0, constant: -250))
        collectionView.addConstraint(NSLayoutConstraint(item: chartView, attribute: .left, relatedBy: .equal, toItem:collectionView, attribute: .left, multiplier: 1.0, constant: 0))
        collectionView.contentInset = UIEdgeInsetsMake(250, 0, 0, 0)

        
        chart = SwiftStockChart(frame: CGRect(x: 10, y: 10, width: chartView.frame.size.width - 20, height: chartView.frame.size.height*3/5))
        chart.fillColor = UIColor.clear
        chart.verticalGridStep = 3
        chartView.addSubview(chart)
        self.chartView.sendSubview(toBack: chart)
        
              loadChartWithRange(range: .oneDay)

        
        let addButton = UIButton(frame: CGRect(x: self.view.bounds.maxX - 60, y: 20, width: 60, height: 60))
        addButton.setImage(UIImage(named:"Add"), for: .normal)
        addButton.contentMode = .scaleToFill
        
        addButton.addTarget(self, action: #selector(watch), for: .touchUpInside)
        chartView.addSubview(addButton)
        
       
        
        // *** Here's the important bit *** //
        SwiftStockKit.fetchStockForSymbol(symbol: stockSymbol) { (stock) -> () in
            self.stock = stock
            self.collectionView.reloadData()
         
        }

  setUpInterface()
            }
    
    // Interface
    
    func setUpInterface(){
        
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor.clear
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        
        self.collectionView.backgroundColor = UIColor.clear
      
        let BGImageGIF = UIImage(named: "StockWatch")
        
        let BGImageView = UIImageView(image: BGImageGIF)
        BGImageView.addBlurEffect()
        BGImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(BGImageView)
        self.view.sendSubview(toBack: BGImageView)
    }

    
 
    
    // *** ChartView stuff *** //
    
    func loadChartWithRange(range: ChartTimeRange) {
    
        chart.timeRange = range
        
        let times = chart.timeLabelsForTimeFrame(range)
        chart.horizontalGridStep = times.count - 1
        
        chart.labelForIndex = {(index: NSInteger) -> String in
            return times[index]
        }
        chart.labelForValue = {(value: CGFloat) -> String in
            return String(format: "%.02f", value)
        }
        
                // *** Here's the important bit *** //
        SwiftStockKit.fetchChartPoints(symbol: stockSymbol, range: range) { (chartPoints) -> () in
            self.chart.clearChartData()
            self.chart.setChartPoints(points: chartPoints)
        }
    
    }
    
    func didChangeTimeRange(range: ChartTimeRange) {
        loadChartWithRange(range: range)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  stock != nil ? 18 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 17 ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockDataCell", for: indexPath) as! StockDataCell
        cell.setData(stock!.dataFields[((indexPath as NSIndexPath).section * 2) + (indexPath as NSIndexPath).row])
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (UIScreen.main.bounds.size.width/2), height: 44)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // additional funcs
    
    func watch (sender : UIButton){
        retrieveCDStock()
        if  self.stock != nil{
        saveCDStock(stock: self.stock!)
        } else {
            showAlert(title: "Error", message: " This asset is unavailable for sale")
        }
        
    }
    
    // Store stock into coredata func
    
    func saveCDStock(stock: Stock) {
        
       
        
        if symbolArray.contains(stock.symbol!) == false {
        let stockEntity = NSEntityDescription.entity(forEntityName: "CDStock", in: context)
        
        let stockEntry = NSManagedObject(entity: stockEntity!, insertInto: context)
        
    
        stockEntry.setValue(stock.symbol, forKey: "symbol")
        
        do {
            try context.save()
            
            showAlert(title: "Stock Added", message: "This stock is now on watchlist")
            self.symbolArray.removeAll()
            
        } catch let error as NSError{
            showAlert(title: "Error", message: "\(error.localizedDescription)")
            
        }
        } else {
            showAlert(title: "Stock Exists", message: " You added this stock before")
        }
        }
    
    
    
    
    // fetch coredata func
    
    func retrieveCDStock (){
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<CDStock> = CDStock.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for result in searchResults as [NSManagedObject] {
                self.CDStocks.append(result)
                self.symbolArray.append(result.value(forKey: "symbol") as! String)
                
            }
        } catch {
            showAlert(title: "Error", message: "Can't fetch data")
        }
       
    }

    

}
