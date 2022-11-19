//
//  Logger.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import Alamofire
import Foundation

final class Logger: EventMonitor {
    let queue = DispatchQueue(label: "ApiLog")

    func requestDidResume(_ request: Request) {
        print("Logger - requestDidResume()")
        debugPrint(request)
    }

    func request<Value>(_ request: DownloadRequest, didParseResponse response: DownloadResponse<Value, AFError>) {
        print("Logger - requestDidParseResponse()")
        debugPrint(request)
    }
}
