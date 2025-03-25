import Foundation

struct AbilityEntry: Codable {
    let ability: Ability
}

struct Ability: Codable {
    let name: String
}

struct Types: Codable {
    let name: String
}
