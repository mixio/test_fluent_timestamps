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
    var createdAt: Date?
    var updatedAt: Date?
    init(name: String) {
        self.name = name
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

