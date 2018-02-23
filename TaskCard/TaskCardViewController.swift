import UIKit

class TaskCardViewController: UIViewController {

    @IBOutlet weak var operationsTableView: UITableView!
    
    let stepcellIdentifier = "step"
    
    let operationCellIdentifier = "operation"
    let operationToolboxCellIdentifier = "operationToolbox"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        operationsTableView.rowHeight = UITableViewAutomaticDimension
        operationsTableView.estimatedRowHeight = 80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TaskCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = indexPath.section == 0 ? tableView.dequeueReusableCell(withIdentifier: operationCellIdentifier, for: indexPath) : tableView.dequeueReusableCell(withIdentifier: operationToolboxCellIdentifier, for: indexPath)
 
        return cell
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        operationsTableView.beginUpdates()
//        operationsTableView.endUpdates()
//
//        operationsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
//
//    }
}

