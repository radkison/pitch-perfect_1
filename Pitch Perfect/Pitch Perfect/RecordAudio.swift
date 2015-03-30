//
//  RecordAudio.swift
//  Pitch Perfect
//
//  Created by Robert Adkison on 3/23/15.
//  Copyright (c) 2015 Robert Adkison. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(nsurlFilePath: NSURL!, sTitle: String!){
        filePathUrl = nsurlFilePath
        title = sTitle
    }
}
