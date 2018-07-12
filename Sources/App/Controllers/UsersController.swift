//
//  UserController.swift
//  App
//
//  Created by jj on 11/07/2018.
//

import Vapor
import JJTools

final class UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoutes = router.grouped("api", "users")
        usersRoutes.get(use: getAllHandler)
        usersRoutes.post(use: createHandler)
        usersRoutes.get(User.parameter, use: getHandler)
        usersRoutes.delete(User.parameter, use: deleteHandler)
        usersRoutes.put(User.parameter, use: updateHandler)
        usersRoutes.post(User.parameter, use: updateByPostHandler)
    }

    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    func createHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            jjprint(user)
            return user.save(on: req)
        }
    }

    func getHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }

    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap(to: HTTPStatus.self) { user in
            return user.delete(on:req).transform(to: HTTPStatus.noContent)
        }
    }

    func updateHandler(_ req: Request) throws -> Future<User> {
        return try flatMap(to: User.self, req.parameters.next(User.self), req.content.decode(User.self)) { user, updatedUser in
            user.name = updatedUser.name
            return user.save(on: req)
        }
    }

    func updateByPostHandler(_ req: Request) throws -> Future<User> {
        return try flatMap(to: User.self, req.parameters.next(User.self), req.content.decode(User.self)) { user, updatedUser in
            user.name = updatedUser.name
            return user.save(on: req)
        }
    }

}
