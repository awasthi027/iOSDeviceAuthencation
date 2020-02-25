//
//  ViewController.swift
//  LocalAuthentication
//
//  Created by Ashish Awasthi on 25/02/20.
//  Copyright © 2020 Ashish Awasthi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   @IBOutlet weak var enableFeatureBtn: UIButton!
    let touchMe = BiometricIDAuth()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Local Authentication"
        // Do any additional setup after loading the view.
    }
}

extension ViewController {
    
    @IBAction func didSelectEnableFeaturesButton(_ sender: AnyObject) {
        let viewController = FeatureListViewController.featureListViewController()
        if touchMe.state == .loggedout {
            touchMe.authenticateUser { (isSuccess) in
                if let item = viewController, isSuccess {
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(item, animated: true)
                    }
                }
            }
        }else {
            DispatchQueue.main.async {
                if let item = viewController {
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(item, animated: true)
                    }
                }
                
            }
        }
    }
}

