import Combine
import Foundation

final class SettingsRepository: SettingsRepositoryProtocol {
    @Inject private var realmManager: RealmManaging
    
    func getSettings() -> AnyPublisher<SettingsModel?, Error> {
        realmManager.objects(ofType: SettingsObject.self)
            .map { $0 }
            .map { $0.last?.toModel }
            .eraseToAnyPublisher()
    }
    
    func updateSettings(_ settings: SettingsModel) {
        realmManager.updateObjects(with: [settings.toObject])
    }
    
    func deleteAllSettings() -> AnyPublisher<Void, Error> {
        return realmManager.delete(dataOfType: SettingsObject.self, forPredicate: nil)
            .eraseToAnyPublisher()
    }
}

protocol SettingsRepositoryProtocol {
    func getSettings() -> AnyPublisher<SettingsModel?, Error>
    func updateSettings(_ settings: SettingsModel)
    func deleteAllSettings() -> AnyPublisher<Void, Error>
}
