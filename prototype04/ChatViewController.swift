//
//  ChatViewController.swift
//  
//
//  Created by shoichiyamazaki on 2017/06/28.
//
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {

    
    var roomKey = "hogeKey"
    
    var messages:[JSQMessage] = []
    var senderImage:UIImage?
    var recieverId:String!
    var recieverImage:UIImage? = #imageLiteral(resourceName: "anonymous_43")
    var recieverInfo:[String:Any] = [:]
    var senderInfo:UserInfo = UserInfo()
    var navigationView:UIView!
    var backButton:UIButton!
    var navigationTitle:String = "hoge"
    var selectedRow = 0
    
    enum targetType{
        case sender
        case reciever
    }
    
    let udSetting:UserDefaultSetting = UserDefaultSetting()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.getKeyboardHeight(notification:)),
            name: NSNotification.Name.UIKeyboardDidShow,
            object: nil
        )
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*1.2)

        self.collectionView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imgFileName = "userimg.png"
        var tmp = UIImage(contentsOfFile: "\(documentDir)/\(imgFileName)")
        if tmp == nil{
            tmp = #imageLiteral(resourceName: "anonymous_43")
        }
        senderImage =  tmp
        recieverImage = getImage(uuid: recieverId)
        //ダミーデータ
        //マッチングのアルゴリズムがだめ
//        senderId = "hoge"
        
        // Do any additional setup after loading the view.
    }
    
    var keyboardheight:CGFloat!
    @objc func getKeyboardHeight(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardFrameInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                // キーボードの高さを取得
                keyboardheight = keyboardFrameInfo.cgRectValue.height
                print(keyboardFrameInfo.cgRectValue.height)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        showMessage(roomKey)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = navigationTitle
        
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "dots"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.callMethod), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
//        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "dots")
//        let parentVC = self.navigationController?.parent as! ContainerViewControllerTest
//        parentVC.navigationView.isHidden = true
        
    }
    
    @objc func callMethod(){
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "非表示にする", style: .default) { (action) in
            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
//            let newValue = app.messageList
//            app.messageList = newValue
            
            
            let alert:UIAlertController = UIAlertController(title: "このユーザーを非表示にしました", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let navC = self.navigationController!
                    self.dismiss(animated: true, completion: nil)
                    let vc = navC.viewControllers[navC.viewControllers.count-2] as! MessageViewControllerTest
                    let deletIndex = IndexPath(row: self.selectedRow, section: 0)
                    
                    vc.myTableView.beginUpdates()
                    app.messageList?.remove(at: deletIndex.row)
                    vc.cardList2?.remove(at: deletIndex.row)
                    vc.myTableView.deleteRows(at: [deletIndex], with: UITableViewRowAnimation.fade)
                    
                    
                    
//                    if app.messageList?.count == 0{
//                        vc.myTableView.deleteSections(deletIndex.section, with: UITableViewRowAnimation.fade)
//                    }
                    
                    vc.myTableView.endUpdates()
                    self.navigationController?.popViewController(animated: true)
                })
            })
//            let navC = self.navigationController!
//            let vc = navC.viewControllers[navC.viewControllers.count-2] as! MessageViewControllerTest
            
            
        }
        
        let annotationAction = UIAlertAction(title: "通報する", style: .destructive) { (action) in
            let alert:UIAlertController = UIAlertController(title: "このユーザーを通報しました", message: nil, preferredStyle: .alert)
            //サーバーにユーザー通報する処理
            let targetId:String = self.recieverId
            ServerConnection().report(targetId: targetId)
            
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(annotationAction)
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: self.view.bounds.midY, width: 0, height: 1)
        
        present(alert, animated: true, completion: nil)
    }
    
    func backView(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
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
//    override func scrollToBottom(animated: Bool) {
//        
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //read message
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    //imageの表示設定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 40, height: 40)
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 40, height: 40)
        
        if messages[indexPath.row].senderId == senderId{
            return JSQMessagesAvatarImageFactory.avatarImage(with: senderImage, diameter: 100)
        } else{
            return JSQMessagesAvatarImageFactory.avatarImage(with: recieverImage, diameter: 100)
        }
        //        return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: messages[indexPath.row].senderDisplayName, backgroundColor: UIColor.darkGray, textColor: UIColor.black, font: UIFont.systemFont(ofSize: 10), diameter: 30)
    }
    
    //set textColor
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell
        if messages[indexPath.row].senderId == senderId {
            cell?.textView.textColor = UIColor.black
        } else {
            cell?.textView.textColor = UIColor.black
        }
        return cell!
    }
    
    //メッセージの背景色
    //ここでメッセージがinかoutかを判定して、自分のメッセージか、相手のメッセージかを判別している。
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.row].senderId == senderId{
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.white)
        }else{
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.white)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
//        if indexPath.row == 0{
//            return 80
//        }
//        
        return 20
    }
    
    //Send Button
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
//        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)!
//        messages.append(message)
//        finishSendingMessage(animated: true)
//        self.inputToolbar.contentView.textView.resignFirstResponder()
        inputToolbar.contentView.textView.text = ""
        let ref = Database.database().reference()
    ref.child("rooms").child(roomKey).child("message").childByAutoId().setValue(["senderId":senderId,"text":text,"displayName":senderDisplayName,"date":[".sv":"timestamp"]])
       self.inputToolbar.contentView.textView.resignFirstResponder()
//        self.scrollToBottom(animated: true)
        
        
        if self.collectionView.contentSize.height + keyboardheight + inputToolbar.bounds.height > self.collectionView.frame.height {
            
            self.collectionView.setContentOffset(CGPoint(x:0,y:self.collectionView.contentSize.height + self.inputToolbar.bounds.height - keyboardheight), animated: true)
        }
//        if self.collectionView.contentSize.height > self.collectionView.frame.height {
//            self.collectionView.setContentOffset(
//                CGPoint(x: 0, y: self.collectionView.contentSize.height
//                    - self.collectionView.frame.height + self.inputToolbar.bounds.height),
//                animated: true)
//        }    }
    }
    
    
    func showMessage(_ roomKey:String){
        let ref = Database.database().reference()
        ref.child("rooms").child(roomKey).observe(.value, with: {snapshot in
            guard let dic = snapshot.value as? Dictionary<String,AnyObject> else {
                return
            }
            
            guard let posts = dic["message"] as? Dictionary<String,Dictionary<String,AnyObject>>else{
                return
            }
            
            var keyValueArray:[(String,Int)] = []
            for(key,value) in posts{
                keyValueArray.append((key:key,data:value["date"] as! Int))
            }
            
            keyValueArray.sort{$0.1 < $1.1}
            var preMessage = [JSQMessage]()
            
            
            for sortedTuple in keyValueArray{
                for(key, value) in posts {
                    if key == sortedTuple.0{
                        let senderId = value["senderId"] as! String
                        let text = value["text"] as! String
                        let displayName = value["displayName"] as! String
                        preMessage.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))
                    }
                }
            }
            
            
            self.messages = preMessage
            self.collectionView.reloadData()
        
        })
    }
    
    
    //画面中のアイテム数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
}
