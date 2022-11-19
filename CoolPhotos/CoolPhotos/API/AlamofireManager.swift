//
//  AlamofireManager.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import Alamofire
import Foundation

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
}
