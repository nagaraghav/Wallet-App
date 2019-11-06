//
//  Verification_ViewController.swift
//  WalletApp
//
//  Created by Raghav Sreeram on 10/19/19.
//  Copyright © 2019 Raghav Sreeram. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Gradients

class Verification_ViewController: UIViewController, PinTexFieldDelegate {
    
    
    
    var phoneNumber = "" //e164 format
    
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var enterDescription: UILabel!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var field1: PinTextField!
    @IBOutlet weak var field2: PinTextField!
    @IBOutlet weak var field3: PinTextField!
    @IBOutlet weak var field4: PinTextField!
    @IBOutlet weak var field5: PinTextField!
    @IBOutlet weak var field6: PinTextField!
    let phoneNumberKit = PhoneNumberKit()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        field1.delegate = self
        field2.delegate = self
        field3.delegate = self
        field4.delegate = self
        field5.delegate = self
        field6.delegate = self
        field1.becomeFirstResponder()
  
        
    }
    
    /// Sets up gradient and corner radius
    func setUpView(){
       
       enterDescription.text = "Enter the code sent to \(phoneNumber)"
       errorLabel.text = ""
        
        self.resendButton.layer.cornerRadius = 10.00
        
        let firstColor = UIColor(red: CGFloat(161/255.0), green: CGFloat(140/255.0), blue: CGFloat(209/255.0), alpha: 1.0)
        let secondColor = UIColor(red: CGFloat(251/255.0), green: CGFloat(194/255.0), blue: CGFloat(235/255.0), alpha: 1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
        
        
  
        self.view.layer.addSublayer(Gradients.deepBlue.layer)
       
    }
    
    ///If backspace is pressed, then move textfield back
    func didPressBackspace(textField: PinTextField) {
        print("Backspace was pressed")
        switch textField{
        case field2:
            field1.becomeFirstResponder()
        case field3:
            field2.becomeFirstResponder()
        case field4:
            field3.becomeFirstResponder()
        case field5:
            field4.becomeFirstResponder()
        case field6:
            field5.becomeFirstResponder()
        default:
            field1.becomeFirstResponder()
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{

        guard let currentText:String = textField.text else{
            return false
        }

        print("button pressed")
        //Only allows integers in text field
        guard let intEntered: Int = Int(string) else{
            
            //backspace is entered and there is a number typed already
            if(currentText != "" && string == ""){
                textField.text = ""
            }
            
            return false
        }
        
        textField.text = string
        
        switch textField{
        case field1:
            field2.becomeFirstResponder()
        case field2:
            field3.becomeFirstResponder()
        case field3:
            field4.becomeFirstResponder()
        case field4:
            field5.becomeFirstResponder()
        case field5:
            field6.becomeFirstResponder()
        case field6:
            verifyCode()
            field6.resignFirstResponder()
        default:
            field1.becomeFirstResponder()
        }

        print("Current Text: \(currentText)")
        print("Next Text: \(string)")

        return true
    }



    
    
    /// Calls API to verify code
    func verifyCode(){
        
        var result = getCode()
        
        Api.verifyCode(phoneNumber: phoneNumber, code: result) { response, error in
            if(error == nil){
                print("Response: \(String(describing: response))")
                
                //SUCCESSFUL login
                
                Storage.phoneNumberInE164 = self.phoneNumber
                
                if let authToken = response?["auth_token"] as? String{
                    Storage.authToken = authToken
                }
                
                
                self.performSegue(withIdentifier: "goHome", sender: self)
            
            }else{
                
                self.clearFields()
                
                print("Error: \(String(describing: error))")
                
                //Show error messages
                if(error?.code == "incorrect_code"){
                    self.errorLabel.text = "Incorrect code!"
                } else if (error?.code == "code_expired"){
                    self.errorLabel.text = "Your code expired!"
                }else{
                    
                    self.errorLabel.text = "Please try again!"
                }
                
                
            }
        }
    }
    
    ///Calls API to resend verification code and handles errors
    @IBAction func resendButton(_ sender: Any) {
        
        self.clearFields()
        Api.sendVerificationCode(phoneNumber: phoneNumber) { response, error in
            
            if(error == nil){
                self.errorLabel.text = "Verification code sent!"
            }else{
                if(error?.code == "invalid_phone_number"){
                    self.errorLabel.text = "Your phone number is invalid!"
                }
                
            }
        }
        
        
    }
    
    
    ///Adds all text fields together to create full code
    func getCode() -> String{
        
        
        guard let t1 = field1.text, let t2 = field2.text, let t3 = field3.text, let t4 = field4.text, let t5 = field5.text, let t6 = field6.text else{
            return ""
        }
        
        var newResult = t1 + t2 + t3 + t4 + t5 + t6
        
        
        return newResult
        
    }
    
    
    ///Clears all text Fields
    func clearFields(){
        field1.text = ""
        field2.text = ""
        field3.text = ""
        field4.text = ""
        field5.text = ""
        field6.text = ""
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
