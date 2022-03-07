//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by do hee kim on 2022/03/02.
//

import UIKit

protocol SendDataDelegate: AnyObject {
    func sendData(name: String)
}

class CodePresentViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    var name: String?
    weak var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.delegate?.sendData(name: "DoHee")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
