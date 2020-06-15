//
//  RoomCreationModel.swift
//  App
//
//  Created by Davide Fastoso on 04/06/2020.
//

import Foundation
import Vapor

public enum StatusRoom: String, Codable , CaseIterable{
    case inprogress
    case failed
    case completed
}
public enum TypeRoom: String,Codable,CaseIterable{
    case p2p
}
public struct Link : Content {
    public let partecipants: String
    public let recordings : String
    
    public init(partecipants : String , recordings : String){
        self.partecipants = partecipants
        self.recordings = recordings
    }
}
public struct NewRoom: Content{
    public let account_sid: String
    public let date_created : String //Make this a datestamp
    public let date_updated : String //Make this a datestamp
    public var status: StatusRoom = .inprogress //Make this enum = in-progress,failed,completed
    public var type : TypeRoom = .p2p //make this enum: peer-to-peer
    public let sid : String
    public let enable_turn : Bool //COULD be deprecated
    public let unique_name : String
    public let max_partecipants : Int
    public let duration : Int
    public let status_callback_method : String //Its an hhtp method
    public let status_callback : String //URI
    public let record_partecipants_on_connect: Bool
    public let video_codecs : [String] //make this enum = VP8 , H264. Not available in peer-to-peer rooms
    public let media_region : String //Not av in peer to peer
    public let end_time : String //Make this a datestamp
    public let url: String
    public let links : Link //URI_MAP
    
    public init(sid: String,
    status: StatusRoom,
    date_created : String,
    date_updated : String,
    accountSid : String,
    enable_turn : Bool,
    unique_name : String,
    status_call_back : String,
    status_call_back_method : String,
    endTime : String ,
    duration : Int,
    type : TypeRoom,
    max_partecipants : Int,
    record_partecipants_on_connect: Bool,
    video_codecs : String,
    media_region : String,
    url: String,
    links : Link
    )
    {
        self.sid = sid
        self.status = status
        self.date_created = date_created
        self.date_updated = date_updated
        self.account_sid = accountSid
        self.enable_turn = enable_turn
        self.unique_name = unique_name
        self.status_callback = status_call_back
        self.status_callback_method = status_call_back_method
        self.end_time = endTime
        self.duration = duration
        self.type = type
        self.max_partecipants = max_partecipants
        self.record_partecipants_on_connect = record_partecipants_on_connect
        self.video_codecs = [video_codecs]
        self.media_region = media_region
        self.url = url
        self.links = links
    }
}
