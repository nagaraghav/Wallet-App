//
//  HomeViewController.swift
//  WalletApp
//
//  Created by Raghav Sreeram on 10/20/19.
//  Copyright © 2019 Raghav Sreeram. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AccountAdded {
    


    
    @IBOutlet weak var amountTF: UILabel!
    @IBOutlet weak var userNameTF: UITextField!
    var walletObj: Wallet?
    
    @IBOutlet weak var AccountTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let str = self.userNameTF.text else{
            return
        }
        
        Api.setName(name: str) { (response,error) in
            if(error != nil){
                 print("Error in saving name")
                return
            }else{
                print("Saved name")
            }
        }
    }
    
    ///Set up UI such as Name and total amount
    func setupWalletUI(){
        let name = self.walletObj?.userName  ?? self.walletObj?.phoneNumber
        self.userNameTF.text = name
        
        let amount = self.walletObj?.totalAmount ?? 0.0
        let str_amount = String(format: "%0.02f", amount)
        self.amountTF.text = "Your total amount is: $\(str_amount)"
        
        AccountTableView.reloadData()
        
    }
    
    
    //Sets up delegates,
    override func viewWillAppear(_ animated: Bool) {
      
        print("View will appear!!")
        
        userNameTF.delegate = self
        
        setUpView()
        Api.user { (response, error) in
                 if(error == nil){
                     print("home response: \(response)" )
                     
                     if let response = response{
                         self.walletObj = Wallet(data: response, ifGenerateAccounts: false)
                         
                         self.walletObj?.printWallet()
                         
                         self.setupWalletUI()
                     }
                     
                 }else{
                     print("home error: \(error)")
                 }
             }
    }
    
    
    /// Sets up gradient
    func setUpView(){
        AccountTableView.backgroundColor = UIColor.clear
        
        //Original
        let firstColor = UIColor(red: CGFloat(161/255.0), green: CGFloat(140/255.0), blue: CGFloat(209/255.0), alpha: 1.0)
        let secondColor = UIColor(red: CGFloat(251/255.0), green: CGFloat(194/255.0), blue: CGFloat(235/255.0), alpha: 1.0)
        //Green
//        let firstColor = UIColor(red: CGFloat(212/255.0), green: CGFloat(252/255.0), blue: CGFloat(121/255.0), alpha: 1.0)
//              let secondColor = UIColor(red: CGFloat(150/255.0), green: CGFloat(230/255.0), blue: CGFloat(161/255.0), alpha: 1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userNameTF.resignFirstResponder()
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletObj?.accounts.count ?? 0
    }
    
    ///Sets up each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") ?? UITableViewCell(style: .default, reuseIdentifier: "accountCell")
        
        var acc_name = self.walletObj?.accounts[indexPath.row].name ?? "Account X"
        var amt = self.walletObj?.accounts[indexPath.row].amount ?? 0.00
        
        cell.textLabel?.text = "\(acc_name) "
        cell.detailTextLabel?.text = "$\(amt)"
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
 
    
    @IBAction func logoutButton(_ sender: Any) {
        print("logout button")
        
        self.dismiss(animated: true) {
            return
        }
        
        //performSegue(withIdentifier: "logoutToLogin", sender: self)
    }
    

    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("did select row! ")
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AccountViewController")

        let accVC = vc as! AccountViewController
        accVC.walletObj = self.walletObj
        accVC.index = indexPath.row
        accVC.modalPresentationStyle = .fullScreen
        self.present(accVC, animated: true)


    }
    
    
  
    @IBAction func addAccount(_ sender: Any) {
        
       let storyboard = UIStoryboard(name: "Main", bundle:nil)
       let vc = storyboard.instantiateViewController(withIdentifier: "AddAccViewController")

       let accVC = vc as! AddAccViewController
        accVC.delegate = self
       accVC.modalPresentationStyle = .overCurrentContext
       self.present(accVC, animated: true)

        
    }
    
    func userDidAddAccount(name: String) {
         guard let walletObj = walletObj else{
                print("walletObj nil while adding account")
                return
        }
        
        var name = name
        if name == ""{
            name = "Account \(walletObj.accounts.count + 1)"
        }
                
        Api.addNewAccount(wallet: walletObj, newAccountName: name) { (response, error) in
            
            guard let response = response, error == nil else{
                print("There was a problem adding an account")
                return
            }
            
            self.walletObj = Wallet(data: response, ifGenerateAccounts: false)
            self.AccountTableView.reloadData()
            print("Added Account")
            print(response)
            
        }
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
