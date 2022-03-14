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
    }
    
    //collectionView 속성 정의 메소드
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //collectionView에 표시되는 contents의 좌우위아래 간격이 10만큼 생김
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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
            guard let title = $0["title"] as? String else {return nil}
            guard let contents = $0["contents"] as? String else {return nil}
            guard let date = $0["date"] as? Date else {return nil}
            guard let isStar = $0["isStar"] as? Bool else {return nil}
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
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
