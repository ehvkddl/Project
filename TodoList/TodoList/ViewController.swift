//
//  ViewController.swift
//  TodoList
//
//  Created by do hee kim on 2022/03/07.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem?
    var tasks = [Task]() {
        didSet { //tasks배열에 할 일이 추가될 때마다 UserDefaults에 할 일이 저장
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks() //저장된 할 일들 불러오게 함
    }
    
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        //tableVeiw가 비어있으면 편집모드로 들어갈 필요 X
        //tasks 배열이 비어있지 않을 때에만 편집모드로 변환될 수 있도록 함
        guard !self.tasks.isEmpty else {return}
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let regitsterButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else {return}
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData() //tasks 배열에 할일이 추가될 때마다 table view를 갱신하여 table view에 추가된 할 일이 표시
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(regitsterButton)
        alert.addTextField(configurationHandler: {textField in textField.placeholder = "할 일을 입력해주세요."})
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTasks() {
        //할 일들을 userDefault에 dictionary 배열 상태로 저장
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        //userDefaults에 데이터 저장
        userDefaults.set(data, forKey: "tasks")
    }
    
    //userDefaults에 저장된 할 일들을 load
    func loadTasks() {
        let userDefaults = UserDefaults.standard //UserDefaults에 접근
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else {return}
        //userDefaults에 저장되어 있던 data불러와 tasks배열에 저장
        self.tasks = data.compactMap {
            //dictionary의 value가 any type이니 String으로 변환
            guard let title = $0["title"] as? String else {return nil}
            guard let done = $0["done"] as? Bool else {return nil}
            //return 해주는 값이 Task type이 되도록 인스턴스화
            return Task(title: title, done: done)
        }
    }
}

//가독성을 위해 UITableViewDataSource에 정의된 메서드들만 extension안에 정의될 수 있도록 따로 뺌
extension ViewController: UITableViewDataSource {
    //각 섹션에 표시할 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count //배열의 개수만큼 cell 표시
    }
    //특정 섹션의 N번째 row를 그리는 데에 필요한 cell을 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboard에 정의한 cell을 dequeueReusableCell을 이용해 가져올 수 있음
        //가져온 cell을 return하게 되면 storyboard에서 구현된 cell이 tableView에 표시됨
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row] //배열에 저장되어있는 할일 요소 가져옴
        cell.textLabel?.text = task.title //task에 저장되어있는 title이 cell에 textLabel에 표시
        //task.done이 true이면 체크표시 나오도록
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell //cell 반환
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row) //배열에서 삭제
        tableView.deleteRows(at: [indexPath], with: .automatic) //tableView에서도 할 일 삭제, 편집모드로 들어가지 않고 스와이프로도 삭제할 수 있음
        //모든 할 일이 삭제되면 편집모드를 빠져나가게 함
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //table cell이 재정렬된 순서대로 배열도 재정렬되도록
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row) //원래의 위치에 있던 할 일 삭제
        tasks.insert(task, at: destinationIndexPath.row) //이동한 위치에 할 일 다시 넣어줌
        self.tasks = tasks //재정렬된 배열 넣어줌
    }
}

extension ViewController: UITableViewDelegate {
    //cell을 선택하였을 때 어떠한 cell이 선택되었는지 알려주는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tasks 배열의 요소에 접근하여 task 인스턴스의 done 프로퍼티 true->false / false ->true가 되도록 변경
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task //바뀐 값 원래 배열의 요소에 덮어 씌움
        self.tableView.reloadRows(at: [indexPath], with: .automatic) //선택된 cell만 update
    }
}
