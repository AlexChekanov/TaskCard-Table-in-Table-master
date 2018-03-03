import UIKit

class NestedTableView: UITableView {
    
    fileprivate var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.associateConstraints()
        defaultInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.associateConstraints()
        defaultInit()
    }
    
    func defaultInit(){
        
        //self.keyboardDismissMode = .onDrag
        self.tableFooterView = UIView(frame: .zero)
        self.tableHeaderView = UIView(frame: .zero)
      
//        NotificationCenter.default
//        .addObserver(self, selector: #selector(updateSize), name: .viewWillTransition, object: nil)
        
        subscribeToSizeChanges()
        
        //reloadDelayed()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.heightConstraint != nil {
            self.heightConstraint.constant = self.contentSize.height
//            print(heightConstraint.constant)
        }
        else{
//            print("Set a heightConstraint to set cocontentSize with same")
        }
    }
    
    func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height
        
        for constraint: NSLayoutConstraint in constraints {
            if constraint.firstAttribute == .height {
                if constraint.relation == .equal {
                    heightConstraint = constraint
                }
            }
        }
    }
    
    func subscribeToSizeChanges() {
        NotificationCenter.default.addObserver(forName: .sizeUpdateRequest, object: nil, queue: nil) { [weak self] (notification) in
            
            guard let isAddressee =  self?.checkIsAdressee(of: notification), isAddressee else { return }
            
            self?.update(animated: false)
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
//
//            })
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //updateSize()
//        endEditing(true)
//        setNeedsLayout()
//        reloadData()
    }
    
    @objc func updateSize() {
        endEditing(true)
        //setNeedsLayout()
        //update(animated: true)
        //reloadData()
    }
    
}
