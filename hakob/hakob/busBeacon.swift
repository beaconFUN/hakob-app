//
//  busBeacon.swift
//  hakob
//
//  Created by satoto on 2017/12/07.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

class busBeacon {
    var busRoute: [String]?
    var major: Int?
    var minor: Int?
    
    init(route: [String], major: Int, minor: Int){
        self.busRoute = route
        self.major = major
        self.minor = minor
    }
}
