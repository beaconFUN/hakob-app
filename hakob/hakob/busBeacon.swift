//
//  busBeacon.swift
//  hakob
//
//  Created by 佐藤秀輔 on 2017/11/22.
//  Copyright © 2017年 佐藤秀輔. All rights reserved.
//

class busBeacon {
    var busStopName: String?
    var major: Int?
    var minor: Int?
    
    init(name: String, major: Int, minor: Int){
        self.busStopName = name
        self.major = major
        self.minor = minor
    }
}
