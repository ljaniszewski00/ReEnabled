import Combine
import Foundation
import RealmSwift

final class SettingsRepository: SettingsRepositoryProtocol {
    @Inject private var realmManager: RealmManaging
    
    func getSettings(from settingsObjects: Results<SettingsObject>) -> SettingsModel? {
        settingsObjects.last?.toModel
    }
    
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
    func getSettings(from settingsObjects: Results<SettingsObject>) -> SettingsModel?
    func getSettings() -> AnyPublisher<SettingsModel?, Error>
    func updateSettings(_ settings: SettingsModel)
    func deleteAllSettings() -> AnyPublisher<Void, Error>
}
