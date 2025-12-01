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
        hostname: Environment.get("DB_HOST") ?? "localhost",
        port: Environment.get("DB_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DB_USERNAME") ?? "vapor_username",
        password: Environment.get("DB_PASSWORD") ?? "vapor_password",
        database: Environment.get("DB_NAME") ?? "vapor_database"
    ), as: .mysql)
    
    
    //MARK: - Migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateMealType())
    app.migrations.add(CreateMealItem())
    app.migrations.add(CreateCustomMealItem())
    app.migrations.add(CreateMealGoal())
    app.migrations.add(CreateMeal())
    app.migrations.add(CreateActivityType())
    app.migrations.add(CreateActivity())
    app.migrations.add(CreateActivityGoal())
    
    //MARK: - Seeds
    app.migrations.add(MealTypeSeeds())
    
    
    try await app.autoMigrate()
    
    app.views.use(.leaf)
    
    // MARK: - JWT Signer
    app.jwt.signers.use(.hs256(key: Environment.get("JWT_SECRET")!))
    // MARK: - Routes
    
    try routes(app)
}
