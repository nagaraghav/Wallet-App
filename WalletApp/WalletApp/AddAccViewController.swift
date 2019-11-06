//
//  AddAccViewController.swift
//  WalletApp
//
//  Created by Raghav Sreeram on 11/5/19.
//  Copyright © 2019 Raghav Sreeram. All rights reserved.
//

import UIKit

protocol AccountAdded {
    func userDidAddAccount(name: String)
}

class AddAccViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accNameTF: UITextField!
    @IBOutlet weak var doneButt: UIButton!
    
    var delegate: AccountAdded?
    
    @IBOutlet weak var fullView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButt.layer.cornerRadius = self.doneButt.frame.height/2
        // Do any additional setup after loading the view.
        self.fullView.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.accNameTF.resignFirstResponder()
       
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        

        let name = accNameTF.text ?? ""
        self.delegate?.userDidAddAccount(name: name)
        
        self.dismiss(animated: true) {
            return
        }
//        let storyboard = UIStoryboard(name: "Main", bundle:nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
//
//        let homeVC = vc as! HomeViewController
//        homeVC.modalPresentationStyle = .overCurrentContext
//        self.present(homeVC, animated: true)
        
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
