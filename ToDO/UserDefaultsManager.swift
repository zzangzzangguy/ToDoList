//
//  UserDefaultsManager.swift
//  ToDO
//
//  Created by 김기현 on 2023/08/28.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    let userDefaults = UserDefaults.standard
    let savedItemsKey = "sectionedItemsKey"
    
    func saveItems(_ items: [ViewController.TodoSection: [String]]) {
        userDefaults.set(items, forKey: savedItemsKey)
    }
    
    func loadItems() -> [ViewController.TodoSection: [String]]? {
        return userDefaults.dictionary(forKey: savedItemsKey) as? [ViewController.TodoSection: [String]]
    }
}
