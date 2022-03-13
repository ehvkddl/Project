//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by do hee kim on 2022/03/04.
//

import UIKit

protocol LEDBoardSettingDelegate: AnyObject {
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor)
}

class SettingViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var yellowButton: UIButton!
    @IBOutlet var purpleButton: UIButton!
    @IBOutlet var greenButton: UIButton!
    @IBOutlet var blackButton: UIButton!
    @IBOutlet var blueButton: UIButton!
    @IBOutlet var orangeButton: UIButton!
    
    weak var delegate: LEDBoardSettingDelegate?
    var ledText: String?
    var textColor: UIColor = .yellow
    var backgroundColor: UIColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        if let ledText = self.ledText {
            self.textField.text = ledText
        }
        self.changeTextColor(color: self.textColor)
        self.changeBackgroundColor(color: self.backgroundColor)
    }
    
    @IBAction func tapTextColorButton(_ sender: UIButton) {
        if sender == self.yellowButton {
            self.changeTextColor(color: .yellow)
            self.textColor = .yellow
        } else if sender == self.purpleButton {
            self.changeTextColor(color: .purple)
            self.textColor = .purple
        } else {
            self.changeTextColor(color: .green)
            self.textColor = .green
        }
    }
    
    @IBAction func tapBackgroundColorButton(_ sender: UIButton) {
        if sender == self.blackButton {
            self.changeBackgroundColor(color: .black)
            self.backgroundColor = .black
        } else if sender == self.blueButton {
            self.changeBackgroundColor(color: .blue)
            self.backgroundColor = .blue
        } else {
            self.changeBackgroundColor(color: .orange)
            self.backgroundColor = .orange
        }
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        self.delegate?.changedSetting(
            text: self.textField.text,
            textColor: textColor,
            backgroundColor: backgroundColor)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func changeTextColor(color: UIColor) {
        self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
        self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
        self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
    }
    
    private func changeBackgroundColor(color: UIColor) {
        self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
        self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
        self.orangeButton.alpha = color == UIColor.orange ? 1 : 0.2
    }
}
