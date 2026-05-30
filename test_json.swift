import Foundation

// Test JSON encoding/decoding
let encoder = JSONEncoder()
encoder.dateEncodingStrategy = .iso8601
encoder.outputFormatting = .prettyPrinted

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601

print("✅ JSON test configuration ready")
