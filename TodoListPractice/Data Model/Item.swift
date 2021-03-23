//
//  Item.swift
//  TodoListPractice
//
//  Created by Tai Chin Huang on 2021/3/17.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var order: Int = 0
}
