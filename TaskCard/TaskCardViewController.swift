import UIKit

class TaskCardViewController: UIViewController {
    
    @IBOutlet weak var operationsTableView: UITableView!
    
    @IBOutlet weak var tableStackBottomConstraint: NSLayoutConstraint!
    
    var tableStackBottomConstraintInitialConstant: CGFloat?
    
    //let stepcellIdentifier = "step"
    
    let operationNibName = "OperationTableViewCell"
    let operationCellIdentifier = "operation"
    let operationToolboxNibName = "OperationToolboxTableViewCell"
    let operationToolboxCellIdentifier = "operationToolbox"
    
    var shouldHide: (instructions: Bool, actions: Bool) = (instructions: false, actions: false) {
        
        didSet {
            
            reloadDataWithScrollingToTop()
        }
    }
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToKeyboardNotifications()
        subscribeToSizeUpdateRequests()
        subscribeToScrollRequests()
        
        tableStackBottomConstraintInitialConstant = tableStackBottomConstraint.constant
        
        operationsTableView.rowHeight = UITableViewAutomaticDimension
        operationsTableView.estimatedRowHeight = 80
        
        operationsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        operationsTableView.register(UINib(nibName: operationNibName, bundle: nil), forCellReuseIdentifier: operationCellIdentifier)
        operationsTableView.register(UINib(nibName: operationToolboxNibName, bundle: nil), forCellReuseIdentifier: operationToolboxCellIdentifier)
        
        segmentedController.selectedSegmentIndex = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControllerValueChanged(_ sender: UISegmentedControl) {
        
        switch segmentedController.selectedSegmentIndex {
            
        case 0:  shouldHide = (instructions: false, actions: true)
        case 1:  shouldHide = (instructions: true, actions: false)
        default: shouldHide = (instructions: false, actions: false)
        }
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
        
        if let cell = cell as? OperationTableViewCell {
            
            cell.instructionsTableView.isHidden = shouldHide.instructions
            cell.actionsTableView.isHidden = shouldHide.actions
        }
        
        return cell
    }
    
    func reloadDataWithScrollingToTop() {
        
        operationsTableView.reloadData()
        operationsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        reloadDataWithScrollingToTop()
        
        let notification = Notification(name: .viewWillTransition, object: nil)
        NotificationCenter.default.post(notification)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard
            let previousTraitCollection = previousTraitCollection,
            self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass
                || self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass
                || self.traitCollection.preferredContentSizeCategory != previousTraitCollection.preferredContentSizeCategory
            else { return }
        
        operationsTableView.update(animated: true)
    }
}

// MARK: - Manage keyboard
extension TaskCardViewController {
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    // Keyboard Notifications
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let tableStackBottomConstraintInitialConstant = tableStackBottomConstraintInitialConstant  else { return }
        
        tableStackBottomConstraint.constant = keyboardHeight + tableStackBottomConstraintInitialConstant
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        tableStackBottomConstraint.constant = tableStackBottomConstraintInitialConstant ?? 0
    }
}

// Subscribe to size change requests
extension TaskCardViewController {
    
    func subscribeToSizeUpdateRequests() {
        NotificationCenter.default.addObserver(forName: .sizeUpdateRequest, object: nil, queue: nil) { [weak self] (notification) in
            
            guard let isAddressee =  self?.operationsTableView.checkIsAdressee(of: notification), isAddressee else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                self?.operationsTableView.update(animated: false)
            })
        }
    }
}

// Subscribe to scroll requests
extension TaskCardViewController {
    
    func subscribeToScrollRequests() {
        NotificationCenter.default.addObserver(forName: .scrollRequest, object: nil, queue: nil) { [weak self] (notification) in
            
            guard let data = notification.userInfo,
                let request = data["request"] as? ScrollRequest else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: { [weak self] in
                self?.operationsTableView.scrollTo(request.rect, in: request.view, animated: request.animated)
                
            })
        }
    }
}

