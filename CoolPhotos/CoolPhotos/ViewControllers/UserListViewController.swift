//
//  UserListViewController.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import UIKit

class UserListViewController: UIViewController {
    // MARK: - PROPERTIES

    @IBOutlet var titleLabel: UILabel!

    var vcTitle: String = "Title"

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = vcTitle
    }

    // MARK: - ACTIONS

    // MARK: - HELPERS
}
