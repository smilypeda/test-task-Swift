//
//  MessagesMapper.swift
//  Test-Task-Alex-Peda
//
//  Created by Alex Peda on 1/13/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessagesMapper: NSObject {
    
    private(set) internal var messages: [Message]?
    
    init(data: NSData) {
        super.init()
        
        var messages = [Message]()
        let json = JSON(data: data, options: .MutableContainers, error: nil)
        if let protoMessages = json["Data"].array {
            for (subJson):(JSON) in protoMessages {
                if let dictionary = subJson.dictionary, let id = dictionary["Id"], let text = dictionary["Text"] {
                    messages.append(Message(id: String(id.intValue), text: text.string, rawJSON: String(subJson)))
                }
            }
        }
        self.messages = messages
    }
}
