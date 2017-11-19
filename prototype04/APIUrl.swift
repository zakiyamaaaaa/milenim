//
//  APIUrl.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/11/19.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import Foundation

class APIUrl{
    
    static let baseUrl = "http://52.163.126.71:80/test/"
    
    enum requestUrl:String {
        case requestMessageUserList = "requestMessageUserList.php"
        case updateLocation = "updateLocation.php"
    }
    
}
