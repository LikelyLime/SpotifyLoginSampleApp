//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 백시훈 on 2022/10/02.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationBar 숨김
        navigationController?.navigationBar.isHidden = true
        
    }
    @IBAction func googleLoginButtonTapped(_ sender: Any) {
        //Firebase인증
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self){user, error in
            guard error == nil else { return }
            // 인증을 해도 계정은 따로 등록을 해주어야 한다.
            // 구글 인증 토큰 받아서 -> 사용자 정보 토큰 생성 -> 파이어베이스 인증에 등록
            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { _, _ in
                self.showMainViewController()
            }
        }
        
    }
    /**
     Google로그인 후 메인 View로 전환하는 메서드
     */
    private func showMainViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewContoller = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewContoller.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(mainViewContoller, sender: nil)
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: Any) {
        //Firebase인증
    }
}
