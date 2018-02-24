import UIKit

class AGTableView: UITableView {
    
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
        
        self.keyboardDismissMode = .onDrag
        self.tableFooterView = UIView(frame: .zero)
        self.tableHeaderView = UIView(frame: .zero)
//        self.sectionFooterHeight = 0
//        self.sectionHeaderHeight = 0
        
//        NotificationCenter.default
//            .addObserver(self, selector: #selector(updateLayout), name: .UIContentSizeCategoryDidChange, object: nil)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(updateLayout), name: .UIDeviceOrientationDidChange, object: nil)
        
        updateLayout()
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
    
    @objc func updateLayout() {
        
        setNeedsLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            
            self?.reloadData()
        })
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLayout()
    }
}
