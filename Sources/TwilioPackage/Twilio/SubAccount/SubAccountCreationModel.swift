//
//  File.swift
//  
//
//  Created by Davide Fastoso on 09/06/2020.
//

import Foundation
import Vapor


public struct OutgoingSubAccount : Content {
    let friendlyName : String
    
    public init(friendlyName : String){
        self.friendlyName = friendlyName
    }
    
    private enum CodingKeys : String,CodingKey{
        case friendlyName = "friendly_name"
    }
}
