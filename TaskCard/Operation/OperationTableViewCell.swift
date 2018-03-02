import UIKit

class OperationTableViewCell: UITableViewCell {

    enum TableViewKind: String {
        
        case instructions
        case actions
    }
    
    @IBOutlet weak var instructionsTableView: NestedTableView!
    @IBOutlet weak var actionsTableView: NestedTableView!
    
    let instructionCellIdentifier = "instruction"
    let instructionCellNibName = "InstructionTableViewCell"
    let instructionToolboxCellIdentifier = "instructionToolbox"
    let instructionToolboxCellNibName = "InstructionToolboxTableViewCell"
    
    let actionCellIdentifier = "action"
    let actionCellNibName = "ActionTableViewCell"
    let actionToolboxCellIdentifier = "actionToolbox"
    let actionToolboxCellNibName = "ActionToolboxTableViewCell"
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        instructionsTableView.dataSource = self
        instructionsTableView.delegate = self
        actionsTableView.dataSource = self
        actionsTableView.delegate = self
        
        configureInstructionsTableViewData()
        configureInstructionsTableViewVisual()
        
        configureActionsTableViewData()
        configureActionsTableViewVisual()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - Configure Instructions
    func configureInstructionsTableViewData() {
        // Configure data
        
    }
    
    func configureInstructionsTableViewVisual() {
        instructionsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        instructionsTableView.estimatedRowHeight = 40
        
        // Register Nibs
        instructionsTableView.register(UINib(nibName: instructionCellNibName, bundle: nil), forCellReuseIdentifier: instructionCellIdentifier)
        instructionsTableView.register(UINib(nibName: instructionToolboxCellNibName, bundle: nil), forCellReuseIdentifier: instructionToolboxCellIdentifier)
    }
    
    // MARK: - Configure Actions
    func configureActionsTableViewData() {
        // Configure data
        
    }
    
    func configureActionsTableViewVisual() {
        actionsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        actionsTableView.estimatedRowHeight = 40
        
        // Register Nibs
        actionsTableView.register(UINib(nibName: actionCellNibName, bundle: nil), forCellReuseIdentifier: actionCellIdentifier)
        actionsTableView.register(UINib(nibName: actionToolboxCellNibName, bundle: nil), forCellReuseIdentifier: actionToolboxCellIdentifier)
    }
}

// MARK: - Delegate & Datasource
extension OperationTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let tableViewKind = getKind(of: tableView) else { return 0 }
        
        switch tableViewKind {
            
        case .instructions:
            return section == 0 ? 2 : 1
        case .actions:
            return section == 0 ? 4 : 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableViewKind = getKind(of: tableView) else { return UITableViewCell() }
        
        switch tableViewKind {
            
        case .instructions:
            let cell = indexPath.section == 0 ? instructionsTableView.dequeueReusableCell(withIdentifier: instructionCellIdentifier, for: indexPath) :
                instructionsTableView.dequeueReusableCell(withIdentifier: instructionToolboxCellIdentifier, for: indexPath)
            instructionsTableView.setNeedsLayout() //layoutSubviews()
            self.tableView?.reloadData()
            return cell
            
        case .actions:
            let cell = indexPath.section == 0 ? actionsTableView.dequeueReusableCell(withIdentifier: actionCellIdentifier, for: indexPath) :
                actionsTableView.dequeueReusableCell(withIdentifier: actionToolboxCellIdentifier, for: indexPath)
            actionsTableView.setNeedsLayout() //layoutSubviews()
            self.tableView?.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func getKind(of tableView: UITableView) -> TableViewKind? {
        
        guard let tableViewRestorationIdentifier = tableView.restorationIdentifier,
            let tableViewKind = TableViewKind(rawValue: tableViewRestorationIdentifier) else { return nil }
        
        return tableViewKind
        
    }
    
}
