//
//  ViewController.swift
//  QuickPoll
//
//  Created by Shruthi on 11/07/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import UIKit

//MARK:- Viewcontroller containing Poll data in table
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var tableData : [DummyCellDS] = []
    var dataForSection0 : [DummyCellDS] = []
    
    //MARK:- view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Image.jpeg")!)

        setDummyData()
        
        table.delegate = self
        table.dataSource = self        
    }
    
    //MARK:- table Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        var count:Int = 0
        switch section {
        case 0:
            count = tableData.count
        case 1:
            count = dataForSection0.count
        default: break
        }
        
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = table.dequeueReusableCell(withIdentifier: "TheCell", for: indexPath)
        
        var cellData:DummyCellDS
        if indexPath.section == 0 {
            cellData = tableData[indexPath.row]
        } else {
            cellData = dataForSection0[indexPath.row]
        }
        
        cell.textLabel?.text = cellData.title
        
        return cell
        
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        //BG View
        let headerView:UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: headerFrame.size.width, height:  headerFrame.size.height))
        headerView.backgroundColor = UIColor.lightText
        
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: UIRectCorner.topLeft.union(.topRight), cornerRadii: CGSize.init(width: 10, height: 10)).cgPath
        headerView.layer.mask = maskLayer

        
        //Title
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 12)
        title.textColor = UIColor.darkText
        headerView.addSubview(title)
        
        //Button
        let headBttn:UIButton = UIButton(type: .custom)
        headBttn.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = headBttn.widthAnchor.constraint(equalToConstant: 80)
        headBttn.addConstraint(widthConstraint)

        headBttn.isEnabled = true
        headBttn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12)
        headBttn.tag = section
        headBttn.setTitleColor(UIColor.darkText, for: .normal)
        headerView.addSubview(headBttn)

        switch section {
        case 0:
            title.text = "Tap for Some More"
            headBttn.setTitle("show more", for: .normal)
            headBttn.addTarget(self, action: #selector(buttonPressed(sender:)), for: UIControlEvents.touchUpInside)

        default:
            title.text = "Some other cell"
            headBttn.setTitle("", for: .normal)
        }
       
        
        //For setting constraints
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["title"] = title
        viewsDict["headBttn"] = headBttn
        
        headerView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-10-[title]-[headBttn]-15-|", options: [], metrics: nil, views: viewsDict))
        
        headerView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-[title]-|", options: [], metrics: nil, views: viewsDict))
        headerView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-[headBttn]-|", options: [], metrics: nil, views: viewsDict))
        
        return headerView
        
    }

    //MARK:- SetDummy data for table
    func setDummyData() {
        tableData.append(DummyCellDS(title: "some cell"))
        
        dataForSection0.append(DummyCellDS(title: "some cell one"))
        dataForSection0.append(DummyCellDS(title: "some cell two"))
        dataForSection0.append(DummyCellDS(title: "some cell three"))
        dataForSection0.append(DummyCellDS(title: "some cell 4"))
        dataForSection0.append(DummyCellDS(title: "some cell 5"))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Section Button Action
    var header = Header(state: 0)
    func buttonPressed(sender:UIButton) {
        if header.state == 0 {
            moreData(forSection: sender.tag)
            self.header.state = 1
            sender.setTitle("show less", for: .normal)
        } else {
            lessData(forSection: sender.tag)
            self.header.state = 0
            sender.setTitle("show more", for: .normal)
            
        }
        
        debugPrint("button pressed \(sender.tag)")
        
    }
    //MARK:- Dummy data for more Data
    func moreData(forSection section:Int) {
      
        table.beginUpdates()

        tableData.insert(DummyCellDS(title: "new cell 1"), at: 0 )
        tableData.insert(DummyCellDS(title: "new cell 2"), at: 1 )
        tableData.insert(DummyCellDS(title: "new cell 3"), at: 2 )
        tableData.insert(DummyCellDS(title: "new cell 4"), at: 3 )
        
        table.insertRows(at: [NSIndexPath.init(row: 0, section: section) as IndexPath, NSIndexPath.init(row: 1, section: section) as IndexPath, NSIndexPath.init(row: 2, section: section) as IndexPath,  NSIndexPath.init(row: 3, section: section) as IndexPath], with: .none)
        
        table.endUpdates()

    }
    //MARK:- remove data for less Data
    func lessData(forSection:Int) {
        
        table.beginUpdates()
        
        tableData.remove(at:3)
        tableData.remove(at:2)
        tableData.remove(at:1)
        tableData.remove(at:0)
        
        table.deleteRows(at: [NSIndexPath.init(row: 0, section: forSection) as IndexPath, NSIndexPath.init(row: 1, section: forSection) as IndexPath, NSIndexPath.init(row: 2, section: forSection) as IndexPath as IndexPath,  NSIndexPath.init(row: 3, section: forSection) as IndexPath], with: .none)
        
        table.endUpdates()

    }

}

//MARK:- dummy cell
struct DummyCellDS {
    let title : String
    init (title:String) {
        self.title = title
    }
}

//Section Header Status
struct Header {
    var state : Int // -1 default , 1 selected, 0 unselected
    
    init(state:Int) {
        self.state = state
    }
}



