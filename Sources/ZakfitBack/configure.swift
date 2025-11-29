import NIOSSL
import Fluent
import FluentMySQLDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .mysql)

    //MARK: - MIGRATIONS
    app.migrations.add(CreateUser())
    app.migrations.add(CreateMealType())
    app.migrations.add(CreateMealItem())
    app.migrations.add(CreateMealGoal())
    app.migrations.add(CreateMeal())
    app.migrations.add(CreateCustomMealItem())
    app.migrations.add(CreateActivityType())
    app.migrations.add(CreateActivityGoal())
    app.migrations.add(CreateActivity())
    
    try await app.autoMigrate()

    app.views.use(.leaf)

    try routes(app)
}
