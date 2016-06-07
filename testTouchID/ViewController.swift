//
//  ViewController.swift
//  testTouchID
//
//  Created by 薛焱 on 16/6/3.
//  Copyright © 2016年 薛焱. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func nextPageAction(sender: AnyObject) {
        let context = LAContext()
        context.localizedFallbackTitle = "输入密码"
        var error: NSError?
        let reasonString = "需要指纹认证进入下一页"
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, error:NSError?) in
                if success {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.performSegueWithIdentifier("next", sender: nil)
                    })
                }else{
                    switch error!.code {
                    case LAError.SystemCancel.rawValue:
                        print("系统取消指纹认证")
                    case LAError.UserCancel.rawValue:
                        print("用户取消指纹认证")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    case LAError.UserFallback.rawValue:
                        print("输入密码")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    case LAError.PasscodeNotSet.rawValue:
                        print("没有设置密码")
                    case LAError.TouchIDNotEnrolled.rawValue:
                        print("没有设置touchID")
                    case LAError.TouchIDLockout.rawValue:
                        print("touchID被锁定")
                    case LAError.AppCancel.rawValue:
                        print("应用取消")
                    case LAError.InvalidContext.rawValue:
                        print("无效")
                    case LAError.TouchIDNotAvailable.rawValue:
                        print("touchID不可用")
                    case LAError.AuthenticationFailed.rawValue:
                        print("没有正确验证")
                        
                    default:
                        print("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
                
            })
        }
    }
    
    func showPasswordAlert() {
        let alert = UIAlertController(title: "提示", message: "输入数字密码", preferredStyle: .Alert)
        let action = UIAlertAction(title: "确定", style: .Default, handler: { (alertAction:UIAlertAction) in
            self.performSegueWithIdentifier("next", sender: nil)
        })
        let action1 = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (text:UITextField) in
            
        }
        alert.addAction(action)
        alert.addAction(action1)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

