//
//  SecondViewController.swift
//  Calculater
//
//  Created by Nikita Yudichev on 12.10.2019.
//  Copyright © 2019 Nikita Yudichev. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    var _blockSecondShift = true
    
    @IBOutlet var Scroll: UIScrollView!
    let segueIdentifier = "tasksSegue"
    var ref: DatabaseReference!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warnLabel: UILabel!

    
    @IBOutlet weak var WarningLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        WarningLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener( { [weak self] (auth, user) in
            if (user != nil)
            {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        })
        
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        Scroll.addGestureRecognizer(recognizer)
    }
    
    
    @objc func touch()
    {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    @objc func kbDidShow(notification : Notification)
    {
        if (!_blockSecondShift)
        {
            return
        }
        
        _blockSecondShift = false
        
       guard let userInfo = notification.userInfo
        else {return}
        
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
            (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height/2)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
        
        
        let bottomOffset = CGPoint(x: 0, y:  (self.view as! UIScrollView).contentSize.height -  (self.view as! UIScrollView).bounds.size.height)
         (self.view as! UIScrollView).setContentOffset(bottomOffset, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        _blockSecondShift = true
        self.view.endEditing(true)
    }

    
    
    @objc func kbDidHide()
    {
        _blockSecondShift = true
        
        (self.view as! UIScrollView).setContentOffset(.zero, animated:true)
    
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
    }
    
    @objc func fireTimer() {
       (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    func displayWarnLabel(text : String)
    {
        WarningLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
            self?.WarningLabel.alpha = 1
        }) { [weak self] complete in
            self?.WarningLabel.alpha = 0
        }
    }
    
    
    @IBAction func ButtonLogin(_ sender: UIButton)
    {
        guard let email = emailTextField.text, let password = passwordTextField.text,
        email != "", password != ""
        else
        {
            displayWarnLabel(text: "Неккоректные данные")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self](user, error) in
            if error != nil
            {
                self?.displayWarnLabel(text: "Ошибка")
                return
            }
            
            if (user != nil)
            {
                self?.appDelegate?.sceduleNotification(notificationType: "Go home ")
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
                return
            }
            
            self?.displayWarnLabel(text: "Пользователь не найден")
            
        })
    }
    

    @IBAction func ButtonRegister(_ sender: UIButton)
    {
        guard let email = emailTextField.text, let password = passwordTextField.text,
            email != "", password != ""
            else
        {
            displayWarnLabel(text: "Некорректные данные")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] (user, error) in
            
            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child((user?.user.uid)!)
            
            userRef?.setValue(["email": user?.user.email])
        })
        
    }
}

