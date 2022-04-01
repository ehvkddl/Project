//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by do hee kim on 2022/03/29.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //세 개의 버튼에 동일한 UI
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        //Firebase 인증
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            if let error = error {
                print("ERROR", error.localizedDescription)
                return
            }
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { _, _ in
                self.showMainViewController()
            }
        }
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        //Firebase 인증
    }
}
