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
    @IBOutlet var photoCollectionView: UICollectionView!

    var vcTitle: String = ""
    var photoData: [Photo]?

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = vcTitle

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self

        let photoNib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        photoCollectionView.register(photoNib, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    }

    // MARK: - ACTIONS

    // MARK: - HELPERS
}

// MARK: - EXTENSIONS

extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let urlString = photoData?[indexPath.row].thumbnail

        getPhoto(urlString ?? "") { image in
            cell.cellImageView.image = image
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPhotoDetailVC", sender: self)
    }

    func getPhoto(_ urlString: String, _ completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let url = URL(string: urlString)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)

                DispatchQueue.main.sync {
                    completion(image)
                }
            }
        }
    }

    // MARK: - Cell Layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 4) / 3
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
