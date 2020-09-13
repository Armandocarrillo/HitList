//
//  ViewController.swift
//  HitList
//
//  Created by Armando Carrillo on 13/09/20.
//  Copyright © 2020 Armando Carrillo. All rights reserved.
//

import UIKit
import CoreData

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //match cells with the NSMangedObject
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
}

class ViewController: UIViewController {
    


    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "the List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @IBAction func AddName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

