//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Abdallah ElMenoufy on 3/8/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
   }
}
