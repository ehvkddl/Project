//
//  ViewController.swift
//  Calculator
//
//  Created by do hee kim on 2022/03/05.
//

import UIKit

//연산자가 열거형 값이 되도록
enum Operation {
    case Add
    case Subsract
    case Divide
    case Multiply
    case unknown
}

class ViewController: UIViewController {

    @IBOutlet var numberOutputLabel: UILabel!
    
    //계산기의 상태값을 가지고 있는 프로퍼티
    
    //계산기 버튼을 누를때마다 numberOutputLabel에 표시되는 숫자를 가지고 있는 프로퍼티
    var disPlayNumber = ""
    //이전 계산값을 가지고 있는 프로퍼티(첫번째 피연산자)
    var firstOperand = ""
    //새롭게 입력된 값을 저장(두번째 피연산자)
    var secondOperand = ""
    //계산의 결과값 저장
    var result = ""
    //현재 계산기에 어떠한 연산자가 입력되었는지 알 수 있게 연산자의 값을 저장
    var currentOperation: Operation = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.title(for: .normal) else { return }//선택한 버튼의 타이틀 값 가져옴
        if self.disPlayNumber.count < 9 {
            self.disPlayNumber += numberValue
            self.numberOutputLabel.text = self.disPlayNumber
        }
    }
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.disPlayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    @IBAction func tapDotButton(_ sender: UIButton) {
        if self.disPlayNumber.count < 8, !self.disPlayNumber.contains(".") {
            self.disPlayNumber += self.disPlayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.disPlayNumber
        }
    }
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    @IBAction func tapSubtractButton(_ sender: UIButton) {
        self.operation(.Subsract)
    }
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation) {
        if self.currentOperation != .unknown {
            //첫번째 피연산자와 두번째 피연산자를 연산해주는 로직
            if !self.disPlayNumber.isEmpty {
                self.secondOperand = self.disPlayNumber //두번째로 입력받은 값 넣어줌
                self.disPlayNumber = "" //결과값이 표시된 후에 다시 숫자를 선택하면 새롭게 선택한 숫자가 numberOutputLabel에 표시되어야하기 때문에 초기화
                
                guard let firstOperand = Double(self.firstOperand) else {return}
                guard let secondOperand = Double(self.secondOperand) else {return}
                
                switch self.currentOperation {
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                case .Subsract:
                    self.result = "\(firstOperand - secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                default:
                    break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                //계산기 앱은 연산자를 여러개 사용할 수 있기 때문에 연산의 결과값을 다시 첫번째 피연산자에 넣어서 다음 연산에 사용할 수 있게 만들어줘야함
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            self.currentOperation = operation
        } else {
            //첫번째 피연산자와 연산자를 선택한 상태
            self.firstOperand = self.disPlayNumber //첫번째 피연산자
            self.currentOperation = operation //선택한 연산자 저장
            self.disPlayNumber = "" //연산자 선택하고 뒤에 연산할 값을 넣을때 값만 보여야함으로
        }
    }
    
}

