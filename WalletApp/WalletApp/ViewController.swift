//
//  ViewController.swift
//  WalletApp
//
//  Created by Raghav Sreeram on 10/7/19.
//  Copyright © 2019 Raghav Sreeram. All rights reserved.
//

import UIKit
import PhoneNumberKit

class ViewController: UIViewController {

    @IBOutlet var gestureRecongizer: UITapGestureRecognizer!
    
    @IBOutlet weak var numberField: PhoneNumberTextField!
    
    @IBOutlet weak var validationLab: UILabel!
    @IBOutlet weak var viewF: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    let phoneNumberKit = PhoneNumberKit()
    
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setUpView()
    }
    
    
    ///Rounds buttons, and sets up gradients
    func setUpView(){
       
        self.viewF.layer.cornerRadius = 10.00
        self.nextButton.layer.cornerRadius = 10.00
        
        if var textNum = Storage.phoneNumberInE164 {
            //let start = textNum.index(textNum.startIndex, offsetBy: 3)

            
            textNum = String(textNum.suffix(10)) // The result is of type Substring
         self.numberField.text = textNum
        }
        
     
        let firstColor = UIColor(red: CGFloat(161/255.0), green: CGFloat(140/255.0), blue: CGFloat(209/255.0), alpha: 1.0)
        let secondColor = UIColor(red: CGFloat(251/255.0), green: CGFloat(194/255.0), blue: CGFloat(235/255.0), alpha: 1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    /// Dismisses keyboard when view is tapped
    /// - Parameter sender: Any
    @IBAction func tapped(_ sender: Any) {
        
        numberField.resignFirstResponder()
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        let phNumFromUser = self.numberField.text ?? ""
        
        
        //Error 1 Check Length
        if(phNumFromUser.count != 14){
            self.validationLab.text = "Please try again with 10 digits!"
            self.numberField.resignFirstResponder()
            return
        }
        
        do{
            //Phone number kit Parse string from textfield
            let phoneNumber = try self.phoneNumberKit.parse(phNumFromUser)
            //Put phone number back into string format
            let fNumber = phoneNumberKit.format(phoneNumber, toType: .e164)
            
             
            if Storage.authToken != nil, Storage.phoneNumberInE164 == fNumber {
//                 let homeVC = HomeViewController()
//                 homeVC.modalPresentationStyle = .fullScreen
//                 present(homeVC, animated: true)
                performSegue(withIdentifier: "HomeFromLogin", sender: self)
                return
            }
            
            Api.sendVerificationCode(phoneNumber: fNumber) { response, error in
                
                if(error == nil){
                    print(response)
                }else{
                    if(error?.code == "invalid_phone_number"){
                        self.validationLab.text = "Please enter a valid phone number!"
                        self.numberField.resignFirstResponder()
                        return
                    }
                    
                }
            }
            
            self.validationLab.text = "Verification code has been sent to \(fNumber)"
            self.numberField.resignFirstResponder()
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let storyboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "verificationVC")
                
                let verifVC = vc as! Verification_ViewController
                verifVC.phoneNumber = fNumber //e164 format
                
                self.navigationController?.pushViewController(verifVC, animated: true)
                
            }
            
            
            
            
        }catch{
            //Invalid number or parsing error
            //Error 2
            print("error")
            self.validationLab.text = "Please enter a valid phone number!"
            self.numberField.resignFirstResponder()
            
        }
        
    }
    
    
}

