//
//  ViewController.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import Toast_Swift
import UIKit

class HomeViewController: UIViewController {
    // MARK: - PROPERTIES

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var searchFilterSegment: UISegmentedControl!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var searchIndicator: UIActivityIndicatorView!
    
    var keyboardDismissTabGesture: UIGestureRecognizer = UITapGestureRecognizer(target: HomeViewController.self, action: nil)
    
    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 기본 UI 설정
        imageView.image = UIImage(named: "logo")
        searchBar.delegate = self
        keyboardDismissTabGesture.delegate = self
        view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            let nextVC = segue.destination as! UserListViewController
            
            guard let userInputValue = searchBar.text else { return }
            
            nextVC.vcTitle = userInputValue + "👨‍💻"
            
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionViewController
            
            guard let userInputValue = searchBar.text else { return }
            
            nextVC.vcTitle = userInputValue + "👀"
        default:
            print("default")
        }
    }
    
    fileprivate func pushVC() {
        var segueID = ""
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            segueID = "goToPhotoCollectionVC"
        case 1:
            segueID = "goToUserListVC"
        default:
            segueID = "goToPhotoCollectionVC"
        }
        
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    // MARK: - ACTIONS

    @IBAction func searchBtnTouched(_ sender: UIButton) {
        pushVC()
    }
    
    @IBAction func filterValueChanged(_ sender: UISegmentedControl) {
        print("HomeVC")
        
        var searchBarTitle = ""
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        searchBar.placeholder = searchBarTitle + " 입력"
        searchBar.becomeFirstResponder() // searchBar에 포커싱 주기
    }
    
    // MARK: - HELPER
}

// MARK: - extension

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBtn.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                searchBar.resignFirstResponder() // 포커싱 해제
            }
            
        } else {
            searchBtn.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            view.makeToast("📣 검색 키워드를 입력해주세요", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        if inputTextCount >= 10 {
            view.makeToast("📣열 자까지만 입력 가능합니다.", duration: 1.0, position: .center)
        }
        
        return inputTextCount <= 10
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 예외처리
        if touch.view?.isDescendant(of: searchFilterSegment) == true || touch.view?.isDescendant(of: searchBar) == true {
            return false
        } else {
            view.endEditing(true) // view의 모든 편집과정이 끝났다.
            return true
        }
    }
}
