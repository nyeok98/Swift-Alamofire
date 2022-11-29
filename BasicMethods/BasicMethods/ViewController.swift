//
//  ViewController.swift
//  BasicMethods
//
//  Created by NYEOK on 2022/11/30.
//

import Alamofire
import UIKit

class ViewController: UIViewController {
    // MARK: - PROPERTIES

    @IBOutlet var responseText: UILabel!

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - ACTIONS

    @IBAction func callAlamofireBtn(_ sender: Any) {
        getPhoto()
    }

    func getPhoto() {
        let url = "https://jsonplaceholder.typicode.com/todos/1"

        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept": "application/json"])
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: DataModel.self) { response in
                switch response.result {
                case .success(let data):
                    self.responseText.text = data.title
                case .failure(let error):
                    print(error)
                }
            }
    }
}
