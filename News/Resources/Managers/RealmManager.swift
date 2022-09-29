//
//  RealmManager.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import RealmSwift
import Realm

final class RealmManager {
    
    static let shared = RealmManager()
    
    private var schemaVersion: UInt64 = 1
    
    private init() {
        prepareRealmDatabase()
    }
    
    func write(_ block: @escaping ((_ realm: Realm) -> Void)) {
        guard let realm = try? Realm() else { return }
        try? realm.write {
            block(realm)
        }
    }
    
    // MARK: - ADD OR UPDATE
    
    func addOrUpdate(object: Object) {
        write { realm in
            realm.add(object, update: .all)
        }
    }
    
    func addOrUpdate<T: Sequence>(objects: T) where T.Iterator.Element: Object {
        write { realm in
            realm.add(objects, update: .all)
        }
    }
    
    // MARK: - GET
    
    func getObject<T: Object, PrimaryKey>(primaryKey: PrimaryKey) -> T? {
        let realm = try? Realm()
        return realm?.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
    
    func getObjects<T: Object>(withFilter: String? = nil) -> Results<T>? {
        let realm = try? Realm()
        if let filter = withFilter {
            return realm?.objects(T.self).filter(filter)
        } else {
            return realm?.objects(T.self)
        }
    }
    
    func getObjects<T: Object>(withFilter: String? = nil) -> [T] {
        if let result: Results<T> = getObjects(withFilter: withFilter) {
            return Array(result)
        } else {
            return []
        }
    }
    
    // MARK: - DELETE
    
    func deleteObject<T: Object>(object: T) {
        write { (realm) in
            realm.delete(object)
        }
    }
    
    func observeUpdateChanges<T: Object>(type: T.Type, _ changeBlock: @escaping (RealmCollectionChange<Results<T>>) -> Void) -> NotificationToken? {
        do {
            let realm = try Realm()
            return realm.objects(type).observe { change in
                switch change {
                case .update:
                    changeBlock(change)
                default:
                    break
                }
            }
        } catch {
            return nil
        }
    }
}

// MARK: - Private methods
private extension RealmManager {
    func prepareRealmDatabase() {
        let config = Realm.Configuration(schemaVersion: schemaVersion)
        Realm.Configuration.defaultConfiguration = config
    }
}
