//
//  RegisterMailViewController.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/08/11.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import UIKit
import Firebase
//メール登録する画面。Firebaseで管理
class RegisterMailViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate{

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var regiterButton: RectButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var annotationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        annotationTextView.delegate = self
        annotationTextView.textContainer.lineFragmentPadding = 0
        annotationTextView.textContainerInset = .zero
        
        let text = "プライバシーの扱いと利用規約について同意した上ご登録ください"
        let attributedString = NSMutableAttributedString(string: text)
        let privacyRange = NSString(string: text).range(of: "プライバシーの扱い")
        let termRange = NSString(string: text).range(of: "利用規約")
        attributedString.addAttribute(NSAttributedStringKey.link, value: "http://milenim.sakura.ne.jp/privacy/", range: privacyRange)
        attributedString.addAttribute(NSAttributedStringKey.link, value: "http://milenim.sakura.ne.jp/terms/", range: termRange)
        annotationTextView.attributedText = attributedString
        annotationTextView.textAlignment = NSTextAlignment.center
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        signUp()
        
    }
    
    func signUp(){
        let inputEmail = emailTextField.text
        let inputPassword = passwordTextField.text
        
        //Firebaseにメール認証でのユーザー登録をする
        Auth.auth().createUser(withEmail: inputEmail!, password: inputPassword!, completion: { (user, error) in
            if error == nil{
                user?.sendEmailVerification(completion: { (Error) in
                    if Error == nil{
                        //認証メール送信成功
                        self.RegisterUser()
                        self.performSegue(withIdentifier: "sendMailSegue", sender: nil)
                        
                    }else{
                        //認証メール送信失敗
                        //アラート表示
                        self.errorMessageLabel?.isHidden = false
                        self.errorMessageLabel?.text = "送信に失敗しました。通信状況を確認し、時間をおいて再度行ってください"
                        print(Error!.localizedDescription + "1")
                    }
                })
            }else{
                //ユーザー入力内容エラー
                //アラート表示
                
                if let error = error{
                    let nsError = error as NSError
                    
                    
                    switch nsError.code{
                    case 17007:
                        self.errorMessageLabel.text = "このアドレスはすでに登録されています"
                    case 17008:
                        self.errorMessageLabel.text = "無効なメールアドレスです"
                    case 17026:
                        self.errorMessageLabel.text = "パスワードは６文字以上で入力してください"
                    default:
                        break
                    }
                }
                
                self.errorMessageLabel?.isHidden = false
                
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendMailSegue"{
            let vc = segue.destination as! MailModalViewController
            vc.inputEmail = emailTextField.text!
        }
    }
    
    func RegisterUser(){
        guard let email = emailTextField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference()
        ref.child("users").child((Auth.auth().currentUser?.uid)!).setValue(["UUID":uid,"CreateDate":ServerValue.timestamp(),"email":email,"valid":false])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
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
