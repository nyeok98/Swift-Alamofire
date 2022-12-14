//
//  ViewController.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import Alamofire
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
    
    var userData: [User]?
    var photoData: [Photo]?
    
    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 기본 UI 설정
        imageView.image = UIImage(named: "logo")
        searchBar.delegate = self
        keyboardDismissTabGesture.delegate = self
        view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // AUTH_FAIL NOTIFICATION OBSERVER
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // AUTH_FAIL NOTIFICATION OBSERVER RELEASE
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            let nextVC = segue.destination as! UserListViewController
            
            guard let userInputValue = searchBar.text else { return }
            
            nextVC.vcTitle = userInputValue + "👨‍💻"
            nextVC.userData = userData
            
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionViewController
            
            guard let userInputValue = searchBar.text else { return }
            
            nextVC.vcTitle = userInputValue + "👀"
            nextVC.photoData = photoData
            
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

    @IBAction func onSearchBtnClicked(_ sender: UIButton) {
        guard let userInput = searchBar.text else { return }
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            AlamofireManager
                .shared
                // weak를 사용하는 이유는 원래 self 선언은 ARC 카운트를 증가시키지만,
                // weak 선언시 사용후 메모리 해제를 통해 관리를 돕기 위함이다.
                .getPhotos(searchTerm: userInput) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let fetchedPhotos):
                        print("HomeVC - getPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                        self.photoData = fetchedPhotos
                        self.pushVC()
                    case .failure(let error):
                        print("HomeVC - getPhotos.failure - error : \(error.rawValue)")
                        self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                    }
                }
        case 1:
            AlamofireManager
                .shared
                // weak를 사용하는 이유는 원래 self 선언은 ARC 카운트를 증가시키지만,
                // weak 선언시 사용후 메모리 해제를 통해 관리를 돕기 위함이다.
                .getUsers(searchTerm: userInput) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let fetchedUsers):
                        print("HomeVC - getUsers.success - getchedUsers.count : \(fetchedUsers.count)")
                        self.userData = fetchedUsers
                        self.pushVC()
                    case .failure(let error):
                        print("HomeVC - getUsers.failure - error : \(error.rawValue)")
                        self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                    }
                }
        default:
            print("default")
        }
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
    
    @objc func showErrorPopup(notification: NSNotification) {
        print("HomeVC - showErrorPopup()")
        
        DispatchQueue.main.async {
            if let data = notification.userInfo?["statusCode"] {
                print("showErrorPopup() data: \(data)")
                
                self.view.makeToast("🙏 \(data) 에러 입니다.", duration: 1.0, position: .center)
            }
        }
    }
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
