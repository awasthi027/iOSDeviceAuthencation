//
//  FeatureListViewController.swift
//  LocalAuthentication
//
//  Created by Ashish Awasthi on 25/02/20.
//  Copyright © 2020 Ashish Awasthi. All rights reserved.
//

import UIKit

class FeatureListViewController: ViewController {
    
    static func featureListViewController() ->FeatureListViewController? {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: String(describing: FeatureListViewController.self)) as? FeatureListViewController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = " Here we can see enable features"
        // Do any additional setup after loading the view.
    }
 
}
