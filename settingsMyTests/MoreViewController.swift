//
//  MoreViewController.swift
//  settingsMyTests
//
//  Created by Zacharias Giakoumi on 09/08/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var appVersionLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.setNavigationBarItem()
     
        self.title =  "More"
        self.appNameLbl.text =  Utility.getAppName()
        self.appVersionLbl.text = Utility.getAppVersion()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
