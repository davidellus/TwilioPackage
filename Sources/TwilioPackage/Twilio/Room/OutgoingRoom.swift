//
//  OutgoingRoom.swift
//  App
//
//  Created by Davide Fastoso on 08/06/2020.
//

import Foundation
import Vapor
import CryptoSwift

public struct OutgoingRoom : Content {
    public let uniqueName: String
    
    public init(uniqueName: String){
        self.uniqueName = uniqueName
    }
    
    public enum CodingKeys : String,CodingKey{
        case uniqueName = "UniqueName"
    }
}

