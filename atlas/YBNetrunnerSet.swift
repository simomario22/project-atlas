//
//  YBNetrunnerSet.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/20/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBNetrunnerSet: NSObject {
    var data:NSDictionary
    init(dictionary: NSDictionary){
        data = dictionary
        self.selected = true;
    }
    
    var name:String { return data["name"] as String }
    var code:String { return data["code"] as String }
    var idx:UInt { return (data["cyclenumber"] as UInt) * 10 + (data["number"] as UInt)  }
    
    var selected:Bool


}