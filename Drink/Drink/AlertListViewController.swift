//
//  AlertListViewController.swift
//  Drink
//
//  Created by do hee kim on 2022/04/15.
//

import UIKit

class AlertListViewController: UITableViewController {
    var alerts: [Alert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "AlertListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //userDefaults에 저장된 값이 배열에 들어옴
        alerts = alertList()
    }
    
    @IBAction func addAlertButtonAction(_ sender: Any) {
        guard let addAlertVC = storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        addAlertVC.pickedDate = {[weak self] date in
            guard let self = self else { return }
            
            //새로운 알럿이 생성될 때마다 테이블 뷰에 반영하는 것 뿐만 아니라 userDefaults에도 저장을 해줘야 함
            var alertList = self.alertList() //userDefaults에서 가져온 list
            let newAlert = Alert(date: date, isOn: true)
            
            alertList.append(newAlert)
            alertList.sort { $0.date < $1.date } //시간 순서대로 정렬
            
            self.alerts = alertList //tableView가 바라보는 배열은 새로운 알럿을 append 한 최종 list
            //인코딩 진행해서 userDefaults에 추가된 알럿을 넣어줌
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            self.tableView.reloadData()
            
        }
        
        self.present(addAlertVC, animated: true, completion: nil)
    }
    
    func alertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return [] }
        return alerts
    }
}

//UITableView DataSource, Delegate
extension AlertListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "🚰 물마실 시간"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else { return UITableViewCell() }
        
        cell.alertSwitch.isOn = alerts[indexPath.row].isOn
        cell.timeLabel.text = alerts[indexPath.row].time
        cell.meridiemLabel.text = alerts[indexPath.row].meridiem
        
        cell.alertSwitch.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            //노티피케이션 삭제 구현
            self.alerts.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            self.tableView.reloadData()
            return
        default:
            break
        }
    }
}
