//
//  ViewController.swift
//  HornsV2
//
//  Created by Lacy P. Smith  on 6/23/20.
//  Copyright © 2020 Evan Templeton. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signInFacebookButton: UIButton!
    @IBOutlet weak var signInGoogleButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    
    @IBAction func signInFacebookPressed(_ sender: UIButton) {
        
    }
    
    func setupUI() {

        signInFacebookButton.layer.cornerRadius = 5
        signInGoogleButton.layer.cornerRadius = 5
        createAccountButton.layer.cornerRadius = 5

    }
    
}

