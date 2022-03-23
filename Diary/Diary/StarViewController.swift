//
//  StarViewController.swift
//  Diary
//
//  Created by do hee kim on 2022/03/14.
//

import UIKit

class StarViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadStarDiaryList()
        //notification 옵저버 추가
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
            object: nil
        )
    }

//    override func viewWillAppear(_ animated: Bool) {
//        //starViewController로 이동될 때 마다 즐겨찾기 된 일기를 불러옴
//        super.viewWillAppear(animated)
//        self.loadStarDiaryList()
//    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter.string(from: date)
    }
    
    private func loadStarDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String : Any]] else {return}
        self.diaryList = data.compactMap{
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(
                uuidString: uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: isStar
            )
        }.filter({
            $0.isStar == true
        }).sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
//        self.collectionView.reloadData()
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else {return}
        //guard let row = notification.userInfo?["indexPath.row"] as? Int else {return}
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else {return}
        //self.diaryList[row] = diary
        self.diaryList[index] = diary
        self.diaryList = self .diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let diary = starDiary["diary"] as? Diary else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        //guard let indexPath = starDiary["indexPath"] as? IndexPath else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        if isStar {
            self.diaryList.append(diary) //즐겨찾기 되면 Diary 객체 list에 추가
            //최신순 정렬
            self.diaryList = self .diaryList.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            self.collectionView.reloadData()
        } else {
            //해당하는 일기가 없으면 return을 통해서 함수가 조기종료되기 때문에 즐겨찾기 해제될때만
            guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else {return}
            //즐겨찾기에서 해제시 즐겨찾기 목록 배열에서 삭제
            //self.diaryList.remove(at: indexPath.row)
            self.diaryList.remove(at: index)
            //콜렉션 뷰에서도 삭제 되어야 함
            //self.collectionView.deleteItems(at: [indexPath])
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification) {
        //guard let indexPath = notification.object as? IndexPath else { return }
        guard let uuidString = notification.object as? String else {return}
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else {return}
        //self.diaryList.remove(at: indexPath.row)
        self.diaryList.remove(at: index)
        //self.collectionView.deleteItems(at: [indexPath])
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
}

//collectionView에 일기장 목록을 표시할 준비
extension StarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //즐겨찾기된 diaryList 배열에 개수만큼 cell이 표시되게 구현
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell else { return UICollectionViewCell() } //빈 collectionViewCell이 반환되도록
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

//UICollectionViewDelegateFlowLayout을 채택해서 CollectionView의 layout을 구성
extension StarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
    }
}

extension StarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
