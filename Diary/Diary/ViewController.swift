//
//  ViewController.swift
//  Diary
//
//  Created by do hee kim on 2022/03/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteDiaryNotification(_:)),
            name: NSNotification.Name("deleteDiary"),
            object: nil)
    }
    
    //collectionView 속성 정의 메소드
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //collectionView에 표시되는 contents의 좌우위아래 간격이 10만큼 생김
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else {return}
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString}) else {return} //notification에서 전달받은 uuid와 같은 값이 배열의 요소에 있는지 확인하고 있으면 해당 요소의 index를 return 받을 수 있도록 함
        // guard let row = notification.userInfo?["indexPath.row"] as? Int else {return}
        //self.diaryList[row] = diary
        self.diaryList[index] = diary
        self.diaryList = self.diaryList.sorted(by: {
            //날짜 수정될 수도 있으니까 날짜 최신순으로 정렬하는 코드
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else {return}
        guard let isStar = starDiary["isStar"] as? Bool else {return}
        guard let uuidString = starDiary["uuidString"] as? String else {return}
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        //guard let indexPath = starDiary["indexPath"] as? IndexPath else {return}
        //self.diaryList[indexPath.row].isStar = isStar
        self.diaryList[index].isStar = isStar
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification) {
        //guard let indexPath = notification.object as? IndexPath else {return}
        guard let uuidString = notification.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        //self.diaryList.remove(at: indexPath.row)
        self.diaryList.remove(at: index)
        //self.collectionView.deleteItems(at: [indexPath])
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue로 이동되는 view controller가 무엇인지 알 수 있게
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    private func saveDiaryList() {
        //배열에 있는 요소들을 dictionary 형태로 맵핑
        let data = self.diaryList.map {
            [
                "uuidString": $0.uuidString,
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard //UserDefaults에 접근할 수 있게
        userDefaults.set(data, forKey: "diaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else {return}
        self.diaryList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else {return nil}
            guard let title = $0["title"] as? String else {return nil}
            guard let contents = $0["contents"] as? String else {return nil}
            guard let date = $0["date"] as? Date else {return nil}
            guard let isStar = $0["isStar"] as? Bool else {return nil}
            return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
        }
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter.string(from: date)
    }

}

extension ViewController: UICollectionViewDataSource {
    //지정된 section에 표시할 cell의 개수를 묻는 메소드
    //diaryList 배열의 개수만큼 cell이 표시될 수 있도록 구현
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    //collectionView의 지정된 위치에 표시할 cell을 요청하는 메소드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //collectionView에 일기장 list가 표시
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        //재사용할 cell을 가져오게 되면 이 cell에 일기의 제목과 날짜가 표시되게
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        //Diary 인스턴스에 있는 date 프로퍼티는 date type으로 되어 있으므로 date formatter를 이용해서 문자열로 만들어줘야 함
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    //cell의 size를 설정
    //표시할 cell의 size를 CGSize로 정하고 return 해주면 설정한 size대로 cell이 표시됨
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //한줄당 두개의 cell만 표시할 것 - 좌우 여백 값
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

extension ViewController: UICollectionViewDelegate {
    //특정 셀이 선택되었음을 알리는 메서드
    //diaryDatailViewController가 표시되게 구현
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else {return}
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        //viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: WriteDiaryViewDelegate {
    //일기가 등록되면 didSelectRegister 메소드를 통해 작성된 일기의 내용이 담겨져 있는 Diary 객체 전달
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        //diaryList 배열에 일기가 추가될 때마다 collectionView에 일기 표시
        self.collectionView.reloadData()
    }
}

//extension ViewController: DiaryDetailViewDelegate {
//    func didSelectDelete(indexPath: IndexPath) {
//        self.diaryList.remove(at: indexPath.row)
//        self.collectionView.deleteItems(at: [indexPath])
//    }
    
//    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
//        self.diaryList[indexPath.row].isStar = isStar //메소드 파라미터로 전달받은 isStar값을 isStar 프로퍼티에 대입(즐겨찾기 여부 업데이트)
//    }
//}
