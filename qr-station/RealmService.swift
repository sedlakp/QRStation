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
    
    let realm: Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 4))
    
    init() {
        print(Realm.Configuration.defaultConfiguration.fileURL!) //shows realm file location
    }
    
    
    // MARK: - QRCodeRLM related
    func getCodes(searchedText: String) -> Results<QRCodeRLM> {
        if searchedText.isEmpty {
            // return everything
            return realm.objects(QRCodeRLM.self)
                .sorted(by: \.appearedDate, ascending: false)
        } else {
            // find and return only codes that have searched text either in the string or name
            return realm.objects(QRCodeRLM.self)
                .sorted(by: \.appearedDate, ascending: false)
                .where {
                    $0.string.contains(searchedText.lowercased(), options: [.caseInsensitive, .diacriticInsensitive]) ||
                    $0.name.contains(searchedText.lowercased(), options: [.caseInsensitive, .diacriticInsensitive])
                }
        }
    }
    
    func updateFavorite(qr: QRCodeRLM ) {
        try! realm.write {
            qr.isFavorite.toggle()
        }
    }
    
    func setQRName(for qr: QRCodeRLM, to text: String) {
        try! realm.write {
            qr.name = text
        }
    }
    
    // MARK: - General
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
