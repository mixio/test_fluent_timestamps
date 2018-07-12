@testable import App
import Vapor
import XCTest
import FluentPostgreSQL
import JJTools

final class UserTests: XCTestCase {

    let userName = "Test user"
    let usersURI = "/api/users/"
    var app: Application!
    var conn: PostgreSQLConnection!
    
    override func setUp() {
        do {
            try Application.reset()
            app = try Application.testable()
            conn = try app.newConnection(to: .psql).wait()
        } catch {
            fatalError("\(error)")
        }
    }

    override func tearDown() {
        conn.close()
    }

    func testUsersCanBeRetrievedFromAPI() throws {
        let user1 = try User.create(name: userName, on: conn)
        let user2 = try User.create(on: conn)

        let users = try app.getResponse(to: usersURI, decodeTo: [User].self)

        XCTAssertEqual(users.count, 2)

        let api_user1 = users[0]
        XCTAssertEqual(api_user1.name, user1.name)
        XCTAssertEqual(api_user1.id, user1.id)
        XCTAssertNotNil(api_user1.createdAt)
        XCTAssertNotNil(api_user1.updatedAt)
        XCTAssertEqual("\(api_user1.createdAt!)", "\(user1.createdAt!)")
        XCTAssertEqual("\(api_user1.updatedAt!)", "\(user1.updatedAt!)")
        XCTAssertEqual("\(api_user1.createdAt!)", "\(api_user1.updatedAt!)")

        let api_user2 = users[1]
        XCTAssertEqual(api_user2.name, user2.name)
        XCTAssertEqual(api_user2.id, user2.id)
        XCTAssertNotNil(api_user2.createdAt)
        XCTAssertNotNil(api_user2.updatedAt)
        XCTAssertEqual("\(api_user2.createdAt!)", "\(user2.createdAt!)")
        XCTAssertEqual("\(api_user2.updatedAt!)", "\(user2.updatedAt!)")
        XCTAssertEqual("\(api_user2.createdAt!)", "\(api_user2.updatedAt!)")
    }

    func testUserCanBeSavedWithAPI() throws {
        let user = User(name: userName)
        let receivedUser = try app.getResponse(to: usersURI, method: .POST, headers: ["Content-Type": "application/json"], data: user, decodeTo: User.self, loggedInRequest: true)

        XCTAssertEqual(receivedUser.name, userName)
        XCTAssertNotNil(receivedUser.id)

        let users = try app.getResponse(to: usersURI, decodeTo: [User].self)

        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users[0].name, userName)
        XCTAssertEqual(users[0].id, receivedUser.id)
    }

    func testGettingASingleUserFromTheAPI() throws {
        let user = try User.create(name: userName, on: conn)
        let receivedUser = try app.getResponse(to: "\(usersURI)\(user.id!)", decodeTo: User.self)

        XCTAssertEqual(receivedUser.name, userName)
        XCTAssertEqual(receivedUser.id, user.id)
    }

    func testUpdateUserbyPutWithTheAPI() throws {
        let user = try User.create(name: userName, on: conn)
        let updatedName = "\(user.name) UPDATED"
        user.name = updatedName
        Thread.sleep(forTimeInterval: 2) // Sleep for 2 seconds before updating.
        let updatedUser = try app.getResponse(to: "\(usersURI)\(user.id!)", method: .PUT, headers: ["Content-Type": "application/json"], data: user, decodeTo: User.self, loggedInRequest: true)

        XCTAssertEqual(updatedUser.name, updatedName)
        XCTAssertEqual(updatedUser.id, user.id)
        XCTAssertNotNil(updatedUser.createdAt)
        XCTAssertNotNil(updatedUser.updatedAt)
        XCTAssertNotEqual("\(updatedUser.createdAt!)", "\(updatedUser.updatedAt!)")
        jjprint("ℹ️ createdAt:\(updatedUser.createdAt!), updatedAt:\(updatedUser.updatedAt!)")

    }

    func testUpdateUserByPostWithTheAPI() throws {
        let user = try User.create(name: userName, on: conn)
        let updatedName = "\(user.name) UPDATED"
        user.name = updatedName
        Thread.sleep(forTimeInterval: 2) // Sleep for 2 seconds before updating.
        let updatedUser = try app.getResponse(to: "\(usersURI)\(user.id!)", method: .POST, headers: ["Content-Type": "application/json"], data: user, decodeTo: User.self, loggedInRequest: true)

        XCTAssertEqual(updatedUser.name, updatedName)
        XCTAssertEqual(updatedUser.id, user.id)
        XCTAssertNotNil(updatedUser.createdAt)
        XCTAssertNotNil(updatedUser.updatedAt)
        XCTAssertNotEqual("\(updatedUser.createdAt!)", "\(updatedUser.updatedAt!)")
        jjprint("ℹ️ createdAt:\(updatedUser.createdAt!), updatedAt:\(updatedUser.updatedAt!)")

    }

    static let allTests = [
        ("testUsersCanBeRetrievedFromAPI", testUsersCanBeRetrievedFromAPI),
        ("testUserCanBeSavedWithAPI", testUserCanBeSavedWithAPI),
        ("testGettingASingleUserFromTheAPI", testGettingASingleUserFromTheAPI),
        ("testUpdateUserbyPutWithTheAPI", testUpdateUserbyPutWithTheAPI),
        ("testUpdateUserByPostWithTheAPI", testUpdateUserByPostWithTheAPI),
    ]

}

extension User {
    static func create(name: String = "Anonymous", username: String? = nil, on connection: PostgreSQLConnection) throws -> User {
        let user = User(name: name)
        return try user.save(on: connection).wait()
    }
}
