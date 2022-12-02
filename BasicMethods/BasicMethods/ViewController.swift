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
        postPhoto()
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
    
    func postPhoto() {
        let url = "https://httpbin.org/post"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        let params = ["id" : "hello123", "pw" : "123123!"] as Dictionary
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("success")
                print(response.value)
            case .failure:
                print("Alamofire error")
            }
        }
        
        
    }
    
}
