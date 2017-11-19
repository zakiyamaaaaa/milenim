//
//  ContainerViewControllerTest.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/06/26.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit

class ContainerViewControllerTest: UIViewController{
    
//    var vc:RecruiterViewController=RecruiterViewController()
    
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainFooterImage = #imageLiteral(resourceName: "main-footer-icon").withRenderingMode(.alwaysTemplate)
        mainButton.setImage(mainFooterImage, for: .normal)
        mainButton.tintColor = UIColor.black
        
        let messageFooterImage = #imageLiteral(resourceName: "message-footer-icon").withRenderingMode(.alwaysTemplate)
        messageButton.setImage(messageFooterImage, for: .normal)
        messageButton.tintColor = UIColor.lightGray
        
        let profileFooterImage = #imageLiteral(resourceName: "profile-footer-icon").withRenderingMode(.alwaysTemplate)
        profileButton.setImage(profileFooterImage, for: .normal)
        profileButton.tintColor = UIColor.lightGray
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.6) {
            self.profileButton.tintColor = UIColor.black
            self.mainButton.tintColor = UIColor.lightGray
            self.messageButton.tintColor = UIColor.lightGray
            
            
            self.contentView.transform = CGAffineTransform.init(translationX: self.view.frame.width, y: 0)
        }
    }

    
    @IBAction func centerButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.6) {
            self.profileButton.tintColor = UIColor.lightGray
            self.mainButton.tintColor = UIColor.black
            self.messageButton.tintColor = UIColor.lightGray
            
            self.contentView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }
    }
    
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.6) {
            self.profileButton.tintColor = UIColor.lightGray
            self.mainButton.tintColor = UIColor.lightGray
            self.messageButton.tintColor = UIColor.black
            
            self.contentView.transform = CGAffineTransform.init(translationX: -self.view.frame.width, y: 0)
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
