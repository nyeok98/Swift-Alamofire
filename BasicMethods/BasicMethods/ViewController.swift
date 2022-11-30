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
        let url = "https://jsonplaceholder.typicode.com/users"
        var nameStrings = ""
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept": "application/json"])
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: [User].self) { response in
                switch response.result {
                case .success:
                    for data in response.value! as [User] {
                        nameStrings += data.name + " "
                    }
                    self.responseText.text = nameStrings
                case .failure(let error):
                    print(error)
                }
            }
    }
}
