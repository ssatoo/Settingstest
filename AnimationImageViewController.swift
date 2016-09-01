//
//  AnimationImageViewController.swift
//  settingsMyTests
//
//  Created by Zacharias Giakoumi on 23/08/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class AnimationImageViewController: UIViewController {

    @IBOutlet weak var animatinoImage: UIImageView!
    var animationImages = [UIImage]()
    @IBAction func StartAnimationAction(sender: AnyObject) {
    

        
        
        if animatinoImage.isAnimating(){
            self.animatinoImage.stopAnimating()
         sender.setTitle("START", forState: UIControlState.Normal)
        }else{
            sender.setTitle("STOP", forState: UIControlState.Normal)
            self.animatinoImage.animationDuration = 2
            self.animatinoImage.startAnimating()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setNavigationBarItem()
        self.title =  "Alien"
        for i in  1...6 {
            animationImages.append(UIImage(named : "\(i).png")!)
        
        }
        self.animatinoImage.animationImages =  self.animationImages
        
        
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
