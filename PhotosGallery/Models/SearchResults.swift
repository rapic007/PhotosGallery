import UIKit

struct SearchResults: Codable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Codable {
    let width: Int
    let height: Int
    let urls: [URLType.RawValue: String]
    
    enum URLType: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
