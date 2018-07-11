import Vapor
import FluentPostgreSQL
import Fluent

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    var commandConfig = CommandConfig.default()
    commandConfig.use(RevertCommand.self, as: "revert")
    services.register(commandConfig)

    // Configure a database.
    try services.register(FluentPostgreSQLProvider())
    var databases = DatabasesConfig()

    let databaseName = Environment.get("DATABASE_DB") ?? "test_timestamps"
    let databasePort = 5432

    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"

    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: hostname,
        // 2
        port : databasePort,
        username: username,
        database: databaseName,
        password: password
    )

    let postgreSQLDatabase = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: postgreSQLDatabase, as: .psql)
    if (env != .testing) {
        databases.enableLogging(on: .psql)
    }
    services.register(databases)

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)
}
