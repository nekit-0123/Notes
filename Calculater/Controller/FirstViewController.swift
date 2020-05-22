//
//  FirstViewController.swift
//  Calculater
//
//  Created by Nikita Yudichev on 12.10.2019.
//  Copyright © 2019 Nikita Yudichev. All rights reserved.
//
import UIKit

enum Sign: Int
{
    case Plus = 0
    case Munus = 1
    case Multy = 2
    case Divide = 3
}


class FirstViewController: UIViewController
{
    var mySign = -1
    var isFirstCount: Bool = true
    var firstCount: Double? = nil
    
    @IBOutlet weak var Answer: UILabel!
    

    @IBOutlet var AllButtonRadius: [UIButton]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       

        for ButtonCollection in AllButtonRadius{
            ButtonCollection.layer.cornerRadius =
                ButtonCollection.frame.size.height / 2
            
            ButtonCollection.titleLabel?.font = UIFont(name: "Symbol", size: 30)
            
        }
    }
    
    
    func perlacePoint() -> String
    {
        return (Answer.text?.replacingOccurrences(of: ",", with: "."))!
    }
    
    
    
    func addCount(value: Character)
    {
        if (isFirstCount)
        {
            isFirstCount = false
            Answer.text?.removeAll()
        }
        
        Answer.text?.insert(value, at: Answer.text!.endIndex)
    }
    
    @IBAction func Button0(_ sender: UIButton)
    {
        addCount(value: "0")
    }
    
    @IBAction func Button1(_ sender: UIButton)
    {
        addCount(value: "1")
    }
    @IBAction func Button2(_ sender: UIButton)
    {
        addCount(value: "2")
    }
    @IBAction func Button3(_ sender: UIButton)
    {
         addCount(value: "3")
    }
    @IBAction func Button4(_ sender: UIButton)
    {
         addCount(value: "4")
    }
    
    @IBAction func Button5(_ sender: UIButton)
    {
        addCount(value: "5")
    }
    
    @IBAction func Button6(_ sender: UIButton)
    {
       addCount(value: "6")
    }
    
    @IBAction func Button7(_ sender: UIButton)
    {
        addCount(value: "7")
    }
    
    @IBAction func Button8(_ sender: UIButton)
    {
       addCount(value: "8")
    }
    
    @IBAction func Button9(_ sender: UIButton)
    {
        addCount(value: "9")
    }


    @IBAction func ButtonClear(_ sender: UIButton)
    {
        Answer.text = "0"
        isFirstCount = true
        firstCount = nil
        
    }
    
    @IBAction func ChangeSign(_ sender: UIButton)
    {
        if (Answer.text?.contains("-") != true)
        {
            Answer.text?.insert("-", at: Answer.text!.index(Answer.text!.startIndex, offsetBy: 0))
        }
        else
        {
            Answer.text?.remove(at: Answer.text!.index(Answer.text!.startIndex, offsetBy: 0))
            
        }
    }

    
    @IBAction func ButtonComma(_ sender: UIButton)
    {
        if (Answer.text?.contains(",") != true)
        {
            addCount(value: ",")
        }
    }
    
    
    
    @IBAction func ButtonPlus(_ sender: UIButton)
    {
        isFirstCount = true
        if let count = Double(perlacePoint())
        {
            if (firstCount == nil)
            {
                firstCount = count
                mySign = Sign.Plus.rawValue
                
            }
            else
            {
                Answer.text = String(format:"%f", firstCount! + count)
                firstCount = nil
            }
        }
    }
    
    @IBAction func ButtonMinus(_ sender: UIButton)
    {
        isFirstCount = true
        if let count = Double(perlacePoint())
        {
            if (firstCount == nil)
            {
                firstCount = count
                mySign = Sign.Munus.rawValue
                
            }
            else
            {
                Answer.text = String(format:"%f", firstCount! - count)
                firstCount = nil
            }
        }
    }
    
    @IBAction func ButtonMulti(_ sender: UIButton)
    {
        isFirstCount = true
        if let count = Double(perlacePoint())
        {
            if (firstCount == nil)
            {
                firstCount = count
                mySign = Sign.Multy.rawValue
            }
            else
            {
                Answer.text = String(format:"%f", firstCount! * count)
                firstCount = nil
            }
        }
    }
    
    
    @IBAction func ButtonDivide(_ sender: UIButton)
    {
        isFirstCount = true
        if let count = Double(perlacePoint())
        {
            if (firstCount == nil)
            {
                firstCount = count
                 mySign = Sign.Divide.rawValue
            }
            else
            {
                Answer.text = String(format:"%f", firstCount! / count)
                firstCount = nil
            }
        }
    }
    
    
    @IBAction func Procent(_ sender: UIButton)
    {
        if var count = Double(perlacePoint())
        {
            count = count / 100
            
              Answer.text = String(format:"%g", count)
        }
    }
    
    
    @IBAction func ButtonCount(_ sender: UIButton)
    {
        isFirstCount = true
        if (firstCount != nil)
        {
            if let count = Double(perlacePoint())
            {
                switch (mySign)
                {
                    
                case Sign.Plus.rawValue:
                  Answer.text = String(format:"%g", firstCount! + count)
                    
                    break
                case Sign.Munus.rawValue:
                    Answer.text = String(format:"%g", firstCount! - count)
                    
                    break
                case Sign.Multy.rawValue:
                    Answer.text = String(format:"%g", firstCount! * count)
                    
                    break
                case Sign.Divide.rawValue:
                    Answer.text = String(format:"%g", firstCount! / count)
                    break
                default:
                    break
                }
                
                mySign = -1
                firstCount = nil
            }
        }
    }
}


    


