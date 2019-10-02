//
//  NetworkingManager.swift
//  8Ball
//
//  Created by Svyat Chaplin on 10/2/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

protocol NetworkingManager {

    func checkConnection() -> Bool
    func getDataFromInternet(complitionHandler: @escaping (Data?, Error?) -> Void)
    func decodingDataToString(data: Data) -> String
    func catchingDataErrors(error: Error?) -> String

}
