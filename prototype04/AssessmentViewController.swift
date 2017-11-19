//
//  AssessmentViewController.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/08/12.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit
import Firebase
//import UserNotifications

class AssessmentViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        //本来ここで審査通過の際の通知設定をしたかったのだが、実機でうまくいってないので、いまのところ保留
//        let center = UNUserNotificationCenter.current()
//        
//        center.requestAuthorization(options: [.badge,.alert,.sound]) { (granted, error) in
//            if error != nil{
//                return
//            }
//            
//            if granted{
//                //通知許可
//                center.delegate = self
//            }
//            
//            if granted == false{
//                //通知不許可
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {


    }
    
    override func viewDidAppear(_ animated: Bool) {
        //相手が一定数以上いれば、次の画面へ遷移する
        
        let ref = Database.database().reference()
        //firebaseのvalidキーがtrueになっていれば画面遷移をする
        if let uuid = Auth.auth().currentUser?.uid{
            
            ref.child("users").child(uuid).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:Any]{
                    let flag = dict["valid"] as? Bool
                    
                    if flag == true{
                        UserDefaults.standard.set(true, forKey: "valid")
                        
                        let storyboard = UIStoryboard(name: "Register", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "readyToMain") as! ReadyMainViewController
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.show(vc, sender: nil)
                    }
                }
                
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //自分の情報を確認するボタンを押したときの挙動。
    @IBAction func confirmProfile(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
