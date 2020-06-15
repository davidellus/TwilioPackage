//
//  TwilioRoom.swift
//  App
//
//  Created by Davide Fastoso on 08/06/2020.
//

import Foundation
import Vapor

public protocol TwilioProvider {
    func sendRoom(_ room: OutgoingRoom) -> EventLoopFuture<OutgoingRoom>
}

public struct Twilio: TwilioProvider {
    let application: Application
    
    public init (_ app: Application) {
        application = app
    }
}

// MARK: - Configuration

extension Twilio {
    struct ConfigurationKey: StorageKey {
        typealias Value = TwilioConfiguration
    }

    public var configuration: TwilioConfiguration? {
        get {
            application.storage[ConfigurationKey.self]
        }
        nonmutating set {
            application.storage[ConfigurationKey.self] = newValue
        }
    }
}

// MARK: Send Room request
extension Twilio {
    /// Send Room request
    ///
    /// - Parameters:
    ///   - content: outgoing new Room
    ///   - container: Container
    /// - Returns: Future<Response>
    
    public func sendRoom(_ room: OutgoingRoom) -> EventLoopFuture<OutgoingRoom>{
        guard let configuration = self.configuration else {
                   fatalError("Twilio not configured. Use app.twilio.configuration = ...")
               }
        return application.eventLoopGroup.future().flatMapThrowing { _ -> HTTPHeaders in
            let authKeyEncoded = try self.encode(accountId: configuration.accountId, accountSecret: configuration.accountSecret)
            var headers = HTTPHeaders()
            headers.add(name: .authorization, value: "Basic \(authKeyEncoded)")
            return headers
        }.flatMap { headers  -> EventLoopFuture<ClientResponse> in
            let twilioURI = URI(string: "https://video.twilio.com/v1/Rooms/")
            return self.application.client.post(twilioURI, headers: headers) {
                try $0.content.encode(room, as: .urlEncodedForm)
            }
        }.flatMapThrowing{ response in
           try response.content.decode(OutgoingRoom.self)
        }
    }
    
}

fileprivate extension Twilio {
    func encode(accountId: String, accountSecret: String) throws -> String {
        guard let apiKeyData = "\(accountId):\(accountSecret)".data(using: .utf8) else {
            throw TwilioError.encodingProblem
        }
        let authKey = apiKeyData.base64EncodedData()
        guard let authKeyEncoded = String.init(data: authKey, encoding: .utf8) else {
            throw TwilioError.encodingProblem
        }

        return authKeyEncoded
    }
}

extension Application {
    public var twilio: Twilio { .init(self) }
}

extension Request {
    public var twilio: Twilio { .init(application) }
}
