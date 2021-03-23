//
//  TodoListViewController.swift
//  TodoListPractice
//
//  Created by Tai Chin Huang on 2021/3/4.
//

import UIKit

class TodoListViewController: UIViewController {
    
    var testItem: [TestItem] = [
        TestItem(name: "Andrew", gender: "Male", age: 30),
        TestItem(name: "Angela", gender: "Female", age: 35),
        TestItem(name: "Mu", gender: "Male", age: 28)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TestItemCell
        cell.nameLabel.text = testItem[indexPath.row].name
        cell.ageLabel.text = "\(testItem[indexPath.row].age)"
        cell.genderLabel.text = testItem[indexPath.row].gender
        return cell
    }
    
    
}
