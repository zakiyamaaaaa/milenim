//
//  MainViewControllerTest.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/07/28.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit

//カードメインの部分
class MainViewControllerTest: UIViewController {
    @IBOutlet weak var cardView01: UserCard!
    
    @IBOutlet weak var card1UserYeartoWorkLabel: UILabel!
    @IBOutlet weak var card1UserNameLabel: UILabel!
    @IBOutlet weak var card1UserJobLabel: UILabel!
    @IBOutlet weak var card1CompanyLogoImageView: UIImageView!
    @IBOutlet weak var card1experienceTagViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var card1CompanyLink: ClickableTextView!
    @IBOutlet weak var card1CompanyNameLabel: UILabel!
    @IBOutlet weak var card1AgeLabel: UILabel!
    @IBOutlet weak var card1LabelImageView: UIImageView!
    @IBOutlet weak var card1UserImageView: UIImageView!
    @IBOutlet weak var card1FormerJobLabel: UILabel!
    @IBOutlet weak var card2UserYeartoWorkLabel: UILabel!
    @IBOutlet weak var user2ImageView: UIImageView!
    @IBOutlet weak var card1OgoriView: UIView!
    @IBOutlet weak var card1MessageLabel: UILabel!
    
    @IBOutlet weak var card2experienceTagViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var card2FormerJobLabel: UILabel!
    @IBOutlet weak var card2MessageLabel: UILabel!
    @IBOutlet weak var card2CompanyLink: ClickableTextView!
    @IBOutlet weak var card2CompanyNameLabel: UILabel!
    @IBOutlet weak var card2UserImageView: UIImageView!
    @IBOutlet weak var card1TagViewTitleLabel: UILabel!
    
    @IBOutlet weak var card2TagViewTitleLabel: UILabel!
    @IBOutlet weak var card2LabelImageView: UIImageView!
    
    
    @IBOutlet weak var card2OgoriView: UIView!
    @IBOutlet weak var card2AgeLabel: UILabel!
    @IBOutlet weak var card2UserNameLabel: UILabel!
    @IBOutlet weak var card2CompanyLogoImageView: UIImageView!
    @IBOutlet weak var card2UserJobLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var matcingView: UIView!
    @IBOutlet weak var user1ImageView: UIImageView!
    
    @IBOutlet weak var ogoriView: UIView!
    //Main---------------------------------------------------------------------
    var locationBySnap:CGPoint!
    var userViewDefaultLocation:CGPoint!
    
    
    @IBOutlet weak var throwButton: UIButton!
    @IBOutlet weak var interstingButton: UIButton!
    
    
    @IBOutlet weak var cardView02: UserCard!
    
    @IBOutlet weak var judgeButton: UIView!
    

    @IBOutlet weak var card1ExperienceTagView: RectView!
    
    @IBOutlet weak var card2ExperienceTagView: RectView!
    
    var currentShowUserData:userData!
    
    var snapAnimator:UIDynamicAnimator!
    var pushAnimator:UIDynamicAnimator!
    var pushBehavior:UIPushBehavior!
    var snapBehavior:UISnapBehavior!
    
//    var cardList:[[Any]] = []
    let properthName = recruiterPropety.self
    
    @IBOutlet weak var interestingButton: RectButton!
    @IBOutlet weak var cancelButton: RectButton!
    
    
    var cardList2:[Any] = []
    var annotationFlag = false
    var myStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if User().status != nil{
            myStatus = User().status!
        }
        
        if myStatus == 1{
            card1TagViewTitleLabel.text = "興味・関心"
            card2TagViewTitleLabel.text = "興味・関心"
        }
        
