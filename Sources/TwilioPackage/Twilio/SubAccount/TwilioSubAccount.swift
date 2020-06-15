//
//  File.swift
//  
//
//  Created by Davide Fastoso on 09/06/2020.
//

import Foundation
import Vapor

public protocol TwilioProviderAccount{
    func sendSubAccount(_ account: OutgoingSubAccount)-> EventLoopFuture<OutgoingSubAccount>
}

extension Twilio: TwilioProviderAccount {
    ///send future sub account
    ///
    /// - Parameters:
    ///   - content: outgoing new SubAccount
    ///   - container: Container
    /// - Returns: Future<Response>
    
    public func sendSubAccount(_ account: OutgoingSubAccount) -> EventLoopFuture<OutgoingSubAccount> {
        guard let configuration = self.configuration else {
                       fatalError("Twilio not configured. Use app.twilio.configuration = ...")
                   }
            return application.eventLoopGroup.future().flatMapThrowing { _ -> HTTPHeaders in
                let authKeyEncoded = try self.encode(accountId: configuration.accountId, accountSecret: configuration.accountSecret)
                var headers = HTTPHeaders()
                headers.add(name: .authorization, value: "Basic \(authKeyEncoded)")
                return headers
            }.flatMap { headers  -> EventLoopFuture<ClientResponse> in
                let twilioURI = URI(string: "https://api.twilio.com/2010-04-01/Accounts.json")
                return self.application.client.post(twilioURI, headers: headers) {
                    try $0.content.encode(account, as: .urlEncodedForm)
                }
            }.flatMapThrowing{ response in
               try response.content.decode(OutgoingSubAccount.self)
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
