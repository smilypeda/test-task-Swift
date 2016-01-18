//
//  Message.swift
//  Test-Task-Alex-Peda
//
//  Created by Alex Peda on 1/13/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

import UIKit

class Message: NSObject {
    private(set) internal var id: String?
    private(set) internal var text: String?
    private(set) internal var rawJSON: String?
    
    init(id: String?, text: String?, rawJSON: String?) {
        super.init()
        self.id = id
        self.text = text
        self.rawJSON = rawJSON
    }
}
