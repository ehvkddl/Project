//
//  AddAlertViewController.swift
//  Drink
//
//  Created by do hee kim on 2022/04/15.
//

import UIKit

class AddAlertViewController: UIViewController {

    var pickedDate: ((_ date: Date) -> Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func dismissButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        //사람들이 선택한 datePicker에 있는 시간 부모뷰에 넘겨줘야 함
        pickedDate?(datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
}
