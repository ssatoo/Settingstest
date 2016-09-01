//
//  SomeGalleryViewController.swift
//  settingsMyTests
//
//  Created by Zacharias Giakoumi on 31/08/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class SomeGalleryViewController: UIViewController {

    @IBAction func playToolbarAction(sender: AnyObject) {
        self.imageViewGallery.makeToast(message: "Start slide show")
         self.Counter_timer.invalidate()
       Counter_timer =  NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(startSlideShow), userInfo: nil, repeats: true)

        
        
        
    }
    @IBAction func pauseToolbarAction(sender: AnyObject) {
        self.imageViewGallery.makeToast(message: "Stop slide show")
        
        Counter_timer.invalidate()
        
    }
    @IBAction func deleteToolbarAction(sender: AnyObject) {
        self.imageViewGallery.makeToast(message: "Delete picture")
        self.imageArray.removeAtIndex(imageindex)
    }
    @IBAction func doneToolbarAction(sender: AnyObject) {
        self.imageViewGallery.makeToast(message: "Done")
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
   
    @IBOutlet weak var imageViewGallery: UIImageView!
    
    
    var imageindex : Int = 1
    var Counter_timer = NSTimer()
    var imageArray  = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "Slide Show"

         self.setNavigationBarItem()
        
        for i in  1...6{
            self.imageArray.append("\(i).png")
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startSlideShow() {
       
        if (self.imageindex == imageArray.count) {
        self.imageindex = 1
        
        }else{
        
        self.imageindex += 1
          // sleep(5)
        }
           //self.imageViewGallery.image = (UIImage(named : "\(self.imageindex).png")!)
        
        self.animateImageView(UIImage(named : "\(self.imageindex).png")!)
        
    }
    
    func animateImageView(image : UIImage) {
        let animationDuration: NSTimeInterval = 0.5
        let switchingInterval: NSTimeInterval = 1
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
//        CATransaction.setCompletionBlock {
//          //  let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(10))
//            dispatch_after(1, dispatch_get_main_queue()) {
//                self.animateImageView(image)
//            }
//        }
        
        let transition = CATransition()
        transition.type = kCATransitionPush
        /*
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromRight
         */
        sleep(2)
        self.imageViewGallery.layer.addAnimation(transition, forKey: kCATransition)
        
        self.imageViewGallery.image = image
        
        CATransaction.commit()
        
      
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
