//
//  PhotoCollectionViewController.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import UIKit

class PhotoCollectionViewController: UIViewController {
    // MARK: - PROPERTIES

    @IBOutlet var titleLabel: UILabel!

    var vcTitle: String = ""
    var photoData: [Photo]?

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = vcTitle
        print("PhotoCollectionVC - photoData.count: \(photoData?.count ?? 0)")
    }

    // MARK: - ACTIONS

    // MARK: - HELPERS
}
