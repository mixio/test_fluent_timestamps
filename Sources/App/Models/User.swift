//
//  User.swift
//  App
//
//  Created by jj on 11/07/2018.
//
import Foundation
import Vapor
import FluentPostgreSQL

final class User: PostgreSQLUUIDModel {
    static var createdAtKey: TimestampKey? = \.createdAt
    static var updatedAtKey: TimestampKey? = \.updatedAt

    var id: UUID?
    var name: String
    var age: UInt?
    var createdAt: Date?
    var updatedAt: Date?
    init(name: String, age: UInt? = nil) {
        self.name = name
        self.age = age
    }
}

extension User: Content { }
extension User: Parameter { }

extension User: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
        }
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return """
            user {
                fluentID: '\(String(describing: fluentID))',
                id: '\(String(describing: id))',
                name: '\(name)',
                age: '\(String(describing: age))',
                createdAt: '\(String(describing: createdAt))',
                updatedAt: '\(String(describing: updatedAt))'
            }
            """
    }
}
