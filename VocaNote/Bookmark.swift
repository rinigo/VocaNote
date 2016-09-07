//
//  Bookmark.swift
//  VocaNote
//
//  Created by 宮本琳太郎 on 2016/09/06.
//  Copyright © 2016年 rintaro. All rights reserved.
//

import UIKit

class Bookmark: NSObject {
    var Bookmarks: Array<Word> = []
    
    func addBookmark(word: Word ){
        self.Bookmarks.insert(word, atIndex: 0)
    }
}