        annotationFlag = true
        //マッチングしたときのビュー、透過してる
        
        
        //LocationViewで取得したcardList
        //ここにいれたものが表示される
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        cardList2 = app.cardListDelegate!
        
        
        let tappedImageGesrute1 = UITapGestureRecognizer(target: self, action: #selector(self.tappedCard(gestureRecognizer:)))
        let tappedImageGesrute2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedCard(gestureRecognizer:)))
        cardView01.addGestureRecognizer(tappedImageGesrute1)
        cardView02.addGestureRecognizer(tappedImageGesrute2)
        card1CompanyLogoImageView.layer.borderWidth = 0.5
        card2CompanyLogoImageView.layer.borderWidth = 0.5
        
        //ViewのSnap動き関係-------------------------------------------------------------------
        userViewDefaultLocation = CGPoint(x: cardView01.center.x, y: self.view.frame.height/2)
        locationBySnap = CGPoint(x: self.view.center.x, y: self.view.frame.height/2 - 40)
        
        let choiceGestureRecogizer = UIPanGestureRecognizer(target: self, action: #selector(self.choiceGesture(sender:)))
        cardView01.isUserInteractionEnabled = true
        cardView01.addGestureRecognizer(choiceGestureRecogizer)
        snapAnimator = UIDynamicAnimator(referenceView: self.view)
        pushAnimator = UIDynamicAnimator(referenceView: self.view)
        pushBehavior = UIPushBehavior(items: [cardView01], mode: UIPushBehaviorMode.continuous)
        
        
        cardView01.numberOfOage = 0
        cardView02.numberOfOage = 1
        
        updateCard(target: cardView01)
        updateCard(target: cardView02)
        updateDetailCardTag(targetView: cardView01)
        currentCard = cardView01
        
        self.view.sendSubview(toBack: self.cardView02)
        cardView02.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if ProfileEdited().calcurateRatio(status: myStatus) < 30 && annotationFlag == true{
            performSegue(withIdentifier: "popProfileSegue", sender: nil)
            annotationFlag = false
        }
        
        if cardList2.isEmpty == true{
            performSegue(withIdentifier: "noUserSegue", sender: nil)
        }
    }
    
        
    @objc func tappedCard(gestureRecognizer:UITapGestureRecognizer){
        
        switch myStatus {
        case 1:
            performSegue(withIdentifier: "studentDetailSegue", sender: nil)
        case 2:
            performSegue(withIdentifier: "showDetailSegue", sender: nil)
        default:
            break
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popProfileSegue"{
            let vc = segue.destination as! ProfileAnnotationViewController
            vc.num = ProfileEdited().calcurateRatio(status: myStatus)
        }
        
        
        if segue.identifier == "showDetailSegue"{
            let vc = segue.destination as! MainUserDetailViewController
            let list = cardList2[currentPage] as! [String:Any]
            vc.userDic = list
            
        }
        
        if segue.identifier == "studentDetailSegue"{
            let vc = segue.destination as! DetailStudentViewControllerTest
            let list = cardList2[currentPage] as! [String:Any]
            vc.dummyUser = list
        }
        
        if segue.identifier == "matchingSegue"{
//            let userInfo = cardList2[currentPage] as! [String:Any]
            let vc = segue.destination as! MatchingViewController
            vc.image2 = getImage(uuid: matchingUUID)
            
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //ビューとタグを指定して、タグフィールドを作る
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
    
    
    //★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
    //gesture関係-----------------------------------------------------------------
    @objc func choiceGesture(sender:UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            snapAnimator.removeAllBehaviors()
            print("began")
        case .changed:
            
            let moveValue:CGPoint = sender.translation(in: view)
            sender.view!.center.x += moveValue.x
            sender.view!.center.y += moveValue.y
            sender.setTranslation(CGPoint.zero, in: view)
            
        case .ended:
            print("ended")
            
            
            if fabs(sender.velocity(in: view).x) > 300{
                
                let velX = sender.velocity(in: view).x
                let velY = sender.velocity(in: view).y
                
                pushBehavior.pushDirection = CGVector(dx: velX, dy: velY)
                pushAnimator.addBehavior(pushBehavior)
                
                //左スワイプなら画面もどる
                //右スワイプなら、アプリをスタートする
                
                
                var swipeDirection:direction
                if sender.velocity(in: view).x > 0{
                    swipeDirection = .right
                    print("right swipe")
                    
                    
                }else{
                    print("left swipe")
                    swipeDirection = .left
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    //                    self.swipeHandler(swipedView: sender.view as! UserCard, direction: swipeDirection)
                    
                    self.swipedEvent(sender: sender.view as! UserCard, direction: swipeDirection)
                    self.moveCard(swipedView: sender.view as! UserCard)
                    
                })
                
            }else{
                snapBehavior = UISnapBehavior(item: sender.view!, snapTo: locationBySnap!)
                snapAnimator.addBehavior(snapBehavior!)
            }
        default:
            break
        }
        
    }
    let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var matchingUUID:String = ""
    func swipedEvent(sender:UserCard,direction:direction){
        
        let myID = User().uuid
        
        var matchingList = app.myInfoDelegate?[properthName.matched.rawValue] as? [[String]]
        let cardInfo:[String:Any] = cardList2[currentPage] as! [String:Any]
        
        
        //相手のuuid
        let uid = cardInfo[properthName.uuid.rawValue] as! String
        SwipeResultManager.shared.encounteredUser.append(uid)
        
        if direction == .right{
//            var myLikeList:[String]? = User().liked
//            myLikeList?.append(uid)
//            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            app.myInfoDelegate?["liked"] = myLikeList
            
            //相手のLikeリスト
            
            SwipeResultManager.shared.likedUser.append(uid)
            let likedList:[String]? = cardInfo[properthName.liked.rawValue] as? [String]
            
            
            //Likeリストに追加
//            if myLikeList != nil{
//                
//                myLikeList?.append(uid)
//                
//            }else{
//                app.myInfoDelegate?[recruiterPropety.liked.rawValue] = uid
//            }
            
            
            
            //マッチングイベント
            if likedList?.contains(myID!) == true{
                let roomKey = NSUUID.init().uuidString
                let now = Date()
                self.matchingUUID = uid
                matchingList?.append([uid,roomKey,String(describing: now)])
                //ここでマッチング相手にもキーの情報などを渡している
                self.notifyMathcing(matghingUserID: uid, data: [myID!,roomKey,String(describing: now)])
                self.app.myInfoDelegate?[self.properthName.matched.rawValue] = matchingList
                
                if self.app.messageList == nil{
                    self.app.messageList = []
                }
                
                //なぜかインサートすると、前のセルが残る。おそらく、新しく追加されたセルのデータが更新される感じなので、前にあったセルはそのまま再利用されるため？
                
                app.messageList?.insert(cardInfo, at: 0)
//                self.app.messageList?.inse(cardInfo)
                //なぜかmatchingViewをdismissからunwindに変えたら、messageVCのviewwillが使えなくなったので、こちらで操作している
                let nav = self.parent?.childViewControllers.last as! UINavigationController
                let vc = nav.childViewControllers.first as! MessageViewControllerTest
                
                
                vc.cardList2 = self.app.messageList
                vc.noMatchingUserImageView.isHidden = true
                vc.myMatchingList = matchingList
                vc.myTableView.reloadData()
                
                
                
//                vc.myTableView.reloadRows(at: vc.myTableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.fade)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    
                    self.performSegue(withIdentifier: "matchingSegue", sender: nil)
                    
                })
            }
            
            
            
        }
        
        //encounterdに追加
