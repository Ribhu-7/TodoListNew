import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var tasks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating and adding tableview
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Tasks"
        
        //title colour change
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //navbar colour change
        self.navigationController?.navigationBar.backgroundColor = .systemIndigo
        self.navigationController?.navigationBar.tintColor = .white
        
        //left side and right side navbar
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editClicked))
        
    }
    
    //add button is clicked
    @objc func addClicked(){
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        //ok clicked on alert
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            if textField.text?.isEmpty == false{
                self.tasks.append(textField.text!)
            }
            
            self.tableView.reloadData()
        }
        //cancel click on alert
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in
            //no need
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //edit clicked
    @objc func editClicked(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editClicked))
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editClicked))
        }
    }
    
    //swiping edit and delete properties
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //delete item
        let delete = UIContextualAction(style: .destructive, title: "Delete"){ (action , view , success ) in
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
        //edit item
        let edit = UIContextualAction(style: .normal, title:  "Edit",
                                      handler: { [self] (ac:UIContextualAction, view:UIView, success:(Bool)
                                                         -> Void) in
            
            // AlertView with Textfield for enter text
            let alert = UIAlertController(title: "Want to Edit Item?",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: {
                (alertAction: UIAlertAction!) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addTextField { [self] (textField) in
                textField.text = "\(tasks[indexPath.row])"
            }
            
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { [self]
                (alertAction: UIAlertAction!) in
                let textField = alert.textFields![0] // Force unwrapping because we know it exists.
                if let i = tasks.firstIndex(of: "\(tasks[indexPath.row])") {
                    tasks[i] = textField.text!
                }
                self.tableView.reloadData() // reload your tableview here
            }))
            
            alert.view.tintColor = UIColor.black  // change text color of the buttons
            alert.view.layer.cornerRadius = 25   // change corner radius
            present(alert, animated: true, completion: nil)
            
            success(true)
        })
        
        //            self.tasks.remove(at: indexPath.row)
        //            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [edit,delete])
        return swipeActions
    }
    
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // data in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = task
        return cell
    }
    
    
}

