import Realm
import RealmSwift

class RealmManager: RealmManaging {
    private var realm: Realm = try! Realm(configuration: .defaultConfiguration, queue: realmQueue)
    static let realmQueue: DispatchQueue = DispatchQueue(label: "realmQueue")
    private let updatePolicy: Realm.UpdatePolicy = .modified
    
    static var shared: RealmManaging {
        RealmManager()
    }
    
    private init() {}
    
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        if !isRealmAccessible() { return nil }
        realm.refresh()
        
        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }
    
    func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        if !isRealmAccessible() { return nil }
        realm.refresh()
        
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    func add<T: Object>(_ data: [T]) {
        if !isRealmAccessible() { return }
        realm.refresh()
        
        if realm.isInWriteTransaction {
            realm.add(data, update: updatePolicy)
        } else {
            try? realm.write {
                realm.add(data, update: updatePolicy)
            }
        }
    }
    
    func add<T: Object>(_ data: T) {
        add([data])
    }
    
    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }
        realm.refresh()
        
        try? realm.write {
            action()
        }
    }
    
    func delete<T: Object>(_ data: [T]) {
        if !isRealmAccessible() { return }
        realm.refresh()
        
        try? realm.write { realm.delete(data) }
    }
    
    func delete<T: Object>(_ data: T) {
        delete([data])
    }
    
    func clearAllData() {
        if !isRealmAccessible() { return }
        realm.refresh()
        
        try? realm.write { realm.deleteAll() }
    }
}

protocol RealmManaging {
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Results<T>?
    func object<T: Object>(_ type: T.Type, key: Any) -> T?
    func add<T: Object>(_ data: [T])
    func add<T: Object>(_ data: T)
    func runTransaction(action: () -> Void)
    func delete<T: Object>(_ data: [T])
    func delete<T: Object>(_ data: T)
    func clearAllData()
}

extension RealmManager {
    func isRealmAccessible() -> Bool {
        do { _ = try Realm() } catch {
            return false
        }
        return true
    }

    func configureRealm() {
        let config = RLMRealmConfiguration.default()
        config.deleteRealmIfMigrationNeeded = true
        RLMRealmConfiguration.setDefault(config)
    }
}
