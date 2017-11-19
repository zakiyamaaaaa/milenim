//
//  RegisterImageViewController.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/08/12.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//
import Firebase
import UIKit

//自分の写真を登録する
class RegisterImageViewController: UIViewController,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    @IBOutlet weak var waitingView: RectView!
    @IBOutlet weak var myImageView: UIImageView!
    var selectedImage:UIImage?
    var postImage:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid{
            var a = my()
            a.register(key: .uuid, value: uid)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "メディアの選択", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action:UIAlertAction) in
                let ipc = UIImagePickerController()
                ipc.sourceType = .camera
                ipc.delegate = self
                self.present(ipc, animated:true, completion: nil)
                
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction(title: "フォトライブラリ", style: .default, handler: {(actioin:UIAlertAction) in
                
                let ipc :UIImagePickerController = UIImagePickerController()
                ipc.sourceType = .photoLibrary
                ipc.delegate = self
                self.present(ipc, animated:true, completion: nil)
                
                
            })
            alertController.addAction(photoLibraryAction)
            
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 1)
        present(alertController,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "cropImageSegue", sender: self.selectedImage)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imgFileName = "userimg.png"
        
        if let image = myImageView.image {
            let pngData = UIImagePNGRepresentation(image)
            do{
                try pngData?.write(to: URL(fileURLWithPath: "\(documentDir)/\(imgFileName)"))
            }catch{
                print(error.localizedDescription)
            }
        }
        //データベースの情報を更新
        self.registerUser(postImage: postImage)
        
    }
    
    @IBAction func returnToTop(segue: UIStoryboardSegue) {
        
        if segue.identifier  == "unwindCrop"{
            
            let vc = segue.source as! CropEditViewController
            myImageView.image = vc.maskedImage
            postImage = vc.maskedImage
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cropImageSegue"{
            let vc = segue.destination as! CropEditViewController
            vc.originalImage = selectedImage
        }
    }


    func registerUser(postImage:UIImage?){
        let user = User()
        guard let status = user.status else { return }
        self.waitingView.alpha = 1
        
        switch status {
        case 1:
            
            var postData = Recruiter().all
            if let image = postImage{
                let pngImageData = UIImagePNGRepresentation(image)! as NSData
                let encodedImageData = pngImageData.base64EncodedString(options: [])
                postData["profileImage"] = encodedImageData
                
            }
            
            let requestURL = URL(string: "http://52.163.126.71:80/test/registerUser.php")
            var request = URLRequest(url: requestURL!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
                let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                    print("register my data")
                    let str = String(data:data!,encoding:.utf8)
                    print("data:\(str!)")
                    DispatchQueue.main.async(execute: { 
                        UIView.animate(withDuration: 1, animations: { 
                            self.waitingView.alpha = 0
                        })
                    })
                    if str! == "hoge" {
                        self.performSegue(withIdentifier: "goSegue", sender: nil)
                        
                    }else{
                        let alert = UIAlertController(title: "プロフィール更新失敗", message: "更新が失敗しました。時間をとって再度行ってください", preferredStyle: .alert)
                        
                        
                        self.present(alert, animated: true, completion: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute:
                                {
                                    alert.dismiss(animated: true, completion: {
                                        self.dismiss(animated: true, completion: nil)
                                    })
                            }
                                
                            )
                        })
                    }
                    
                })
                task.resume()
                
                
            }catch{
                print("error:\(error.localizedDescription)")
                
            }
        case 2:
            
            var postData = my().all
            if let image = postImage{
                let pngImageData = UIImagePNGRepresentation(image)! as NSData
                let encodedImageData = pngImageData.base64EncodedString(options: [])
                postData["profileImage"] = encodedImageData
                
            }
            
            let requestURL = URL(string: "http://52.163.126.71:80/test/registerUser.php")
            var request = URLRequest(url: requestURL!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
                let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                    print("register my data")
                    let str = String(data:data!,encoding:.utf8)
                    print("data:\(str!)")
                    DispatchQueue.main.async(execute: {
                        UIView.animate(withDuration: 1, animations: {
                            self.waitingView.alpha = 0
                        })
                    })
                    if str! == "hoge" {
                        self.performSegue(withIdentifier: "goSegue", sender: nil)
                        
                    }else{
                        let alert = UIAlertController(title: "プロフィール更新失敗", message: "時間をおいて再度行ってください", preferredStyle: .alert)
                        
                        
                        self.present(alert, animated: true, completion: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute:
                                {
                                    alert.dismiss(animated: true, completion: {
                                        self.dismiss(animated: true, completion: nil)
                                    })
                            }
                                
                            )
                        })
                    }
                    
                })
                task.resume()
                
                
            }catch{
                print("error:\(error.localizedDescription)")
                
            }
        default:
            break
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
