//
//  AccountViewController.swift
//  
//
//  Created by Raghav Sreeram on 11/5/19.
//

import UIKit

class AccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var walletObj: Wallet?
    var index: Int?
    
    @IBOutlet weak var accName: UILabel!
    @IBOutlet weak var accTotal: UILabel!
    
    @IBOutlet weak var deposit: UIButton!
    @IBOutlet weak var withdraw: UIButton!
    @IBOutlet weak var transfer: UIButton!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var depositTF: UITextField!
    @IBOutlet weak var withdrawView: UIView!
    @IBOutlet weak var withdrawTF: UITextField!
    @IBOutlet weak var withdrawViewDoneButt: UIButton!
    @IBOutlet weak var transferView: UIView!
    
    @IBOutlet weak var depositViewDoneButt: UIButton!
    @IBOutlet weak var transferPicker: UIPickerView!
    @IBOutlet weak var transferAmtTF: UITextField!
    @IBOutlet weak var transferViewDoneButt: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
        setUpWalletInfo()
        setAllPopViewsHidden()
        
    }

   
    
    func setUpWalletInfo(){
        guard let walletObj = walletObj, let index = index else{
            return
        }
        
        self.accName.text = walletObj.accounts[index].name
        self.accTotal.text = "$\(walletObj.accounts[index].amount)"
        
    }
    ///Corner radius and gradients
    func setUpView(){
        self.deposit.layer.cornerRadius = self.deposit.frame.height/2
        self.withdraw.layer.cornerRadius = self.withdraw.frame.height/2
        self.transfer.layer.cornerRadius = self.transfer.frame.height/2
        self.delete.layer.cornerRadius = self.delete.frame.height/2
        
        
        let firstColor = UIColor(red: CGFloat(161/255.0), green: CGFloat(140/255.0), blue: CGFloat(209/255.0), alpha: 1.0)
        let secondColor = UIColor(red: CGFloat(251/255.0), green: CGFloat(194/255.0), blue: CGFloat(235/255.0), alpha: 1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    ///Shows deposit pop up
    @IBAction func depositButton(_ sender: Any) {
        //Make function for this
        setAllPopViewsHidden()
        toggleViews(viewPassed: depositView)
        
    }
    
    ///Makes api call to deposit
    @IBAction func depositViewDone(_ sender: Any) {
        
        let str = self.depositTF.text ?? "0.00"
        let amt = Double(str) ?? 0.00
        
        depositTF.resignFirstResponder()
        toggleViews(viewPassed: depositView)
        
        guard let walletObj = walletObj, let index = index else{
            print("walletObj nil while adding account")
            return
        }
        
        Api.deposit(wallet: walletObj, toAccountAt: index, amount: amt) { (response, error) in
            guard let response = response, error == nil else{
                
                print("Error At deposit: \(String(describing: error))")
                return
            }
            
            print(response)
            
            var newAmt = self.walletObj?.accounts[index].amount ?? 0.00
            self.accTotal.text = "$\(newAmt)"
            
            
        }
        
    }
    
    ///Shows withdraw pop up
    @IBAction func withdrawButton(_ sender: Any) {
        setAllPopViewsHidden()
        toggleViews(viewPassed: withdrawView)
    }
    
    ///Makes API call to withdraw. if funds too low, alerts user
    @IBAction func withdrawViewDone(_ sender: Any) {
        
        guard let walletObj = walletObj, let index = index else{
            print("walletObj nil while adding account")
            return
        }
        
        let str = self.withdrawTF.text ?? "0.00"
        
        clearTF()
        let amt = Double(str) ?? 0.00
        var curAmt = walletObj.accounts[index].amount ?? 0.00
        
        if(amt > curAmt){
            print("withdrawing more than you have")
            //Show Alert
            alert(title: "Insufficient Funds", message: "Balance is lower than amount requested.")
            
            return
        }
        
        
        withdrawTF.resignFirstResponder()
        toggleViews(viewPassed: withdrawView)
        
        Api.withdraw(wallet: walletObj, fromAccountAt: index, amount: amt) { (response, error) in
            guard let response = response, error == nil else{
                
                print("Error At deposit: \(error)")
                return
            }
            
            print(response)
           
            var newAmt = self.walletObj?.accounts[index].amount ?? 0.00
            self.accTotal.text = "$\(newAmt)"
            
        }
    }
    
    
    
    @IBAction func transferButton(_ sender: Any) {
        setAllPopViewsHidden()
        toggleViews(viewPassed: transferView)
    }
    
    
    @IBAction func transferViewDone(_ sender: Any) {
        
        let str = self.transferAmtTF.text ?? "0.00"
        let amt = Double(str) ?? 0.00
        clearTF()
        
        guard let walletObj = walletObj, let index = index else{
            print("walletObj nil while adding account")
            return
        }
        
        
        var curAmt = walletObj.accounts[index].amount
        if(amt > curAmt){
            print("withdrawing more than you have")
            
            alert(title: "Insufficient Funds", message: "Balance is lower than amount requested.")
            return
        }
        
        transferAmtTF.resignFirstResponder()
        toggleViews(viewPassed: transferView)
        
        let toAcc = transferPicker.selectedRow(inComponent: 0)
    
    
        Api.transfer(wallet: walletObj, fromAccountAt: index, toAccountAt: toAcc, amount: amt) { (response, error) in
            guard let response = response, error == nil else{
                
                print("Error At deposit: \(String(describing: error))")
                return
            }
            
            print(response)
            
            var amt = walletObj.accounts[index].amount
            self.accTotal.text = "$\(amt)"
            
        }
        
        
    }
    
    
    
    func setAllPopViewsHidden(){
        
        depositView.layer.cornerRadius = 10
        depositViewDoneButt.layer.cornerRadius = 10
        depositView.isHidden = true
        
        withdrawView.layer.cornerRadius = 10
        withdrawViewDoneButt.layer.cornerRadius = 10
        withdrawView.isHidden = true
        
        transferView.layer.cornerRadius = 10
        transferViewDoneButt.layer.cornerRadius = 10
        transferView.isHidden = true
        
    }
    
    ///Function to generate alerts
    func alert(title: String, message: String){
        //Show Alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func toggleViews(viewPassed: UIView){
        viewPassed.isHidden =  viewPassed.isHidden ? false : true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let walletObj = walletObj else{
            print("walletObj nil while adding account")
            return 0
        }
        
        return walletObj.accounts.count
    }
    
    ///Sets row name for each row in picker view to account name
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let walletObj = walletObj else{
            print("walletObj nil while adding account")
            return "Missing Account Name"
        }
        
        return walletObj.accounts[row].name
    }
    

    ///Deletes account and dismisses view
    @IBAction func deleteButt(_ sender: Any) {
        setAllPopViewsHidden()
        
        guard let walletObj = walletObj, let index = index else{
            print("walletObj nil while adding account")
            return
        }
        Api.removeAccount(wallet: walletObj, removeAccountat: index) { (response, error) in
            guard let response = response, error == nil else{
                
                print(error)
                return
            }
            
            
            self.dismiss(animated: true) {
                return
            }
        }
    }
    
    ///Dismisses account vc to home
    @IBAction func doneButton(_ sender: Any) {
        
        self.dismiss(animated: true) {
            return
        }
    }
    
    ///clears all text fields to avoid old test
    func clearTF(){
        depositTF.text = ""
        withdrawTF.text = ""
        transferAmtTF.text = ""
    }
    
}


extension UIView{
       
       
       
}
