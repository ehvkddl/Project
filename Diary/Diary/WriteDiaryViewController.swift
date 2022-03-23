//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by do hee kim on 2022/03/14.
//

import UIKit

//수정할 Diary 객체 전달받기 위한 열거형
enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
    //메서드에 일기가 작성된 Diary 객체 전달
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date? //date picker에서 선택된 date를 저장하는 프로퍼티
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditorMode: DiaryEditorMode = .new//diaryEditor Mode type을 저장하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.configureEditMode()
        self.confirmButton.isEnabled = false
    }
    
    private func configureEditMode() {
        switch self.diaryEditorMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
            
        default:
            break
        }
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter.string(from: date)
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureInputField() {
        self.contentsTextView.delegate = self //delegate 채택해주기
        //제목 text field에 text가 입력될때마다 titleTextFieldDidChange 메서드 호출
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date //날짜만 나오게 설정
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged) //UIController 객체가 이벤트에 응답하는 방식을 설정해주는 메서드
        self.datePicker.locale = Locale(identifier: "ko-KR") //date picker 한국어로 표시, 년월일 순서로 표시
        self.dateTextField.inputView = self.datePicker //textField를 선택했을 때 키보드가 아닌 데이트 피커가 표시
    }

    //일기를 다 작성하고 등록버튼을 눌렀을 때 다이어리 객체를 생성하고 delegate에 정의한 didSelectRegister 메서드를 호출해서 메서드 파라미터에 생성된 다이어리 객체를 전달
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else {return}
        guard let contents = self.contentsTextView.text else {return}
        guard let date = self.diaryDate else {return}
        
        
        switch self.diaryEditorMode {
        case .new: //일기를 등록하는 행위
            let diary = Diary(
                uuidString: UUID().uuidString, //일기를 생성할때마다 uuidString 프로퍼티에 유효id생성됨
                title: title,
                contents: contents,
                date: date,
                isStar: false)
            self.delegate?.didSelectRegister(diary: diary)
        case let .edit(indexPath, diary):
            let diary = Diary(
                uuidString: diary.uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: diary.isStar)
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil
            )
        }
        self.navigationController?.popViewController(animated: true) //등록화면 없애고 일기list화면으로 돌아가도록
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter() //날짜와 text를 반환해주는 역할 (date type을 사람이 읽을 수 있는 형태의 문자열로 반환, 날짜 형태의 문자열에서 date type으로 변환 시켜주는 역할)
        formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date //datePicker에서 선택한 date type 저장
        self.dateTextField.text = formmater.string(from: datePicker.date) //formmater에 지정한 문자열로 변경해서 dateTextField에 뜰 수 있게 함
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        //제목이 입력될 때마다 등록 버튼 활성화 여부를 판단할 수 있도록
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        //날짜가 입력될 때마다 등록 버튼 활성화 여부를 판단할 수 있도록
        self.validateInputField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //등록버튼의 활성화 여부 판단
    private func validateInputField() {
        //제목 내용이 비어있지 않고, 일기 내용이 비어있지 않고, 날짜 선택이 비어있지 않을 때 등록버튼 활성화
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}


extension WriteDiaryViewController: UITextViewDelegate {
    //textView에 text가 입력될 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        //제목, 내용, 날짜가 입력될 때마다 validateInputField()메서드가 호출되게 해서 등록버튼을 활성화할지 판단
        validateInputField()
    }
}
