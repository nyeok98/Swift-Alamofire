//
//  ViewController.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import Toast_Swift
import UIKit

class ViewController: UIViewController {
    // MARK: - PROPERTIES

    @IBOutlet var imageView: UIImageView!
    
    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "logo")
    }
    
    // MARK: - ACTIONS
    
    @IBAction func searchBtnTouched(_ sender: UIButton) {
        view.makeToast("Hi there🤔")
    }
    
    // MARK: - HELPER
}
