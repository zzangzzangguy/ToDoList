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
    
    
    // 메인 자료구조
    var sectionedItems: [TodoSection: [String]] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("### viewWillAppear called")
        
        
        if let savedItems = UserDefaults.standard.array(forKey: "savedItems") as? [String] {
            items = savedItems
            sectionedItems = [:]
            //             섹션 별로 할 일을 정리하여 sectionedItems 딕셔너리에 저장
            for item in items {
                let components = item.components(separatedBy: ":")
                if components.count == 2,
                   let sectionString = components.first,
                   let section = TodoSection(rawValue: sectionString),
                   let task = components.last {
                    if var sectionItems = sectionedItems[section] {
                        sectionItems.append(task)
                        sectionedItems[section] = sectionItems
                    } else {
                        sectionedItems[section] = [task]
                    }
                }
            }
            
            print("# 앱 다시 실행시 불러온다: \(items)")
            view.addSubview(ToDoView)
            ToDoView.reloadData()
            print("나 \(ToDoView)호출 잘하고잇나")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        ToDoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
               //               !newTask.isEmpty,
               let selectedSection = self?.selectedSection {
                
                let combineTask = "\(selectedSection.rawValue):\(newTask)"
                self?.items.append(combineTask)
                
                
                self?.items.append(newTask)
                print("### :추가하고")
                
                
                
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
            
            guard let todoSection = TodoSection(rawValue: self.sections[indexPath.section]),
                  var sectionItems = self.sectionedItems[todoSection] else {
                completionHandler(false)
                return
            }
            
            // 삭제할 할 일
            let task = sectionItems[indexPath.row]
            sectionItems.remove(at: indexPath.row)
            self.sectionedItems[todoSection] = sectionItems
            
            // UI에서도 삭제
            self.ToDoView.deleteRows(at: [indexPath], with: .fade)
            // items 배열에서 삭제
            if let index = self.items.firstIndex(of: task) {
                self.items.remove(at: index)
            }
            if let sectionIndex = self.items.firstIndex(where: { $0.hasSuffix(":\(task)") }) {
                           self.items.remove(at: sectionIndex)
                       }
            UserDefaults.standard.set(self.items, forKey: "savedItems")
            completionHandler(true)
        }
            print("### row 삭제")

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
        print("###:\(itemsInSection)")
        return itemsInSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        
        guard let todoSection = TodoSection(rawValue: sections[indexPath.section]),
              let itemsInSection = sectionedItems[todoSection] else {
            return UITableViewCell()
        }
        
        let item = itemsInSection[indexPath.row]
        cell.TodoLabel.text = item
        
        let section = indexPath.section
        
        cell.cellSetting()
        
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
extension ViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(items, forKey: "savedItems")
        print("### 앱이 종료될때! 저장")
    }
}
