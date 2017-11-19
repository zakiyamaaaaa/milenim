//
//  MessageUserDetailViewController.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/08/01.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit

class MessageUserDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    
    let propetyName = recruiterPropety.self
    let sectionTitle = ["","何をやっているのか","経歴","学歴","会社情報","会社紹介","特徴","募集求人"]
    @IBOutlet weak var myTableView: UITableView!
    var userDic:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.estimatedRowHeight = 90
        myTableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        return img
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 3:
            let career = userDic[propetyName.career.rawValue] as? [String]
            
            if career != nil{
                return career!.count
            }
            
            return 1
        case 4:
            let education = userDic[propetyName.education.rawValue]
            
            if education != nil{
                return 3
            }
            
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "detailUserCell") as! DetailUserTableViewCell
        
        let nilCell = UITableViewCell()
        nilCell.textLabel?.text = "-"
        nilCell.textLabel?.textColor = UIColor.gray
        
        switch indexPath.section {
        //基本情報
        case 0:
            let cell = myTableView.dequeueReusableCell(withIdentifier: "basicUserCell") as! BasicUserTableViewCell
            
            guard let id:String = userDic[propetyName.uuid.rawValue] as? String else { return nilCell }
            
            if let userimage = getImage(uuid: id){
                cell.userImageView.image = userimage
            }else{
                cell.userImageView.image = #imageLiteral(resourceName: "anonymous_43")
            }
            
            
            
//            cell.labelImageView.image = userData3[1] as? UIImage
//            cell.companyImageView.image = userData3[2] as? UIImage
            cell.nameLabel.text = userDic[propetyName.name.rawValue] as? String
            cell.positionLabel.text = userDic[propetyName.position.rawValue] as? String
            cell.companyNameLabel.text = userDic[propetyName.company_name.rawValue] as? String
            cell.messageLabel.text = userDic[propetyName.message.rawValue] as? String
            
            let birthDate = DateUtils.date(userDic[propetyName.birth.rawValue] as! String, format:"yyyy-MM-dd" )
            let age = DateUtils.age(byBirthDate: birthDate)
            cell.ageLabel.text = "(" + String(age) + ")"
            switch age {
            case 0..<30:
                cell.labelImageView.image = #imageLiteral(resourceName: "wakate-label")
            case 30..<45:
                cell.labelImageView.image = #imageLiteral(resourceName: "middle-label")
            default:
                cell.labelImageView.image = #imageLiteral(resourceName: "beteran-label")
            }
            
            removeAllChildView(parent: cell.ogoriView)
            
            if let skill:[String] = userDic[propetyName.skill.rawValue] as? [String]{
                pasteTag(forView: cell.experienceTagView, forTagList: skill, heightConstraint: cell.tagViewHeightConstraint)
            }
            
            
            
            var count:CGFloat = 0
            let ogoriRect = CGRect(x: 0, y: 0, width: cell.ogoriView.frame.height, height: cell.ogoriView.frame.height)
            let ogoriPadding:CGFloat = 5
            if userDic[propetyName.ogori.rawValue] != nil{
                for ogori in userDic[propetyName.ogori.rawValue] as! [Int]{
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
        //何をやってるのか
        case 1:
            //ダウンキャストしないとnil判定できない。
            //ダウンキャストしない場合、nsnullが入っており、判定が難しい
            
            let intro = userDic[propetyName.introduction.rawValue] as? String
            
            if intro == nil{
                return nilCell
            }
            
            //            cell.contentLabel.text = userDic["self_introduction"] as? String
            
            let cell = UITableViewCell()
            cell.textLabel?.text = intro
            cell.textLabel?.numberOfLines = 0
            
            return cell
            //経歴
        //case2
        case 2:
            let career = userDic[propetyName.career.rawValue] as? [[String]]
            
            if career == nil{
                return nilCell
            }
            
            let cell = myTableView.dequeueReusableCell(withIdentifier: "threeContentCell") as! ThreeContentTableViewCell
            //            for item in career!{
            //                cell.titleLabel1.text = item[indexPath.row]
            //            }
            cell.titleLabel1.text = career![indexPath.row][0]
            cell.titleLabel2.text = career![indexPath.row][1]
            
            let fromDate = DateUtils.date(career![indexPath.row][2], format: "YYYY-MM-dd")
            let fromYear = NSCalendar.current.component(.year, from: fromDate)
            let fromMonth = NSCalendar.current.component(.month, from: fromDate)
            
            let toDate = DateUtils.date(career![indexPath.row][3], format: "YYYY-MM-dd")
            let toYear = NSCalendar.current.component(.year, from: toDate)
            let toMonth = NSCalendar.current.component(.month, from: toDate)
            
            cell.titleLabel3.text = String(fromYear) + "年" + String(fromMonth) + "月 〜 " + String(toYear) + "年" + String(toMonth) + "月"
            
            return cell
            
            //学歴
        //case3
        case 3:
            
            let educationField = userDic[propetyName.education.rawValue] as? [Any]
            
            if educationField == nil{
                return nilCell
            }
            
            //            cell.contentLabel.text = userDic["message"] as? String
            
            let cell = myTableView.dequeueReusableCell(withIdentifier: "threeContentCell") as! ThreeContentTableViewCell
            cell.titleLabel1.text = educationField![0] as? String
            cell.titleLabel2.text = educationField![1] as! String + "学部"
            cell.titleLabel3.text = String(describing: educationField![2] as! Int) + "年卒"
            
            return cell
        //会社名
        case 4:
            if userDic[propetyName.company_name.rawValue] == nil{
                return nilCell
            }
            
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                
                cell.textLabel?.text = userDic[propetyName.company_name.rawValue] as? String
                //
                //                let link = ClickableTextView(frame: CGRect(x: cell.textLabel!.layer.position.x, y: cell.textLabel!.layer.position.y + 10, width: cell.textLabel!.frame.width, height: cell.textLabel!.frame.height))
                let link = ClickableTextView(frame: cell.textLabel!.frame)
                link.frame.size = CGSize(width: 200, height: 30)
                link.transform = CGAffineTransform(translationX: 0, y: cell.textLabel!.layer.position.y + 30)
                link.dataDetectorTypes = .link
                link.isEditable = false
                link.text = userDic[propetyName.company_link.rawValue] as? String
                cell.addSubview(link)
                
                let acell = myTableView.dequeueReusableCell(withIdentifier: "labelAndLinkCell") as! labelAndLinkTextViewTableViewCell
                acell.myLabel.text = userDic[propetyName.company_name.rawValue] as? String
                acell.linkTextView.text = userDic[propetyName.company_link.rawValue] as? String
                
                return acell
            case 1:
                
                let cell = myTableView.dequeueReusableCell(withIdentifier: "simpleCell") as! SimpleTableViewCell
                cell.titleLabel.text = "社員数"
                cell.contentLabel.text = String(describing:userDic[propetyName.company_population.rawValue] as? Int) + "人"
                
                return cell
            case 2:
                //                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
                //
                //
                //                cell.textLabel?.text = "業界"
                //                cell.detailTextLabel?.text = userDic["company_industry"] as? String ?? "-"
                
                let cell = myTableView.dequeueReusableCell(withIdentifier: "simpleCell") as! SimpleTableViewCell
                cell.titleLabel.text = "業界"
                cell.contentLabel.text = userDic[propetyName.company_industry.rawValue] as? String ?? "-"
                
                return cell
            default:
                return UITableViewCell()
            }
            
            
            
        //会社紹介
        case 5:
            if userDic[propetyName.company_introduction.rawValue] == nil{
                return nilCell
            }
            
            //            cell.contentLabel.text = userDic["company_introduction"] as? String
            
            let cell = UITableViewCell()
            cell.textLabel?.text = userDic[propetyName.company_introduction.rawValue] as? String
            cell.textLabel?.numberOfLines = 0
            return cell
            
        //会社特徴
        case 6:
            if userDic[propetyName.company_feature.rawValue] == nil{
                return nilCell
            }
            
            let cell = UITableViewCell()
            var str:String = ""
            
            let recruitmentArray:[String] = userDic[propetyName.company_feature.rawValue] as! [String]
            
            for text in recruitmentArray{
                if text == recruitmentArray.first{
                    str = text
                    continue
                }
                
                str += "/" + text
            }
            
            cell.textLabel?.text = str
            
            return cell
            
        //募集求人
        case 7:
            if userDic[propetyName.company_recruitment.rawValue] == nil{
                return nilCell
            }
            
            let cell = UITableViewCell()
            var str:String = ""
            
            let recruitmentArray:[String] = userDic[propetyName.company_recruitment.rawValue] as! [String]
            
            for text in recruitmentArray{
                if text == recruitmentArray.first{
                    str = text
                    continue
                }
                
                str += "/" + text
            }
            
            cell.textLabel?.text = str
            
            return cell
        default:
            
            return UITableViewCell()
        }
    }
    
    func removeAllChildView(parent:UIView){
        for subview in parent.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func pasteTag(forView targetView:UIView,forTagList TagList:[String],heightConstraint:NSLayoutConstraint){
        
        var pointX:CGFloat = 10
        var pointY:CGFloat = 10
        var lastHeight:CGFloat = 0
        
        for view in targetView.subviews{
            
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

    @IBAction func finishButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
