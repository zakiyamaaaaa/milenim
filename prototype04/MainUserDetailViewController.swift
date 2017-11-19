//
//  MainUserDetailViewController.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/07/28.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit

class MainUserDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var myTableView: UITableView!
    
//    let sectionTitle = ["","何をやっているのか","経歴","学歴","会社情報","会社紹介","特徴","募集求人"]
    let sectionTitle = ["","自己紹介","会社情報"]
    let titleOfSection1 = ["何をやっているか","学歴"]
    let titleOfSection2 = ["会社名","規模","業界","特徴","採用"]
    let pickerValue = ["スタートアップ","中小企業","大企業","官公庁","その他"]
    
    var userData2:userData!
    var userDic:[String:Any]!
    
    let recruiterPropetry = recruiterPropety.self
    
    @IBOutlet weak var tagViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        
//        userData2 = userData(id: "aaa", name: "takashi", birth: Date(), companyName: nil, positioin: nil, skill: nil, ogori: nil, message: nil, selfIntro: nil, companyId: nil, numberOfCompany: nil, industry: nil, career: nil, companyIntro: nil, companyFeature: nil, recruitment: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = userDic["name"] as? String
        myTableView.estimatedRowHeight = 90
        myTableView.reloadData()
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
        case 0:
            return 1
        case 1:
            return titleOfSection1.count
        case 2:
            return titleOfSection2.count
        default:
            return 0
        }
        
