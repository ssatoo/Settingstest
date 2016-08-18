//
//  LeftMenuViewController.swift
//  settingsMyTests
//
//  Created by Zacharias Giakoumi on 10/08/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    

    case Menu1
    case Menu2
    case Menu3
    case Menu4

}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftMenuViewController: UIViewController,LeftMenuProtocol {

    @IBOutlet weak var welcomeUserLbl: UILabel!
    @IBOutlet weak var userAvatar: UIView!
    @IBOutlet weak var menuTopView: UIView!
    @IBOutlet weak var menuTable: UITableView!
    var menus = [
        "Home",
        "More",
        "Map - Location",
        "Circular progressbar"
       ]
    
    var menuImage = ["profile", "help", "info","queries"]
   
    var menu1 : UIViewController!
    var menu2: UIViewController!
    var menu3: UIViewController!
    var menu4: UIViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        
        let page1 = storyboard.instantiateViewControllerWithIdentifier("ViewController")
        self.menu1 = UINavigationController(rootViewController: page1)
        
        let page2 = storyboard.instantiateViewControllerWithIdentifier("MoreViewController")
        self.menu2 = UINavigationController(rootViewController: page2)
        
        let page3 = storyboard.instantiateViewControllerWithIdentifier("ThirthMenuViewController")
        self.menu3 = UINavigationController(rootViewController:page3)
        
        let page4 =  storyboard.instantiateViewControllerWithIdentifier("CircleIndicatorViewController")
        self.menu4 = UINavigationController(rootViewController:page4)
        
        self.slideMenuController()?.changeMainViewController(self.menu1, close: true)
        
        self.menuTable.registerCellClass(BaseTableViewCell.self)

        
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
                let currnetViewColor = self.menuTopView.backgroundColor
        
        
                let frame = self.menuTopView.bounds
        
                let gradient: CAGradientLayer = CAGradientLayer()
                gradient.frame = frame
                gradient.colors = [currnetViewColor!.CGColor, UIColor.whiteColor().CGColor]
                self.menuTopView.layer.insertSublayer(gradient, atIndex: 0)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: BaseTableViewCell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "TrebuchetMS-bold", size:15.0)
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.text = menus[indexPath.row]
        cell.imageView?.image = UIImage(named:menuImage[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func changeViewController(menu: LeftMenu) {
        print("changeViewController")
        switch menu {
        case .Menu1:
            print("Menu 1")
            self.slideMenuController()?.changeMainViewController(self.menu1, close: true)
            break
            
        case .Menu2:
             print("Menu 2")
            self.slideMenuController()?.changeMainViewController(self.menu2, close: true)
            break
            
        case .Menu3:
             print("Menu 3")
            self.slideMenuController()?.changeMainViewController(self.menu3, close: true)
            break
      

        case .Menu4:
            print("Menu 4")
            self.slideMenuController()?.changeMainViewController(self.menu4, close: true)
            
            
        }
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
