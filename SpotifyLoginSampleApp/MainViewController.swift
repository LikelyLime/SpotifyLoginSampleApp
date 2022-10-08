//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 백시훈 on 2022/10/02.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController{
    @IBOutlet weak var welcomLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //pop제스쳐를 막는것
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomLabel.text = """
        환영합니다.
        \(email)님
        """
        
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        self.resetPasswordButton.isHidden = !isEmailSignIn
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
