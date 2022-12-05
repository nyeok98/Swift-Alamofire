# Unsplash API

## As-Is
- Use Modals between Views
- Use Segment Control to manipulate cases
- Use Toast-Swift for error alert
- Fetch Data by using Alamofire
- Inject Header and all the common parameters from Interceptor
- Error handling from Interceptor
- Use SwiftyJSON for JSON parsing
- Fetching Data from HomeVC to PhotoColectionVC and UserListVC
- Set CollectionView in PhotoCollecitonVC
- Replace API call in GCD completion to RxSwift event base

## To-Do
- Set TableView in UserListVC
- Set DetailView over PhotoCollectionView

</br>
</br>

## It seems like...(UI completed, 2022.11.29)

<img width="200" src="https://user-images.githubusercontent.com/57023279/204528428-422e6265-bf5c-40f5-8525-1abdfe277b7e.gif">


## First time to adap RxSwift(wanna improve this)

```
func getPhoto(_ urlString: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            DispatchQueue.global().async {
                let url = URL(string: urlString)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let cellPhoto = UIImage(data: imageData)

                    DispatchQueue.main.sync {
                        emitter.onNext(cellPhoto)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
```
