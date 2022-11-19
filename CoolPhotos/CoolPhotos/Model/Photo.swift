//
//  Photo.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import Foundation

struct Photo: Codable {
    var thumbnail: String
    var username: String
    var likesCount: Int
    var createdAt: String
}