//        if app.myInfoDelegate![recruiterPropety.encounterd.rawValue] != nil{
//            
//            let uid = cardInfo[properthName.uuid.rawValue] as! String
//            var list:[String] = app.myInfoDelegate?[properthName.encounterd.rawValue] as! [String]
//            list.append(uid)
//            app.myInfoDelegate![recruiterPropety.encounterd.rawValue] = list
//            
//        }else{
//            app.myInfoDelegate?[recruiterPropety.encounterd.rawValue] = cardInfo[properthName.uuid.rawValue]
//        }
        
    }
    
    
    
    var currentPage:Int = 0
    //スワイプされたときのカードの入れ替え
    var currentCard:UserCard!
    
    func moveCard(swipedView:UserCard){
        
        currentPage += 1
        
        
        ("number of page:\(swipedView.numberOfOage)")
        swipedView.numberOfOage += 2
        let toBackView = swipedView
        var toFrontView:UserCard!
        switch swipedView {
        case cardView01:
            toFrontView = cardView02
        case cardView02:
            toFrontView = cardView01
        default:
            break
        }
        
        currentCard = toFrontView
        
        toBackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        pushBehavior.removeItem(toBackView)
        pushBehavior = UIPushBehavior(items: [toFrontView], mode: UIPushBehaviorMode.continuous)
        let choicePanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.choiceGesture(sender:)))
        toFrontView.isUserInteractionEnabled = true
        toBackView.isUserInteractionEnabled = false
        toFrontView.addGestureRecognizer(choicePanRecognizer)
        self.view.bringSubview(toFront: toFrontView)
        self.view.bringSubview(toFront: cancelButton)
        self.view.bringSubview(toFront: interestingButton)
        
        UIView.animate(withDuration: 1) {
            toFrontView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        toBackView.layer.position = userViewDefaultLocation
        updateDetailCardTag(targetView: toFrontView)
        updateCard(target: swipedView)
    }
    
    
    func updateCard(target:UserCard){
        
        
        //numberofpageがoutofrangeになったら、やめる
        if target.numberOfOage == cardList2.endIndex{
            
            target.isHidden = true
            return
        }
        
        if target.numberOfOage > cardList2.endIndex{
            performSegue(withIdentifier: "noUserSegue", sender: nil)
            return
        }
        
        
        guard let userInfo:[String:Any] = cardList2[target.numberOfOage] as? [String : Any] else { return }
        let list = cardList2[target.numberOfOage] as! [String:Any]
        
        let ogoriRect = CGRect(x: 0, y: 0, width: card1OgoriView.frame.height, height: card1OgoriView.frame.height)
        let ogoriPadding:CGFloat = 5
        
        switch target {
        case cardView01:
            card1UserNameLabel.text = userInfo[properthName.name.rawValue] as? String
            if let userimage = getImage(uuid: userInfo[properthName.uuid.rawValue] as! String){
                card1UserImageView.image = userimage
            }else{
                card1UserImageView.image = #imageLiteral(resourceName: "anonymous_43")
            }
            
            var birthDate:Date?
            if let birth = userInfo[properthName.birth.rawValue] as? String{
                birthDate = DateUtils.date(birth, format:"yyyy-MM-dd" )
                let age = DateUtils.age(byBirthDate: birthDate!)
                card1AgeLabel.text = "(" + String(age) + ")"
                card1AgeLabel.font = UIFont.systemFont(ofSize: 17)
            }else{
                card1AgeLabel.font = UIFont.systemFont(ofSize: 13)
                card1AgeLabel.text = "年齢未設定"
            }
            
            card1MessageLabel.text = userInfo[properthName.message.rawValue] as? String
            removeFromAllChildView(parentView: card1OgoriView)
            
            switch myStatus {
            case 1:
                card1LabelImageView.image = #imageLiteral(resourceName: "shinsotsu-label")
                
                card1CompanyLink.isHidden = true
                card1CompanyNameLabel.isHidden = true
                
                
                
                if let education:[Any] = userInfo[studentPropety.education.rawValue] as? [Any]{
                    if let schoolName = education[0] as? String{
                        card1UserJobLabel.text = schoolName
                        if let faculty = education[1] as? String{
                            
                            card1UserJobLabel.text = schoolName + "\n" + faculty
                            
                            if let graduation = education[2] as? Int{
                                
                                card1UserJobLabel.text = schoolName + "\n" + faculty + "\n" + String(describing: graduation) + "年卒"
                                
                            }
                            
                        }
                    }
                    
                    
                }
                
                if let interesting = userInfo[studentPropety.interesting.rawValue]{
                pasteTag(forView: card1ExperienceTagView, forTagList: interesting as! [String], heightConstraint: card1experienceTagViewHeightConstraint)
                }
                
            case 2:
//                let age = DateUtils.age(byBirthDate: birthDate)
//                card1AgeLabel.text = "(" + String(age) + ")"
                
                if let birth = birthDate{
                    let age = DateUtils.age(byBirthDate: birth)
                    switch age {
                    case 0..<30:
                        card1LabelImageView.image = #imageLiteral(resourceName: "wakate-label")
                    case 30..<45:
                        card1LabelImageView.image = #imageLiteral(resourceName: "middle-label")
                    default:
                        card1LabelImageView.image = #imageLiteral(resourceName: "beteran-label")
                    }
                }else{
                    //未設定の場合のラベル
                    card1LabelImageView.image = #imageLiteral(resourceName: "misettei-label")
                }
                
                card1CompanyNameLabel.text = userInfo[recruiterPropety.company_name.rawValue] as? String
                card1UserJobLabel.text = userInfo[recruiterPropety.position.rawValue] as? String
                card1CompanyLink.text = userInfo[recruiterPropety.company_link.rawValue] as? String
                if let skillList = userInfo[recruiterPropety.skill.rawValue] as? [String]{
                    pasteTag(forView: card1ExperienceTagView, forTagList: skillList, heightConstraint: card1experienceTagViewHeightConstraint)
                }
                
                var count:CGFloat = 0
                
                if let flag = userInfo[recruiterPropety.anonymous.rawValue] as? Bool{
                    if flag == true{
                        card1CompanyNameLabel.text = "会社名非公開"
                        card1CompanyLink.text = ""
                    }
                }
                
                if userInfo[recruiterPropety.ogori.rawValue] != nil{
                    if userInfo[recruiterPropety.ogori.rawValue] is NSNull == false{
                        for ogori in userInfo[recruiterPropety.ogori.rawValue] as! [Int]{
                            let ogoriImageView = UIImageView(frame: ogoriRect)
                            card1OgoriView.addSubview(ogoriImageView)
                            switch ogori {
                            case 0:
                                ogoriImageView.image =  #imageLiteral(resourceName: "morning_rect")
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
                
                
            default:
                break
            }
            
        case cardView02:
            card2UserNameLabel.text = userInfo[properthName.name.rawValue] as? String
            if let userimage = getImage(uuid: userInfo[properthName.uuid.rawValue] as! String){
                card2UserImageView.image = userimage
            }else{
                card2UserImageView.image = #imageLiteral(resourceName: "anonymous_43")
            }
            var birthDate:Date?
            if let birth = userInfo[properthName.birth.rawValue] as? String{
                birthDate = DateUtils.date(birth, format:"yyyy-MM-dd" )
                let age = DateUtils.age(byBirthDate: birthDate!)
                card2AgeLabel.text = "(" + String(age) + ")"
                card2AgeLabel.font = UIFont.systemFont(ofSize: 17)
            }else{
                card2AgeLabel.font = UIFont.systemFont(ofSize: 13)
                card2AgeLabel.text = "未設定"
            }
            
            card2MessageLabel.text = userInfo[properthName.message.rawValue] as? String
            removeFromAllChildView(parentView: card2OgoriView)
            
            switch myStatus {
            case 1:
                
                card2LabelImageView.image = #imageLiteral(resourceName: "shinsotsu-label")
                card2CompanyLink.isHidden = true
                card2CompanyNameLabel.isHidden = true
                
                if let education:[Any] = userInfo[studentPropety.education.rawValue] as? [Any]{
                    if let schoolName = education[0] as? String{
                        card2UserJobLabel.text = schoolName
                        if let faculty = education[1] as? String{
                            
                            card2UserJobLabel.text = schoolName + "\n" + faculty
                            
                            if let graduation = education[2] as? Int{
                                
                                card2UserJobLabel.text = schoolName + "\n" + faculty + "\n" + String(describing: graduation) + "年卒"
                                
                            }
                            
                        }
                    }
                    
                    
                }
                
                if let interesting = userInfo[studentPropety.interesting.rawValue]{
                    pasteTag(forView: card2ExperienceTagView, forTagList: interesting as! [String], heightConstraint: card2experienceTagViewHeightConstraint)
                }
                
            case 2:
                
                if let birth = birthDate{
                    let age = DateUtils.age(byBirthDate: birth)
                    switch age {
                    case 0..<30:
                        card2LabelImageView.image = #imageLiteral(resourceName: "wakate-label")
                    case 30..<45:
                        card2LabelImageView.image = #imageLiteral(resourceName: "middle-label")
                    default:
                        card2LabelImageView.image = #imageLiteral(resourceName: "beteran-label")
                    }
                }else{
                    //未設定の場合のラベル
                    card1LabelImageView.image = #imageLiteral(resourceName: "misettei-label")
                }
                
                
                card2CompanyNameLabel.text = userInfo[recruiterPropety.company_name.rawValue] as? String
                card2UserJobLabel.text = userInfo[recruiterPropety.position.rawValue] as? String
                card2CompanyLink.text = userInfo[recruiterPropety.company_link.rawValue] as? String
                
                if let skillList = userInfo[recruiterPropety.skill.rawValue] as? [String]{
                    pasteTag(forView: card2ExperienceTagView, forTagList: skillList, heightConstraint: card2experienceTagViewHeightConstraint)
                }
                
                if let flag = userInfo[recruiterPropety.anonymous.rawValue] as? Bool{
                    
                    if flag == true{
                        card2CompanyNameLabel.text = "非公開"
                        card2CompanyLink.text = "非公開"
                    }
                }
                
                var count:CGFloat = 0
                
                if userInfo[recruiterPropety.ogori.rawValue] != nil{
                    if userInfo[recruiterPropety.ogori.rawValue] is NSNull == false{
                        for ogori in userInfo[recruiterPropety.ogori.rawValue] as! [Int]{
                            let ogoriImageView = UIImageView(frame: ogoriRect)
                            card2OgoriView.addSubview(ogoriImageView)
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
            default:
                break
            }
        default:
            break
        }
    }
    
    func removeFromAllChildView(parentView:UIView){
        for subview in parentView.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func updateDetailCardTag(targetView:UserCard){
        
    }
    
    @IBAction func closeMatcingView(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.matcingView.alpha = 0
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let vc = self.parent as! ContainerViewControllerTest
            vc.navigationView.isHidden = false
            self.matcingView.isHidden = true
        }
    }
    @IBAction func returnToTop(segue: UIStoryboardSegue) {
        
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
        if img == nil{
            img = #imageLiteral(resourceName: "anonymous_43")
        }
        
        return img
    }
    
    //左スワイプと同じ処理
    @IBAction func cancelButtonTapped(_ sender: RectButton) {
        let velX = -300
        let velY = 0
        
        pushBehavior.pushDirection = CGVector(dx: velX, dy: velY)
        pushAnimator.addBehavior(pushBehavior)
        
        print("left swipe")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        
            self.swipedEvent(sender: self.currentCard, direction: .left)
            self.moveCard(swipedView: self.currentCard)
        })
    }
    
    //チェックボタンをおした時の挙動
    //右スワイプと同じ処理
    @IBAction func interestingButtonTapped(_ sender: RectButton) {
        
        let velX = 300
        let velY = 0
        
        pushBehavior.pushDirection = CGVector(dx: velX, dy: velY)
        pushAnimator.addBehavior(pushBehavior)
        
        print("right swipe")

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            //                    self.swipeHandler(swipedView: sender.view as! UserCard, direction: swipeDirection)
            
            self.swipedEvent(sender: self.currentCard, direction: .right)
            self.moveCard(swipedView: self.currentCard)
        
        })
    }
    
    func notifyMathcing(matghingUserID:String,data:[String]){
        
        //myData Field
        //uuid,status,matching[uuid,key,time]
        
        let status = myStatus
        
        let postData:[String:Any] = ["uuid":matghingUserID,"status":status,"data":data]
        let updateLocationURL = URL(string: "http://52.163.126.71:80/test/notifyMatching.php")
//        let updateLocationURL = URL(string: "http://localhost:8888/test/notifyMatching.php")
        var request = URLRequest(url: updateLocationURL!)
        
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                print("res:\(response!)")
                print("data:\(String(data:data!,encoding:.utf8))")
            })
            task.resume()
        }catch{
            print("error:\(error.localizedDescription)")
            //            return errorData
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
