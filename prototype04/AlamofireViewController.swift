//
//  AlamofireViewController.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/11/19.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postData:[String:Any] = ["lng": 135.406417, "status": 2, "uuid": "TO2QfKvXwTUnUk9uv1jk3K5EYJT2", "lat": 37.785834000000001]
        let parameter:Parameters = postData
        
        var returnData:[Any]?
        
        let base = APIUrl.baseUrl
        let requestUrl = APIUrl.requestUrl.updateLocation.rawValue
        let url = base + requestUrl
        
        guard let requestURL = URL(string: url) else {return}
        
        //        guard let requestURL = URL(string: "http://localhost:8888/test/updateLocation.php") else {return}
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let header:HTTPHeaders = ["Content-Type":"application/json"]
        

        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            switch response.result{
            case .success:
                print("success")
                if let json = response.result.value{
                    print(json)
                }
                
            case .failure(let error):
                
                print("error")
            }
        }
        
        
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                do{
                    returnData = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any]
                    //app deleagetに取得したデータを格納
                    let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    app.cardListDelegate = returnData
                    
//
                }catch{
                    print("json decode error:\(error.localizedDescription)")
                }
                
            })
            
//            task.resume()
        }catch{
            print("error:\(error.localizedDescription)")
        }

        // Do any additional setup after loading the view.
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
