//
//  AppDelegate.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/05/09.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    
    var cardListDelegate:[Any]?
    var myInfoDelegate:[String:Any?]?
    
    var selectedTagListDelegate:[[jobTagType:String]]?
    
    var matchingIdList:[[String]]?
    var messageList:[Any]?
    
    var myProperty:[String:Any?] = my().all
    
    
    
    override init() {
        super.init()
        
        FirebaseApp.configure()
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
//        すでにFirebaseでユーザーとしてログイン済みであれば、メイン画面へ。そうでなければログイン画面へ。
        
//        let ref = Database.database().reference()
        //firebaseのvalidキーがtrueになっていれば画面遷移をする

        if UserDefaults.standard.bool(forKey: "valid") == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }else{
            let storyboard = UIStoryboard(name: "First", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("InActive")
        
        //もしmyInfoDelegateが有れば、メイン画面でのスワイプ結果の情報を更新する
        if myInfoDelegate != nil{
            ServerConnection().updateWhenAppInActive()
        }
        
        
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //審査でパスしたときのローカル通知部分
        print("enterbackgound")
        //実機でうまくいかないので、一旦コメントアウト
//        let ref = Database.database().reference()
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//        let content = UNMutableNotificationContent()
//        content.title = "重要 -ミレニム-"
//        content.subtitle = "審査の通過"
//        content.body = "おめでとうございます。審査に通過しました！"
//        content.sound = UNNotificationSound.default()
//        //シミュレータでバッジは表示されないみたい！！
//        content.badge = 1
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: "assesment", content: content, trigger: trigger)
//        
//        //validがtrueに変更されたときにBackgroundになっていたら、ローカル通知を実行する
//        //一応シミュレーターだと動作するが、実機だとうまくいかない
//        
//        if let uuid = Auth.auth().currentUser?.uid{
//            print(ref.child("users").child(uuid).description())
//            ref.child("users").child(uuid).observe(.childChanged, with: { (snapshot) in
//                
//                print("changed")
//                if let snapValue = snapshot.value as? Bool{
//                    if snapValue == true{
//                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//                    }
//                }
//                
//            })
//        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("enterforeground")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let vc = storyboard.instantiateInitialViewController() else { return }
//        self.window?.rootViewController = vc
        
        
//        let authentication = 
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("didbecomeactive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("willterminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

