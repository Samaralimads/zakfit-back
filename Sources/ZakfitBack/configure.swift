import NIOSSL
import Fluent
import FluentMySQLDriver
import Leaf
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // MARK: - CORS
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .PATCH, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent],
        allowCredentials: true
    )
    
    app.middleware.use(CORSMiddleware(configuration: corsConfig))

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
    app.migrations.add(ActivityTypeSeeds())
    app.migrations.add(MealItemSeeds())
    
    
    try await app.autoMigrate()
    
    app.views.use(.leaf)
    
    // MARK: - JWT Signer
    app.jwt.signers.use(.hs256(key: Environment.get("JWT_SECRET")!))
    // MARK: - Routes
    
    try routes(app)
}
