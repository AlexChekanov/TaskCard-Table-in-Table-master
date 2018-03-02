import Foundation
import UIKit

extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}
// Using this, we can extend UITableViewCell with some convenient read-only computed properties for the table view and index path of the cell.

extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}


// --------

protocol ScrollDelegate {
    
    func scrollTo(_ rect: CGRect, in view: UIView, animated: Bool)
}

protocol UpdateDelegate {
    
    //    func update(animated: Bool)
    func update(at indexPaths: [IndexPath], animated: Bool)
}


// --------

extension Notification.Name {
    
    static let viewWillTransition = Notification.Name("UIViewWillTransition")
    static let scrollRequest = Notification.Name("UIViewScrollRequested")
    static let sizeUpdateRequest = Notification.Name("UIViewSizeUpdateRequested")
}

struct ScrollRequest {
    
    var view: UIView
    var rect: CGRect
    var animated: Bool
}


extension UIView {
    
    @discardableResult   // Using a discardable return value since the returned view is mostly of no interest to caller when all outlets are already connected.
    
    func loadFromNib<T : UIView>() -> T? {   // This is a generic method that returns an optional object of type UIView. If it fails to load the view, it returns nil.
        
        // Attempting to load a XIB file with the same name as the current class instance. If that fails, nil is returned.
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)     // Adding the top level view to the view hierarchy.
        
        contentView.translatesAutoresizingMaskIntoConstraints = false   // This line assumes we're using constraints to layout the view.
        contentView.layoutAttachAll()   // This method adds top, bottom, leading & trailing constraints - attaching the view to "self" on all sides (See: https://stackoverflow.com/a/46279424/2274829 for details)
        return contentView   // Returning the top level view
    }
}

/*
 
 And the caller method might look like this:
 
 final class SomeView: UIView {   // 1.
 required init(coder aDecoder: NSCoder) {   // 2 - storyboard initializer
 super.init(coder: aDecoder)
 fromNib()   // 5.
 }
 init() {   // 3 - programmatic initializer
 super.init(frame: CGRect.zero)  // 4.
 fromNib()  // 6.
 }
 // other methods ...
 
 }
 */

extension UIView {
    
    /// attaches all sides of the receiver to its parent view
    func layoutAttachAll(margin: CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: margin)
        layoutAttachBottom(to: view, margin: margin)
        layoutAttachLeading(to: view, margin: margin)
        layoutAttachTrailing(to: view, margin: margin)
    }
    
    /// attaches the top of the current view to the given view's top if it's a superview of the current view, or to it's bottom if it's not (assuming this is then a sibling view).
    /// if view is not provided, the current view's super view is used
    @discardableResult
    func layoutAttachTop(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = view == superview
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: isSuperview ? .top : .bottom, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the bottom of the current view to the given view
    @discardableResult
    func layoutAttachBottom(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: isSuperview ? .bottom : .top, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the leading edge of the current view to the given view
    @discardableResult
    func layoutAttachLeading(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: isSuperview ? .leading : .trailing, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the trailing edge of the current view to the given view
    @discardableResult
    func layoutAttachTrailing(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: isSuperview ? .trailing : .leading, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
}

/*
 // pin all edge to superview
 myView.layoutAttachAll()
 
 // pin all edges (to superview) with margin:
 myView.layoutAttachAll(margin: 8.0)
 
 // for child views: pin leading edge to superview's leading edge:
 myView.layoutAttachLeading()
 
 // for sibling views: pin leading edge to siblingView's trailing edge:
 myView.layoutAttachLeading(to: siblingView)
 
 // for sibling views: pin top edge to siblingView's bottom edge:
 myView.layoutAttachTop(to: siblingView)
 */


extension UITableView {
    
    @objc func update(animated: Bool = false) {
        
        let currentAnimationState = UIView.areAnimationsEnabled
        defer { UIView.setAnimationsEnabled(currentAnimationState) }
        UIView.setAnimationsEnabled(animated)
        
        beginUpdates()
        endUpdates()
    }
    
    @objc func reloadDelayed(_ milliseconds: Int = 100) {
        
        setNeedsLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: { [weak self] in
            
            self?.reloadData()
        })
    }
    
    func scrollTo(_ rect: CGRect, in view: UIView, animated: Bool) {
        
        let rectToScroll = view.convert(rect, to: self)
        scrollRectToVisible(rectToScroll, animated: animated)
    }
}


extension UIView {
    
    func informSizeWasUpdated(object: Any?, receivers: [UIView]? = nil, identifiers: [String]? = nil) {
        
        var userInfo: [AnyHashable: Any] = [:]
        
        if let receivers = receivers { userInfo["receivers"] = receivers }
        if let identifiers = identifiers {
            userInfo["identifiers"] = identifiers
        }
        
        let notification =  Notification(name: .sizeUpdateRequest, object: object, userInfo: userInfo)
        
        NotificationCenter.default.post(notification)
    }
    
    func checkIsAdressee(of notification: Notification) -> Bool {
        
        guard
            let data = notification.userInfo else { return false }
        
        if let receivers = data["receivers"] as? [UIView], receivers.contains(self) { return true }
        
        if let identifier = restorationIdentifier,
            let identifiers = data["identifiers"] as? [String],
            identifiers.contains(identifier)
        { return true }
        
        return false
    }
}

extension UITextView {
    
    func sendScrollRequest(animated: Bool, receivers: [UIView]? = nil, identifiers: [String]? = nil ) {
        
        DispatchQueue.main.async {
            
            guard let currentCursorPosition = self.selectedTextRange?.end else { return }
            
            var caret = self.caretRect(for: currentCursorPosition)
            caret.size.height += caret.size.height/2
            // Create some space around
            caret = caret.offsetBy(dx: 0, dy: -caret.size.height/8)
            
            let scrollRequest = ScrollRequest(view: self, rect: caret, animated: false)
            
            var userInfo: [AnyHashable: Any] = [:]
            
            if let receivers = receivers {
                userInfo["receivers"] = receivers
            }
            if let identifiers = identifiers {
                userInfo["identifiers"] = identifiers
            }
            
            userInfo["request"] = scrollRequest
            NotificationCenter.default.post(name: .scrollRequest, object: self, userInfo: userInfo)
        }
    }
}
