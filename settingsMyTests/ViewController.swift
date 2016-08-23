//
//  ViewController.swift
//  settingsMyTests
//
//  Created by Zacharias Giakoumi on 08/08/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ApiServiceDelegate {
    
    var response: String = ""
    var timer = NSTimer()
    var Counter_timer = NSTimer()
    var counter = 0
    var totalSec =  0
    
    
    var progressCounter:Int = 0 {
        didSet {
            let fractionalProgress = Float(progressCounter) / 100.0
            let animated = progressCounter != 0
            
            self.progressBar.setProgress(fractionalProgress, animated: animated)
            self.progressLbl.text = ("\(progressCounter)%")
        }
    }
    
    
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var StopTime: UILabel!
    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var StopStartBtn: UIButton!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBAction func StopStartTimeBtn_Action(sender: AnyObject) {
        
        switch  sender.tag {
        case 1:
            counter =  0
            self.StopTime.backgroundColor =  UIColor.lightGrayColor()
            self.StopTime.layer.cornerRadius =  9
            self.StopTime.layer.masksToBounds = true
            
            self.StopTime.text =  timeLbl.text
            
            self.Counter_timer.invalidate()
            self.StopStartBtn.setTitle("Stop", forState: UIControlState.Normal)
            self.StopStartBtn.tag =  2
            Counter_timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(StartTimer), userInfo: nil, repeats: true)
            break
        case 2:
            self.StopTime.backgroundColor =  UIColor.whiteColor()
            
            self.Counter_timer.invalidate()
            self.StopTime.text =  ""
            self.StopStartBtn.setTitle("Start", forState: UIControlState.Normal)
            self.StopStartBtn.tag =  1
            Counter_timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(StopTimer), userInfo: nil, repeats: false)
            break
        default:
            print("default case")
        }
        
        // just in case this button is tapped multiple times
        
        // start the timer
        
        
        
    }
    func StartTimer() {
        counter += 1
        self.counterLbl.text = "\(self.secondsToHoursMinutesSeconds(counter))"
    }
    func StopTimer() {
        self.counterLbl.text = "Your time is \(self.secondsToHoursMinutesSeconds(counter)) "
        print("timer count (\(counter))")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Home"
        
        self.setNavigationBarItem()
        
        print(Utility.getAppName())
        print(Utility.getAppVersion())
        
        self.progressBar.setProgress(0, animated: true)
        self.startCount()
        
        self.counterLbl.text = "Press Start button"
        
        // Do any additional setup after loading the view, typically from a nib.
        self.counterLbl.backgroundColor =  UIColor.lightGrayColor()
        self.counterLbl.layer.cornerRadius =  9
        self.counterLbl.layer.masksToBounds = true
        
        self.StopStartBtn.layer.cornerRadius =  3
        let serviceCall:Utility = Utility()
        serviceCall.apiDelegate = self;
        
        print("api calls : \(Utility.apiMethod.Url_Api_1)")
        print("api calls : \(Utility.apiMethod.Url_Api_2)")
        print("api calls : \(Utility.apiMethod.googleUrl)")
        
        serviceCall.ServiceRequest(Utility.apiMethod.googleUrl, params:"")
        
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                            target: self,
                                                            selector: #selector(ViewController.tick),
                                                            userInfo: nil,
                                                            repeats: true)
    }
    
    @objc func tick() {
        self.timeLbl.text = NSDateFormatter.localizedStringFromDate(NSDate(),
                                                                    dateStyle: .MediumStyle,
                                                                    timeStyle: .MediumStyle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let returnString = "\(seconds / 3600) hours, \((seconds % 3600) / 60) minutes , \((seconds % 3600) % 60 ) seconds "
        return returnString
    }
    
    func serviceCallDidFinish(responseString : NSString)  {
        print("serviceCallDidFinish : \(responseString)")
        response  = responseString as String
    }
    
    
    func startCount() {
        self.progressLbl.text = "0%"
        self.progressCounter = 0
        for i in 0..<101 {
            print("progressCounter (\(i)%)")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                sleep(UInt32(1))
                dispatch_async(dispatch_get_main_queue(), {
                    self.progressCounter = i
                    return
                })
            })
        }
        
    }
    
    func onScrollViewDoubleTapped(recognizer:UITapGestureRecognizer)
    {
        print("toast")
    }
    
    
    // MARK: - Events
    func pushMenu()
    {
        print("pushing")
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let main = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftMenuViewSID") as! LeftMenuViewController
        //let rightViewController:UIViewController! = storyboard.instantiateViewControllerWithIdentifier("RightMenuViewSID") as! RightMenuVC
        let nvc: UINavigationController = UINavigationController (rootViewController: main)
        
        
        leftViewController.menu1 = nvc
        
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        self.navigationController?.pushViewController(slideMenuController, animated:false)
        
    }
    
    
}

