//
//  Word.swift
//  VocaNote
//
//  Created by 宮本琳太郎 on 2016/08/06.
//  Copyright © 2016年 rintaro. All rights reserved.
//

import UIKit

class Word: NSObject {
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    var name:String
    var id:String
//    var meaning = ""
}
