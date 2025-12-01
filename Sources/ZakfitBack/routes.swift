import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    try app.register(collection: UserController())
    try app.register(collection: AuthController())
    try app.register(collection: MealController())
    try app.register(collection: MealItemController())
    try app.register(collection: CustomMealItemController())
    try app.register(collection: MealTypeController())
    try app.register(collection: MealGoalController())
//    try app.register(collection: ActivityController())
    try app.register(collection: ActivityGoalController())
    try app.register(collection: ActivityTypeController())
    
}
