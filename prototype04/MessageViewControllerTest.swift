//
//  MessageViewControllerTest.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/06/26.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit

class MessageViewControllerTest: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate{
    @IBOutlet weak var noMatchingUserImageView: UIImageView!

    let ud = UserDefaults.standard
    
    
    var cardList:[[Any]] = []
    @IBOutlet weak var myTableView: UITableView!
//    var messageList:[Any] = []
    var selectedTag:Int = 0
    var cardList2:[Any]?
    let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var myMatchingList:[[String]]?
    let propetyName = recruiterPropety.self
    var myStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        if let status = User().status{
            myStatus = status
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let matchedList = app.myInfoDelegate?[userPropety.matched.rawValue] as? [[String]]
        myMatchingList = matchedList
        
        
        let parentVC = self.navigationController?.parent as! ContainerViewControllerTest
        parentVC.navigationView.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        cardList2 = app.messageList
        
        
        if cardList2?.count != nil{
            self.noMatchingUserImageView.isHidden = true
            
        }else{
            self.noMatchingUserImageView.isHidden = false
        }
        myTableView.reloadData()
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableviewメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.tag = indexPath.row
        switch myStatus {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageStudentCell", for: indexPath) as! MessageStudentTableViewCell
            if let userInfo2:[String:Any] = cardList2?[indexPath.row] as? [String:Any]{
                cell.titleLabel.text = userInfo2[userPropety.name.rawValue] as? String

                cell.imageButton.setImage(getImage(uuid: userInfo2[propetyName.uuid.rawValue] as! String), for: .normal)
                cell.imageButton.addTarget(self, action: #selector(self.goToDetailView(sender:)), for: .touchUpInside)
                cell.imageButton.tag = indexPath.row
                
                
                
                
                if let value = userInfo2[studentPropety.birth.rawValue] as? String{
                    let birthDate = DateUtils.date(value, format:"yyyy-MM-dd" )
                    let age = DateUtils.age(byBirthDate: birthDate)
                    
                    if let name = userInfo2[userPropety.name.rawValue] as? String{
                        cell.titleLabel.text = name + "(" + String(describing:age) + ")"
                    }
                }
                
                if let education = userInfo2[studentPropety.education.rawValue] as? [Any]{
                    if let schoolName = education[0] as? String,let faculty = education[1] as? String,let year = education[2] as? Int{
                        cell.label1.text = schoolName
                        cell.label2.text = faculty
                        cell.label3.text = String(describing: year) + "年卒"
                    }
                }
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCellDemo
        //        let userInfo:[Any] = cardList[indexPath.row]
        
        
        //        cell.userNameLabel.text = userInfo[0] as? String
        //        cell.AgeLabel.text = "(" + String(describing: userInfo[1]) + ")"
        //        cell.YeartoWorkLabel.text = userInfo[4] as? String
        //        cell.companyNameLabel.text = userInfo[6] as? String
        //        cell.labelImageView.image = userInfo[2] as? UIImage
        //        cell.companyImageView.image = userInfo[11] as? UIImage
        //        cell.userJobLabel.text = userInfo[3] as? String
        
        
        
        if let userInfo2:[String:Any] = cardList2?[indexPath.row] as? [String : Any] {
            
            
            
            
            cell.userNameLabel.text = userInfo2[propetyName.name.rawValue] as? String
            cell.userImageButton.setImage(getImage(uuid: userInfo2[propetyName.uuid.rawValue] as! String), for: .normal)
            cell.userImageButton.addTarget(self, action: #selector(self.goToDetailView(sender:)), for: .touchUpInside)
            cell.userImageButton.tag = indexPath.row
            cell.companyNameLabel.text = userInfo2[propetyName.company_name.rawValue] as? String
            cell.userJobLabel.text = userInfo2[propetyName.position.rawValue] as? String
            
            var count:CGFloat = 0
            let ogoriRect = CGRect(x: 0, y: 0, width: cell.ogoriView.frame.height, height: cell.ogoriView.frame.height)
            let ogoriPadding:CGFloat = 5
            if userInfo2["ogori"] != nil{
                for ogori in userInfo2["ogori"] as! [Int]{
                    let ogoriImageView = UIImageView(frame: ogoriRect)
                    cell.ogoriView.addSubview(ogoriImageView)
                    switch ogori {
                    case 0:
                        ogoriImageView.image = #imageLiteral(resourceName: "morning_rect")
                    case 1:
                        ogoriImageView.image = #imageLiteral(resourceName: "lunch_rect")
                    case 2:
                        ogoriImageView.image = #imageLiteral(resourceName: "dinner_rect")
                    case 3:
                        ogoriImageView.image = #imageLiteral(resourceName: "cafe_rect")
                    default:
                        break
                    }
                    
                    if count == 0{
                        ogoriImageView.layer.position.x = ogoriRect.height/2
                    }else{
                        ogoriImageView.layer.position.x = count*ogoriRect.height + ogoriRect.height/2 + ogoriPadding
                    }
                    
                    count += 1
                }
            }
            return cell
        }
        default:
            break
        }
        
        
        return cell
    }
    
    @objc func goToDetailView(sender:UIButton){
        selectedTag = sender.tag
        
        switch myStatus {
        case 1:
            performSegue(withIdentifier: "studentDetailSegue", sender: nil)
        case 2:
            performSegue(withIdentifier: "userDetailSegue", sender: nil)
        default:
            break
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cardList2 == nil {
            return 0
        }
        
        return cardList2!.count
    }
    
    var selectedUserName:String = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        let parentVC = self.navigationController?.parent as! ContainerViewControllerTest
        parentVC.navigationView.isHidden = true
        selectedTag = indexPath.row
        performSegue(withIdentifier: "segueChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueChat"{
//            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let vc = segue.destination as! ChatViewController
            let user = cardList2![selectedTag] as! [String:Any]
            vc.navigationTitle = user[propetyName.name.rawValue] as! String
            vc.senderId = app.myInfoDelegate?[propetyName.uuid.rawValue] as! String
            vc.recieverId = user[propetyName.uuid.rawValue] as? String
            vc.senderDisplayName = user[propetyName.name.rawValue] as! String
            let key = myMatchingList?[selectedTag][1]
            vc.selectedRow = selectedTag
            
            
            
            if let key = key{
                vc.roomKey = key
            }
            
        }
        
        if segue.identifier == "userDetailSegue"{
            
            let vc = segue.destination as! MessageUserDetailViewController
            vc.userDic = cardList2![selectedTag] as! [String : Any]
        }
        
        if segue.identifier == "studentDetailSegue"{
            let vc = segue.destination as! DetailStudentViewControllerTest
            vc.dummyUser = cardList2![selectedTag] as! [String : Any]
        }
    }
    
    func pasteTag(forView targetView:UIView,forTagList TagList:[String],heightConstraint:NSLayoutConstraint){
        
        var pointX:CGFloat = 10
        var pointY:CGFloat = 10
        var lastHeight:CGFloat = 0
        
        for view in targetView.subviews{
            if view == targetView.subviews.first{
                continue
            }
            view.removeFromSuperview()
        }
        
        
        
        for tagText in TagList{
            let tagLabel:TagLabel = TagLabel(frame: .zero, inText: tagText)
            targetView.addSubview(tagLabel)
            
            
            
            if pointX + tagLabel.frame.width + 10 > targetView.frame.width{
                pointX = 10
                pointY += 5 + tagLabel.frame.height
            }
            
            tagLabel.frame.origin = CGPoint(x: pointX, y: pointY)
            
            pointX += 5 + tagLabel.frame.width
            lastHeight = pointY + tagLabel.frame.height
        }
        
        heightConstraint.constant = lastHeight + 10
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .default, title: "ブロック") { (action, index) -> Void in
            
            let alert = UIAlertController(title: "ユーザーの削除", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.cardList2!.remove(at: indexPath.row)
                //
                let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                app.messageList?.remove(at: indexPath.row)
                self.myTableView.deleteRows(at: [indexPath], with: .fade)
                
                //消したときにユーザーが一人も居ないとき
                if app.messageList?.count == 0 {
                    self.noMatchingUserImageView.isHidden = false
                }
            })
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
//            self.myTableView.reloadData()
        }

        
        return [deleteButton]
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            self.cardList2?.remove(at: indexPath.row)
//            myTableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    
    //uuidを指定して、画像を取得
    func getImage(uuid:String)->UIImage?{
        
        
        guard let imgFilePath = URL(string: "http://52.163.126.71:80/test/img/\(uuid)/userimg.jpg") else { return nil}
        var img:UIImage?
        
        do{
            let data = try Data(contentsOf: imgFilePath)
            img = UIImage(data: data)
        }catch{
            print("error:\(error.localizedDescription)")
        }
        if img == nil{
            img = #imageLiteral(resourceName: "anonymous")
        }
        
        return img
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
