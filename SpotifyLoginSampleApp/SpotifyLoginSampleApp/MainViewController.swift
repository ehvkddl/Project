//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by do hee kim on 2022/03/29.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        //로그인 했을 경우에 firebase 인증을 통해서 login한 사용자의 email을 가져올 수 있음
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do {
            //로그아웃 시도시 오류 발생하지 않으면 popToRootViewController 실행
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            //로그아웃 실패하여 error 발생하면 콘솔에 메시지
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
        
    }
}
