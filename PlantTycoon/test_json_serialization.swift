import Foundation

// Test JSON serialization
print("Testing JSON serialization...")

do {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    // Test SeedInventory
    let inventory = SeedInventory()
    let data = try encoder.encode(inventory)
    let decoded = try decoder.decode(SeedInventory.self, from: data)
    print("✅ SeedInventory: OK")
    
    print("\n🎉 All JSON tests passed!")
} catch {
    print("❌ Error: \(error)")
}
