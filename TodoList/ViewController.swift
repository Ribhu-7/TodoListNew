import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var tasks: [String] = ["Breakfast","Job","Coding","Lunch","Workout","Sleep"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Tasks"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editClicked))
        
    }
    
    @objc func addClicked(){
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            self.tasks.append(textField.text!)
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editClicked(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editClicked))
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editClicked))
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete"){ (action , view , success ) in
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // MARK: BASIC SETTING FOR TABLEVIEW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = task
        return cell
    }
    
    
}

