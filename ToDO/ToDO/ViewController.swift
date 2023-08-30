//
//  ViewController.swift
//  ToDO
//
//  Created by 김기현 on 2023/08/23.
//

//
import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var ToDoView = UITableView()
    var items: [String] = []
    var selectedSection: TodoSection?
    
    let sections = ["운동","일","생활"]
    
    enum TodoSection: String, CaseIterable {
        case exercsie = "운동"
        case work = "일"
        case life = "생활"
    }
    
//    let pickerData: [String] = [
//        TodoSection.exercsie.rawValue,
//        TodoSection.work.rawValue,
//        TodoSection.life.rawValue
//    ]
    
    // 메인 자료구조
    var sectionedItems: [TodoSection: [String]] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        
          }

    override func viewDidLoad() {
        super.viewDidLoad()


        
//        UserDefaults.standard.removeObject(forKey: "savedItems")
        
        
        
//        items = []
//        sectionedItems = [:]
        
        let pickerView = UIPickerView()
              pickerView.delegate = self
              pickerView.dataSource = self
              
              let pickerToolbar = UIToolbar()
              pickerToolbar.sizeToFit()
              let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerDoneButtonTapped))
              pickerToolbar.setItems([doneButton], animated: false)
              
              let textField = UITextField()
              textField.inputView = pickerView
              textField.inputAccessoryView = pickerToolbar
        
              view.addSubview(textField)
        

        view.addSubview(ToDoView)
        
        self.ToDoView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        autoLayout()
        
        
//        ToDoView.backgroundColor = .sy
        ToDoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
  
        
        if let savedItems = UserDefaults.standard.array(forKey: "savedItems") as? [String] {
                   items = savedItems
            print("Loaded saved items: \(items)")
        }
        self.ToDoView.dataSource = self
        self.ToDoView.delegate = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addtask))
        navigationItem.rightBarButtonItem = addButton
    }
    @objc func addtask() {
        let alertController = UIAlertController(title: "메모 추가", message: nil, preferredStyle: .alert)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        alertController.addTextField { textfiled in
            textfiled.placeholder = "감사합니두"
            textfiled.inputView = pickerView
            
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first,
               let newTask = textField.text,
               !newTask.isEmpty,
               let selectedSection = self?.selectedSection {
                
                
                self?.items.append(newTask)
                
                
                if var sectionItems = self?.sectionedItems[selectedSection] {
                    sectionItems.append(newTask)
                    self?.sectionedItems[selectedSection] = sectionItems
                } else {
                    self?.sectionedItems[selectedSection] = [newTask]
                }
                
                self?.ToDoView.reloadData()
                UserDefaults.standard.set(self?.items, forKey: "savedItems")
                
                print("### input : \(selectedSection) \(newTask)")
            
            }
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

}


extension ViewController {
    func getSection(section: Int) -> TodoSection {
        if section == 0 {
            return TodoSection.exercsie
        } else if section == 1 {
            return TodoSection.work
        } else {
            return TodoSection.life
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in

               // 1. 실제 데이터를 삭제
               guard let self = self else { return }
               print("### delete row \(indexPath)")
            
               var section = self.getSection(section: indexPath.section)
               var values = self.sectionedItems[section]
               //indexPath.section
               values?.remove(at: indexPath.row)
               self.sectionedItems[section] = values
               
               
               // 2. UI로 보여지는 row를 삭제
               self.ToDoView.deleteRows(at: [indexPath], with: .fade)
               self.items.remove(at: indexPath.row)
               UserDefaults.standard.set(self.items, forKey: "savedItems")
               completionHandler(true)
           }

           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
           return configuration
       }
   }
    

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let todoSection = TodoSection(rawValue: sections[section]),
            let items = sectionedItems[todoSection] else {
            return nil
        }
        
        if items.isEmpty {
            return nil
        }
        
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todoSection = TodoSection(rawValue: sections[section]),
              let itemsInSection = sectionedItems[todoSection] else {
            return 0
        }
        
        return itemsInSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        
        let section = indexPath.section
        
        if section == 0 {
            cell.TodoLabel.text = sectionedItems[TodoSection.exercsie]?[indexPath.row]
        } else if section == 1 {
            cell.TodoLabel.text = sectionedItems[TodoSection.work]?[indexPath.row]
        } else if section == 2 {
            cell.TodoLabel.text = sectionedItems[TodoSection.life]?[indexPath.row]
        } else {
            return UITableViewCell()
        }
    
        return cell
    }
}
extension ViewController {
    private func autoLayout() {
        ToDoView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSection = TodoSection(rawValue: sections[row])
    }
}
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
    }
}
extension ViewController {
    @objc func pickerDoneButtonTapped() {
        if let selectedSection = selectedSection {
            switch selectedSection {
            case .exercsie:
                break
            case .work:
                break
            case .life:
                break
            }
        }
        view.endEditing(true)
    }
}
