import Combine
import Realm
import RealmSwift

final class RealmManager: RealmManaging {
    private let realm = try? Realm()
    private let realmQueue: DispatchQueue = DispatchQueue(label: "realmQueue")
    private let updatePolicy: Realm.UpdatePolicy = .modified
    
    private enum RealmError: Error {
        case realmConstructionError
    }
    
    private init() {}
    
    static let shared: RealmManaging = {
        RealmManager()
    }()
    
    func objects<T: Object>(ofType: T.Type) -> AnyPublisher<[T], Error> {
        Future { promise in
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
    
    func delete<T: Object>(dataOfType: T.Type, 
                           forPredicate: NSPredicate? = nil) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self,
                    let realm = realm else {
                return promise(Result.failure(RealmError.realmConstructionError))
            }
            
            var newPredicate: NSPredicate
            if let predicate = forPredicate {
                newPredicate = predicate
            } else {
                newPredicate = NSPredicate(value: true)
            }

            realm.writeAsync { [realm] in
                realm.delete(
                    realm.objects(T.self)
                        .filter(newPredicate)
                )
                
                return promise(Result.success(()))
            }
        }
        .eraseToAnyPublisher()
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
    static var shared: RealmManaging { get }
    
    func objects<T: Object>(ofType: T.Type) -> AnyPublisher<[T], Error>
    func updateObjects<T: Object>(with data: [T])
    func delete<T: Object>(dataOfType: T.Type,
                           forPredicate: NSPredicate?) -> AnyPublisher<Void, Error>
    func deleteAllData()
}

extension RealmManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
