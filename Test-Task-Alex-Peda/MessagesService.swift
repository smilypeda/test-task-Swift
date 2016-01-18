//
//  MessagesService.swift
//  Test-Task-Alex-Peda
//
//  Created by Alex Peda on 1/13/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

import UIKit
import Alamofire

class MessagesService: NSObject {
    
    internal func loadMessages(completion: (([Message]?) -> ())?) {
        Alamofire.request(.GET, "https://gaterest.fxclub.org/Backend/Dicts/IOS/messages/ru_RU/data")
            .responseJSON { response in
                
                var messages: [Message]?
                if let data = response.data {
                    messages = MessagesMapper(data: data).messages
                }
                
                if let completionClosure = completion {
                    completionClosure(messages)
                }
        }
    }
}
