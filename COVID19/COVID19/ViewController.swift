//
//  ViewController.swift
//  COVID19
//
//  Created by do hee kim on 2022/03/25.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {

    @IBOutlet var totalCaseLabel: UILabel!
    @IBOutlet var newCaseLabel: UILabel!
    
    @IBOutlet var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverview(completionHandler: { [weak self] result in //순환참조 방지
            guard let self = self else { return } //일시적으로 self가 strong reference가 되도록 만들어줌
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }

    func fetchCovidOverview(
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
    ) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "1FqeIrkolmAnfdzYOR4QUMV5SyXh2ijtK"
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data) //맵핑시켜줄 객체 타입, 서버에서 전달받은 data
                        completionHandler(.success(result)) //fetchCovidOverview 메소드 파라미터에 정리한 completionHandler 클로저 호출
                    } catch { //만약 JSON data를 CityCovidOverview로 맵핑하는 것을 실패한다면
                        completionHandler(.failure(error))
                    }
                    
                case let .failure(error):
                    completionHandler(.failure(error))
                }
                
            })
    }
}

