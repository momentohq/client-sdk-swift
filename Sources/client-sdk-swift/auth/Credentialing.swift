//
//  File.swift
//  
//
//  Created by Pete Gautier on 11/6/23.
//

import Foundation

public protocol Credentialing {
    func getAuthToken() -> String
    func getControlEndpoint() -> String
    func getCacheEndpoint() -> String
//    static func fromEnvironmentVariable(envVariableName: String) -> Credentialing
//    static func fromString(authToken: String) -> Credentialing
}
