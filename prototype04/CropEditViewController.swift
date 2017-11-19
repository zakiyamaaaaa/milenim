//
//  CropEditViewController.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/06/01.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit

class CropEditViewController: UIViewController {

    @IBOutlet weak var originalSelectedImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var myImageView: UIImageView!
    
    var originalImage:UIImage!
    var maskedImage:UIImage!
    
    let ud = UserDefaults.standard
    
    @IBOutlet weak var conetntViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var overlayView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = true
        overlayView.frame = self.view.frame
        let ratio:CGFloat = self.view.frame.width/originalImage!.size.width
        let newImage:UIImage =  originalImage!.resize(ratio: ratio)
        
        let diffHeight:CGFloat = (newImage.size.height - maskView.frame.height)
        maskView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.width*3/4)
        maskView.center = self.view.center

        if diffHeight > 0 {
            print("Portrait")

            conetntViewHeightContraint.constant = diffHeight
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: diffHeight/2, right: 0)
            scrollView.contentOffset.y = diffHeight/2
        }else{
            print("Landscape")
        }
        
        maskView.layer.borderColor = UIColor.white.cgColor
        maskView.layer.borderWidth = 2
        originalSelectedImageView.image = originalImage
        
        setMask(with: maskView.frame, in: overlayView)
        
        
        
        
        // Do any additional setup after loading the view.
    }

    
    
    
    
    func setMask(with hole: CGRect, in view: UIView){
        
        // Create a mutable path and add a rectangle that will be h
        let mutablePath = CGMutablePath()
        mutablePath.addRect(view.bounds)
        mutablePath.addRect(hole)
        
        // Create a shape layer and cut out the intersection
        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillRule = kCAFillRuleEvenOdd
        
        // Add the mask to the view
        view.layer.mask = mask
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //performSegue(withIdentifier: "unwindCrop", sender: nil)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        let ratio:CGFloat = self.view.frame.width/originalImage!.size.width
        
        let newImage:UIImage =  originalImage!.resize(ratio: ratio)
        
        let rect = CGRect(x: 0, y: scrollView.contentOffset.y, width: self.view.frame.width, height: self.view.frame.width/4*3)
        let cropedImage = newImage.cropping(to: rect)
        maskedImage = cropedImage
        
        
        performSegue(withIdentifier: "unwindCrop", sender: nil)
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

extension UIImage{
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    // 比率だけ指定する場合
    func resize(ratio: CGFloat) -> UIImage {
        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func cropping(to: CGRect) -> UIImage? {
        var opaque = false
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
            case .noneSkipLast, .noneSkipFirst:
                opaque = true
            default:
                break
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, scale)
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
