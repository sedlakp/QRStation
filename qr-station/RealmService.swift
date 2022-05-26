//
//  RealmService.swift
//  qr-station
//
//  Created by Petr Sedlák on 26.05.2022.
//

import Foundation

import RealmSwift


class RealmService {
    
    static let shared = RealmService()
    
    let realm: Realm = try! Realm()
    
    init() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func add(_ object: Object) {
        try! realm.write {
            realm.add(object, update: .all)
        }
    }
    
    func add(_ objects: [Object]) {
        try! realm.write {
            realm.add(objects, update: .all)
        }
    }
    
    func delete(_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    
}
