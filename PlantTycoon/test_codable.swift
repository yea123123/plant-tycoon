import Foundation

// Test all models can encode/decode
print("Testing JSON serialization...")

// Test 1: Plant
let plant = Plant(type: .cactus, rarity: .common)
let plantData = try! JSONEncoder().encode(plant)
let plantDecoded = try! JSONDecoder().decode(Plant.self, from: plantData)
print("✅ Plant: OK")

// Test 2: Shelf
var shelf = Shelf()
let shelfData = try! JSONEncoder().encode(shelf)
let shelfDecoded = try! JSONDecoder().decode(Shelf.self, from: shelfData)
print("✅ Shelf: OK")

// Test 3: SeedInventory
let inventory = SeedInventory()
let inventoryData = try! JSONEncoder().encode(inventory)
let inventoryDecoded = try! JSONDecoder().decode(SeedInventory.self, from: inventoryData)
print("✅ SeedInventory: OK")

// Test 4: MarketTrend
let trend = MarketTrend()
let trendData = try! JSONEncoder().encode(trend)
let trendDecoded = try! JSONDecoder().decode(MarketTrend.self, from: trendData)
print("✅ MarketTrend: OK")

// Test 5: Employee
let employee = Employee(type: .gardener)
let employeeData = try! JSONEncoder().encode(employee)
let employeeDecoded = try! JSONDecoder().decode(Employee.self, from: employeeData)
print("✅ Employee: OK")

// Test 6: Location
let location = Location(type: .greenhouse)
let locationData = try! JSONEncoder().encode(location)
let locationDecoded = try! JSONDecoder().decode(Location.self, from: locationData)
print("✅ Location: OK")

print("\n🎉 All models serialize correctly!")