//        switch section {
//        case 3:
//            let career = userDic[recruiterPropety.career.rawValue] as? [String]
//            
//            if career != nil{
//                return career!.count
//            }
//            
//            return 1
//        case 4:
//            let education = userDic[recruiterPropety.education.rawValue]
//            
//            if education != nil{
//                return 3
//            }
//            
//            return 1
//        default:
//            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
        
        let nilCell = UITableViewCell()
        nilCell.textLabel?.text = "-"
        nilCell.textLabel?.textColor = UIColor.gray
        
        switch indexPath.section {
        //基本情報
        case 0:
            let cell = myTableView.dequeueReusableCell(withIdentifier: "basicUserCell") as! BasicUserTableViewCell
            
            guard let id:String = userDic[recruiterPropety.uuid.rawValue] as? String else { return nilCell }
            
            if let userimage = getImage(uuid: id){
                cell.userImageView.image = userimage
            }else{
                cell.userImageView.image = #imageLiteral(resourceName: "anonymous_43")
            }
            
//            cell.labelImageView.image = userData3[1] as? UIImage
//            cell.companyImageView.image = userData3[2] as? UIImage
            cell.nameLabel.text = userDic[recruiterPropety.name.rawValue] as? String
            cell.positionLabel.text = userDic[recruiterPropety.position.rawValue] as? String
            cell.companyNameLabel.text = userDic[recruiterPropety.company_name.rawValue] as? String
            cell.messageLabel.text = userDic[recruiterPropety.message.rawValue] as? String
            
            if let flag = userDic[recruiterPropety.anonymous.rawValue] as? Bool{
                if flag == true{
                    cell.companyNameLabel.text = "非公開"
//                    card1CompanyLink.text = "非公開"
                }
            }
            
            if let birth = userDic[recruiterPropety.birth.rawValue] as? String{
                let birthDate = DateUtils.date(birth, format:"yyyy-MM-dd" )
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
                cell.ageLabel.font = UIFont.systemFont(ofSize: 17)
            }else{
                cell.ageLabel.text = "年齢未設定"
                cell.ageLabel.font = UIFont.systemFont(ofSize: 13)
                cell.labelImageView.image = #imageLiteral(resourceName: "misettei-label")
            }
            
            
            removeAllChildView(parent: cell.ogoriView)
            
            if let skill:[String] = userDic[recruiterPropety.skill.rawValue] as? [String]{
                    pasteTag(forView: cell.experienceTagView, forTagList: skill, heightConstraint: cell.tagViewHeightConstraint)
            }
            
            
            
            var count:CGFloat = 0
            let ogoriRect = CGRect(x: 0, y: 0, width: cell.ogoriView.frame.height, height: cell.ogoriView.frame.height)
            let ogoriPadding:CGFloat = 5
            if userDic[recruiterPropety.ogori.rawValue] != nil{
                if userDic[recruiterPropety.ogori.rawValue] is NSNull == false{
                    for ogori in userDic[recruiterPropety.ogori.rawValue] as! [Int]{
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
                
            }
            
            return cell
        //何をやってるのか
        case 1:
            //ダウンキャストしないとnil判定できない。
            //ダウンキャストしない場合、nsnullが入っており、判定が難しい
            let cell = myTableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.titleLabel.text = titleOfSection1[indexPath.row]
            switch indexPath.row {
            case 0:
                if let intro = userDic[recruiterPropety.introduction.rawValue] as? String{
                    cell.conetntLabel.text = intro
                }else{
                    cell.conetntLabel.text = "-"
                }
                
            case 1:
                //学歴
                if let education = userDic[recruiterPropetry.education.rawValue] as? [Any]{
                    if let schoolname = education[0] as? String,let faculty = education[1] as? String,let year = education[2] as? Int{
                        cell.conetntLabel.text = schoolname + faculty + String(describing: year) + "年卒"
                    }
                }
                
            default:
                break
            }
            return cell
        //経歴
        //case2
        case 2:
            //会社名
            //会社規模
            //業界
            //特徴
            //採用
            
            
            
            let cell = myTableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.titleLabel.text = titleOfSection2[indexPath.row]
            
            switch indexPath.row {
            case 0:
                if let companyName = userDic[recruiterPropetry.company_name.rawValue] as? String{
                    cell.conetntLabel.text = companyName
                }else{
                    cell.conetntLabel.text = "-"
                }
                
                if let anonymousFlag = userDic[recruiterPropety.anonymous.rawValue] as? Bool{
                    if anonymousFlag == true{
                        cell.conetntLabel.text = "会社名非公開"
                    }
                }
                
            case 1:
                if let companyPopulation = userDic[recruiterPropetry.company_population.rawValue] as? Int{
                    cell.conetntLabel.text = pickerValue[companyPopulation]
                }else{
                    cell.conetntLabel.text = "-"
                }
            case 2:
                if let industry = userDic[recruiterPropetry.company_industry.rawValue] as? String{
                    cell.conetntLabel.text = industry
                }else{
                    cell.conetntLabel.text = "-"
                }
            case 3:
                if let feature = userDic[recruiterPropetry.company_feature.rawValue] as? [String]{
                    cell.conetntLabel.text = feature.first
                }else{
                    cell.conetntLabel.text = "-"
                }
            case 4:
                if let recruitment = userDic[recruiterPropetry.company_recruitment.rawValue] as? [String]{
                    cell.conetntLabel.text = recruitment.first
                }else{
                    cell.conetntLabel.text = "-"
                }
                
            default:
                break
            }
            return cell
//            let career = userDic[recruiterPropety.career.rawValue] as? [[String]]
//            
//            if career == nil{
//                return nilCell
//            }
            default:
            break
        }
        
        return cell
        
    }
    
    func removeAllChildView(parent:UIView){
        for subview in parent.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            
            
            if pointX + tagLabel.frame.width + 5 > targetView.frame.width{
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

    @IBAction func notInterestingButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func InterestingButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let annotationAction = UIAlertAction(title: "通報する", style: .destructive) { (action) in
            let alert:UIAlertController = UIAlertController(title: "このユーザーを通報しました", message: nil, preferredStyle: .alert)
            //サーバーにユーザー通報する処理
            let targetId:String = self.userDic["uuid"] as! String
            ServerConnection().report(targetId: targetId)
            
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(annotationAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: self.view.bounds.midY, width: 0, height: 1)
        present(alert, animated: true, completion: nil)
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
