//
//  CircleIndicatorViewController.swift
//  settingsMyTests
//
//  Created by Zacharias Giakoumi on 18/08/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class CircleIndicatorViewController: UIViewController {
 
    @IBOutlet weak var progress: KDCircularProgress!
    
    @IBOutlet weak var progresLbl: UILabel!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        progress.animateFromAngle(progress.angle, toAngle: 0, duration: 0.5, completion: nil)
        
        
        progress.animateFromAngle(0, toAngle: 360, duration: 100) { completed in
       
            print("self.progress -> \(self.progress.angle)")
           
            
            if completed {
                print("animation stopped, completed")
                
            } else {
                print("animation stopped, was interrupted")
            }
        }
    }
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
       
        self.title =  "Test"

        
//        progress.animateFromAngle(0, toAngle: 360, duration: 5) { completed in
//                   if completed {
//                print("animation stopped, completed")
//            } else {
//                print("animation stopped, was interrupted")
//            }
//        }        // Do any additional setup after loading the view.
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
