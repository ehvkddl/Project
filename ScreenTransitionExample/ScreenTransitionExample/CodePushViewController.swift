//
//  CodePushViewController.swift
//  ScreenTransitionExample
//
//  Created by do hee kim on 2022/03/02.
//

import UIKit

class CodePushViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
