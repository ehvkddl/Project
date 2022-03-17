//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by do hee kim on 2022/03/14.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var dateLabel: UILabel!
    weak var delegate: DiaryDetailViewDelegate?
    
    //전달받을 프로퍼티
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    //프로퍼티를 통해 전달받은 다이어리 객체를 view에 초기화
    private func configureView() {
        guard let diary = self.diary else {return}
        self.titleLabel.text = diary.title
        self.contentTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else {return}
        guard let row = notification.userInfo?["indexPath.row"] as? Int else {return}
        self.diary = diary //전달된 수정받은 diary 객체 대입
        self.configureView()
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        //이동할 화면 인스턴스화하여 가져옴
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else {return}
        guard let indexPath = self.indexPath else {return}
        guard let diary = self.diary else {return}
        viewController.diaryEditorMode = .edit(indexPath, diary)
        
        //notification observing
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else {return}
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//delegate를 통해 일기장 상세화면에서 삭제가 일어날 때 메서드를 통해 일기장 list화면의 indexPath를 전달해서 diaryList 배열과 collectionView의 일기가 삭제되도록 구현
