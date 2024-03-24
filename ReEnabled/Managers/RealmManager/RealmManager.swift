import Combine
import Realm
import RealmSwift

class RealmManager: RealmManaging {
    private let realm = try? Realm()
    private let realmQueue: DispatchQueue = DispatchQueue(label: "realmQueue")
    private let updatePolicy: Realm.UpdatePolicy = .modified
    
    private enum RealmError: Error {
        case realmConstructionError
    }
    
    static var shared: RealmManaging {
        RealmManager()
    }
    
    private init() {}
    
    func objects<T: Object>(ofType: T.Type) -> AnyPublisher<[T], Error> {
        return Future { promise in
            self.realmQueue.async {
                do {
                    let realm = try Realm()
                    
                    if realm.isInWriteTransaction || realm.isPerformingAsynchronousWriteOperations {
                        try realm.commitWrite()
                    }
                    
                    let objects = realm.objects(T.self)
                    
                    promise(Result.success(objects.compactMap { $0 }))
                } catch {
                    promise(Result.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateObjects<T: Object>(with data: [T]) {
        guard let realm = realm else {
            return
        }

        realm.writeAsync { [realm] in
            guard !data.isEmpty else {
                return
            }
            
            realm.add(data, update: self.updatePolicy)
            
            return
        }
    }
    
    func delete<T: Object>(dataOfType: T.Type, with predicate: NSPredicate) {
        guard let realm = realm else {
            return
        }

        realm.writeAsync { [realm] in
            realm.delete(
                realm.objects(T.self)
                    .filter(predicate)
            )
            
            return
        }
    }
    
    func deleteAllData() {
        guard let realm = realm else {
            return
        }
        
        realm.writeAsync { [realm] in
            realm.deleteAll()
            return
        }
    }
}

protocol RealmManaging {
    func objects<T: Object>(ofType: T.Type) -> AnyPublisher<[T], Error>
    func updateObjects<T: Object>(with data: [T])
    func delete<T: Object>(dataOfType: T.Type, with predicate: NSPredicate)
    func deleteAllData()
}

extension RealmManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
