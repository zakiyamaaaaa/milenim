//
//  SwipeResult.swift
//  prototype04
//
//  Created by shoichiyamazaki on 2017/09/10.
//  Copyright © 2017年 shoichiyamazaki. All rights reserved.
//

import Foundation

//スワイプ結果を送るためのクラス
class SwipeResultManager{
    
    init() {
        
    }
    
    static var shared = SwipeResultManager()
    
    var encounteredUser:[String] = []
    var likedUser:[String] = []
    
    
    func reset(){
        encounteredUser = []
        likedUser = []
    }
    
}
