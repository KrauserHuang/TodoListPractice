//
//  TodoItemViewController.swift
//  TodoListPractice
//
//  Created by Tai Chin Huang on 2021/3/17.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoItemViewController: UITableViewController {
    /*
     設定空的todoItems list
     Results是一個自動更新的realm container
     */
    var todoItems: Results<Item>?
    // Get the default realm
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 在navigationBar左邊添加可以編輯(Edit)的按鈕
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //        tableView.rowHeight = 80
        loadItems()
        // 印出.realm檔案的位置，方便你使用MongoDB Realm Studio來看實際的資料庫內容
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If todoItems is not nil then retrieve .count or set return as 1
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        // 因為todoItems是optional，用optional binding來確保item型別不是optional
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write {
                let sourceItem = todoItems?[sourceIndexPath.row]
                let destinationItem = todoItems?[destinationIndexPath.row]
                print(sourceIndexPath.row)
                let destinationItemOrder = destinationItem?.order

                if sourceIndexPath.row < destinationIndexPath.row {
                    // 由上往下移動
                    // ex:sourceIndexPath.row = 0, destinationIndexPath.row = 1
                    for index in sourceIndexPath.row...destinationIndexPath.row {
                        let item = todoItems?[index]
                        item?.order -= 1
                    }
                } else {
                    // 由下往上移動
                    for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                        let item = todoItems?[index]
                        item?.order += 1
                    }
                }
                sourceItem?.order = destinationItemOrder!
            }
        } catch {
            print("Error moveing items, \(error)")
        }
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //MARK: - Table view delegate
    // Update
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error changing done status, \(error)")
            }
        }
        tableView.reloadData()
    }
    //MARK: - Data Manipulation Methods
    func loadItems() {
        // Get all items in realm
//        todoItems = realm.objects(Item.self)
        todoItems = realm.objects(Item.self).sorted(byKeyPath: "order")
    }
    //MARK: - Add new items
    // Create
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let controller = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
//                    newItem.order += 1
                    self.realm.add(newItem)
                    
                }
            } catch {
                print("Error saving new items. \(error)")
            }
            self.tableView.reloadData()
        }
        controller.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
}
extension TodoItemViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                } catch {
                    print("Errro deleting items, \(error)")
                }
            }
        }
        
        // customize the action appearance
        //        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
extension TodoItemViewController: UISearchBarDelegate {
    
}
