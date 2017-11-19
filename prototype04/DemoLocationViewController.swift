//
//  DemoLocationViewController.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/08/20.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit

class DemoLocationViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let circleView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        circleView.center = self.view.center
        circleView.layer.cornerRadius = 200/2
        circleView.backgroundColor = UIColor.rgbColor(0xfffadad)
        self.view.addSubview(circleView)
        self.view.bringSubview(toFront: userImageView)
        
        //後ろの動き
        UIView.animate(withDuration: 4, delay: 0, options: [.repeat, .curveLinear], animations: {
            circleView.transform = CGAffineTransform.init(scaleX: 4, y: 4)
            circleView.alpha = 0
            
        }, completion: { _ in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
