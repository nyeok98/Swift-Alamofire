//
//  Model.swift
//  BasicMethods
//
//  Created by NYEOK on 2022/11/30.
//

import Foundation

struct DataModel: Decodable {
    var id: Int
    var title: String
    var userId: Int
}

struct User: Decodable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
}

struct Address: Decodable {
    var street: String
    var suite: String
}
