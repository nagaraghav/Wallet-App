//
//  LaunchViewController.swift
//  WalletApp
//
//  Created by Raghav Sreeram on 10/24/19.
//  Copyright © 2019 Raghav Sreeram. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
    }
    
    func setUpView(){
         
       
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

}
