import Combine
import Realm
import RealmSwift

class RealmManager: RealmManaging {
    private let realmQueue: DispatchQueue = DispatchQueue(label: "realmQueue")
    private let updatePolicy: Realm.UpdatePolicy = .modified
    
    private enum RealmError: Error {
        case realmConstructionError
    }
    
    static var shared: RealmManaging {
        RealmManager()
    }
    
    private init() {}
    
    func objects<T: Object>(ofType: T) -> AnyPublisher<[T], Error> {
        return Future { promise in
            self.realmQueue.async {
                do {
                    guard let realm = try? Realm(configuration: .defaultConfiguration) else {
                        return promise(Result.failure(RealmError.realmConstructionError))
                    }
                    
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
    
    func updateObjects<T: Object>(with data: [T]) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.realmQueue.async {
                guard let realm = try? Realm(configuration: .defaultConfiguration) else {
                    return promise(Result.failure(RealmError.realmConstructionError))
                }

                realm.writeAsync { [realm] in
                    guard !data.isEmpty else {
                        return promise(Result.success(()))
                    }
                    
                    realm.add(data, update: self.updatePolicy)
                    
                    promise(Result.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete<T: Object>(data: [T]) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.realmQueue.async {
                guard let realm = try? Realm(configuration: .defaultConfiguration) else {
                    return promise(Result.failure(RealmError.realmConstructionError))
                }

                realm.writeAsync { [realm] in
                    guard !data.isEmpty else {
                        return promise(Result.success(()))
                    }
                    
                    realm.add(data, update: self.updatePolicy)
                    realm.delete(data)
                    
                    promise(Result.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func clearAllData() -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.realmQueue.async {
                guard let realm = try? Realm(configuration: .defaultConfiguration) else {
                    return promise(Result.failure(RealmError.realmConstructionError))
                }

                realm.writeAsync { [realm] in
                    realm.deleteAll()
                    return promise(Result.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

protocol RealmManaging {
    func objects<T: Object>(ofType: T) -> AnyPublisher<[T], Error>
    func updateObjects<T: Object>(with data: [T]) -> AnyPublisher<Void, Error>
    func delete<T: Object>(data: [T]) -> AnyPublisher<Void, Error>
    func clearAllData() -> AnyPublisher<Void, Error>
}

extension RealmManager {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
