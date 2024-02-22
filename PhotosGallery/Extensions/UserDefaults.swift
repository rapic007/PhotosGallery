import UIKit


extension UserDefaults {
    
    public enum Keys:String {
        case save
    }
    
    func set <T: Encodable>(value: T, key: Keys) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }
    
    func get <T:Decodable>(key: Keys, type: T.Type ) -> T? {
     let decoder = JSONDecoder()
        
        guard let data = data(forKey: key.rawValue),
              let object = try? decoder.decode(type, from: data)
        else { return nil }
        return object
    }
    
    func remove(forKey key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
