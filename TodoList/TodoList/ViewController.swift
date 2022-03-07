//
//  ViewController.swift
//  TodoList
//
//  Created by do hee kim on 2022/03/07.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
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
        return cell //cell 반환
    }
}
