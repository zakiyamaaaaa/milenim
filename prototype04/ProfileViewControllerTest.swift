//
//  ProfileViewControllerTest.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/08/06.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit

class ProfileViewControllerTest: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var profileEditedRatio: UILabel!
    
    var myStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let status = User().status{
            myStatus = status
        }
        
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = myImageView.frame.width/2
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imgFileName = "userimg.png"
        var tmp = UIImage(contentsOfFile: "\(documentDir)/\(imgFileName)")
        if tmp == nil{
            tmp = #imageLiteral(resourceName: "anonymous_43")
        }
        
        myImageView.image = tmp
        myImageView.layer.masksToBounds = true
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileEditedRatio.text =  String(ProfileEdited().calcurateRatio(status: myStatus)) + "%"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //1ひとこと
    //2良い点
    //3悪い点
    //4興味
    //5学歴
    //6自己紹介
    //7所属団体について
    @IBAction func editButtonTapped(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Profile", bundle: nil)
        //statusによって遷移先のVCを切り替える
        switch myStatus {
        case 1:
            let controller = sb.instantiateViewController(withIdentifier: "companyProfileNav") as! UINavigationController
            show(controller, sender: nil)
        case 2:
            
            let controller = sb.instantiateViewController(withIdentifier: "studentProfileNav") as! UINavigationController
            show(controller, sender: nil)
        default:
            break
        }
        
        
    }

    @IBAction func openPrivacy(_ sender: Any) {
        let url = URL(string:"http://milenim.sakura.ne.jp/privacy/")
        if( UIApplication.shared.canOpenURL(url!) ) {
            UIApplication.shared.open(url!)
        }
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
