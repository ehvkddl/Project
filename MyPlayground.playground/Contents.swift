import UIKit

var number: Int? = 3
print(number)
print(number!)

if let result = number {
    print(result)
} else {
    
}


func test() {
    let number: Int? = 5
    guard let result = number else { return }
    print(result)
}

test()


let value: Int? = 6
if value == 6 {
    print("value가 6입니다")
} else {
    print("value가 6이 아닙니다")
}


let string = "12"
var stringToInt: Int! = Int(string)
print(stringToInt + 1)
