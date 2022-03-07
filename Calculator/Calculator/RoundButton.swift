//
//  RoundButton.swift
//  Calculator
//
//  Created by do hee kim on 2022/03/05.
//

import UIKit

//변경된 설정값을 스토리보드에서 실시간으로 확인할 수 있도록
@IBDesignable
class RoundButton: UIButton {
    //IBInspectable annotation : storyboard에서도 isRound 프로퍼티의 설정값을 변경할 수 있도록 해줌
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.size.height / 2
            }
        }
    }
//        override func draw(_ rect: CGRect) {
//            self.clipsToBounds = true
//            self.layer.cornerRadius = self.frame.size.height / 2
//        }
}
