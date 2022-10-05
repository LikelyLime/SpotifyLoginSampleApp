//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 백시훈 on 2022/10/02.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton?.layer.cornerRadius = 30
        nextButton.isEnabled = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //처음 커서이동
        emailTextField.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         //navigation Bar 보이기
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    /**
     다음 버튼을 누르면 email과 비밀번호를 FirebaseAuth로 넘기는 메서드
     */
    @IBAction func nextButtonTapped(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        //신규 이용자
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error{
                let code = (error as NSError).code
                switch code{
                case 17007: //이미 로그인계정이 있을때
                    //로그인하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            }else{
                self.showMainViewController()
            }
        }
    }
    /**
     클로저
     */
    private func loginUser(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] _, error in
            guard let self = self else {return}
            if let error = error{
                self.errorMessageLabel.text = error.localizedDescription
            }else{
                self.showMainViewController()
            }
        }
    }
    /**
     Login이 성공하여 MainViewController로 이동하는 메서드
     */
    private func showMainViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
}

extension EnterEmailViewController: UITextFieldDelegate{
    //키보드 return클릭시 키보드가 내려가게하는 메서드퍄
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    //값이 입력이 되었는지 체크하는 메서드
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}
