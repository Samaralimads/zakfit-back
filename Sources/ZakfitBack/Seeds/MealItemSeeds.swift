//
//  MealItemSeeds.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct MealItemSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        let mealItemsData: [(String, Int, String, Int, Int, Int, Int)] = [
            ("Oatmeal", 50, "g", 150, 5, 27, 3),
            ("Banana", 1, "regular", 90, 1, 23, 0),
            ("Almonds", 28, "g", 170, 6, 6, 15),
            ("Greek Yogurt", 150, "g", 100, 10, 4, 0),
            ("Apple", 1, "regular", 80, 0, 22, 0),
            ("Orange", 1, "regular", 70, 1, 17, 0),
            ("Avocado", 100, "g", 160, 2, 9, 15),
            ("Broccoli", 100, "g", 55, 4, 11, 0),
            ("Carrot", 100, "g", 40, 1, 10, 0),
            ("Quinoa", 50, "g", 120, 4, 21, 2),
            ("Spinach", 100, "g", 25, 3, 4, 0),
            ("Sweet Potato", 150, "g", 100, 2, 23, 0),
            ("Chickpeas", 100, "g", 180, 9, 30, 3),
            ("Lentils", 100, "g", 160, 12, 27, 0),
            ("Brown Rice", 50, "g", 110, 3, 23, 1),
            ("Tofu", 100, "g", 80, 8, 2, 5),
            ("Tempeh", 100, "g", 190, 19, 9, 11),
            ("Mushrooms", 100, "g", 20, 3, 3, 0),
            ("Zucchini", 100, "g", 20, 1, 4, 0),
            ("Eggplant", 100, "g", 25, 1, 6, 0),
            ("Peanut Butter", 32, "g", 190, 8, 6, 16),
            ("Walnuts", 28, "g", 185, 4, 4, 18),
            ("Cashews", 28, "g", 155, 5, 9, 12),
            ("Strawberries", 100, "g", 35, 1, 8, 0),
            ("Blueberries", 100, "g", 40, 1, 10, 0),
            ("Raspberries", 100, "g", 30, 1, 7, 0),
            ("Blackberries", 100, "g", 35, 1, 9, 0),
            ("Cucumber", 100, "g", 15, 1, 3, 0),
            ("Tomato", 100, "g", 20, 1, 4, 0),
            ("Bell Pepper", 100, "g", 25, 1, 6, 0),
            ("Kale", 100, "g", 35, 3, 7, 0),
            ("Peas", 100, "g", 80, 5, 14, 0),
            ("Corn", 100, "g", 90, 3, 19, 1),
            ("Green Beans", 100, "g", 35, 2, 8, 0),
            ("Cauliflower", 100, "g", 25, 2, 5, 0),
            ("Brussels Sprouts", 100, "g", 40, 3, 8, 0),
            ("Pumpkin", 100, "g", 30, 1, 8, 0),
            ("Coconut", 28, "g", 150, 1, 6, 14),
            ("Chia Seeds", 28, "g", 140, 5, 12, 9),
            ("Flax Seeds", 28, "g", 150, 5, 8, 12),
            ("Sunflower Seeds", 28, "g", 165, 5, 6, 14),
            ("Pumpkin Seeds", 28, "g", 180, 9, 4, 14),
            ("Whole Wheat Bread", 50, "g", 120, 5, 20, 2),
            ("Brown Pasta", 50, "g", 180, 7, 37, 1),
            ("Couscous", 50, "g", 175, 6, 36, 1),
            ("Barley", 50, "g", 150, 5, 33, 1),
            ("Edamame", 100, "g", 120, 11, 10, 5),
            ("Soy Milk", 240, "ml", 80, 7, 4, 4),
            ("Almond Milk", 240, "ml", 40, 1, 2, 3),
            ("Rice Milk", 240, "ml", 120, 1, 23, 2),
            ("Hummus", 30, "g", 70, 2, 4, 5),
            ("Olives", 30, "g", 50, 0, 2, 5),
            ("Feta Cheese", 30, "g", 75, 4, 1, 6),
            ("Mozzarella", 30, "g", 85, 6, 1, 6),
            ("Parmesan", 30, "g", 110, 10, 1, 7),
            ("Ricotta", 30, "g", 100, 6, 2, 8),
            ("Cottage Cheese", 100, "g", 90, 11, 3, 2),
            ("White Rice", 50, "g", 180, 4, 40, 0),
            ("Black Beans", 100, "g", 130, 9, 23, 0),
            ("Kidney Beans", 100, "g", 120, 8, 22, 0),
            ("Plain Yogurt", 150, "g", 90, 6, 8, 3),
            ("Whole Wheat Pasta", 50, "g", 180, 7, 37, 1),
            ("Bread", 50, "g", 120, 5, 20, 2),
            ("Miso Paste", 20, "g", 35, 2, 4, 1),
            ("Nori Sheets", 5, "g", 10, 1, 1, 0),
            ("Kefir", 150, "ml", 60, 4, 7, 2),
            ("Ricotta Cheese", 100, "g", 100, 6, 2, 8),
            ("Oat Milk", 240, "ml", 120, 3, 16, 5),
            ("Chicken Breast", 100, "g", 165, 31, 0, 3),
            ("Ground Beef 90% Lean", 100, "g", 250, 26, 0, 17),
            ("Pork Loin", 100, "g", 242, 27, 0, 14),
            ("Salmon", 100, "g", 208, 20, 0, 13),
            ("Tuna", 100, "g", 132, 28, 0, 1),
            ("Shrimp", 100, "g", 99, 24, 0, 1),
            ("Egg (whole)", 50, "g", 70, 6, 1, 5),
            ("Egg White", 33, "g", 17, 4, 0, 0),
            ("Turkey Breast", 100, "g", 135, 29, 0, 1),
            ("Cod", 100, "g", 82, 18, 0, 0)
        ]
        
        for item in mealItemsData {
            let mealItem = MealItem(
                name: item.0,
                servingSize: item.1,
                servingUnit: item.2,
                kcalServing: item.3,
                proteinServing: item.4,
                carbsServing: item.5,
                fatServing: item.6
            )
            try await mealItem.save(on: db)
        }
    }
    
    func revert(on db: any Database) async throws {
        try await db.query(MealItem.self).delete()
    }
}
