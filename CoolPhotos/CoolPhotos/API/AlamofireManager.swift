//
//  AlamofireManager.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import Alamofire
import Foundation
import SwiftyJSON

final class AlamofireManager {
    // SINGLETON
    static let shared = AlamofireManager()

    // Interceptor to inject all the common parameters
    let interceptors = Interceptor(interceptors:
        [
            BaseInterceptor()
        ])

    // Logger
    let monitors = [Logger()] as [EventMonitor]

    // Session
    var session = Session()

    private init() {
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors
        )
    }

    func getPhotos(searchTerm userInput: String, completion: @escaping (Result<[Photo], RandomError>) -> Void) {
        session
            .request(SearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200 ... 401)
            .responseJSON { response in

                guard let responseValue = response.value else { return }

                let responseJSON = JSON(responseValue)

                let jsonArray = responseJSON["results"]

                var photos = [Photo]()

                print("jsonArray.count: \(jsonArray.count)")

                for (_, subJSON): (String, JSON) in jsonArray {
                    // Parsing data
                    let thumbnail = subJSON["urls"]["thumb"].string ?? ""
                    let username = subJSON["user"]["username"].string ?? ""
                    let likesCount = subJSON["likes"].intValue
                    let createdAt = subJSON["createdAt"].string ?? ""

                    let photoItem = Photo(thumbnail: thumbnail, username: username, likesCount: likesCount, createdAt: createdAt)

                    photos.append(photoItem)
                }

                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(.noContent))
                }
            }
    }

    func getUsers(searchTerm userInput: String, completion: @escaping (Result<[User], RandomError>) -> Void) {
        session
            .request(SearchRouter.searchUsers(term: userInput))
            .validate(statusCode: 200 ... 401)
            .responseJSON { response in

                guard let responseValue = response.value else { return }

                let responseJSON = JSON(responseValue)

                let jsonArray = responseJSON["results"]

                var users = [User]()

                print("jsonArray.count: \(jsonArray.count)")

                for (_, subJSON): (String, JSON) in jsonArray {
                    // Parsing data
                    let username = subJSON["username"].string ?? ""
                    let totalLikes = subJSON["total_likes"].intValue
                    let profileImage = subJSON["profile_image"].string ?? ""

                    let userItem = User(username: username, profileImage: profileImage, totalLikes: totalLikes)

                    users.append(userItem)
                }

                if users.count > 0 {
                    completion(.success(users))
                } else {
                    completion(.failure(.noContent))
                }
            }
    }
}
