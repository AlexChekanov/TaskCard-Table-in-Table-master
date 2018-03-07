import UIKit
import UIExtensions

@IBDesignable
class ActionGroupView: UIView {
    
    var titlePlaceholder: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadFromNib()
        
    }
    
    @IBAction func titleFieldDidBeginEditing(_ sender: UITextField) {
        
        // Invalidate size to correct the "clear" button behaviour
        sender.invalidateIntrinsicContentSize()
        
        // Delete placeholder to 
        titlePlaceholder = sender.placeholder
        sender.placeholder = nil
        
    }
    
    @IBAction func titleFieldDedEndEditing(_ sender: UITextField) {
        
        sender.placeholder = titlePlaceholder
    }
    
    
    
    
}
//
//extension ActionGroupView: UITextFieldDelegate {
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        <#code#>
//    }
//}


// TODO: Keyboard shows additional row of correction, what makes it jump on switch between fields. Correction was turned off.
