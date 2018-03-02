import UIKit

@IBDesignable
class TextViewField: UIView {
    
    @IBInspectable
    var placeholderText: String? {
        
        didSet {
            placeholderView.text = placeholderText
        }
    }
    
    @IBOutlet weak var placeholderView: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    
    var textViewHeight: CGFloat?
    var placeholderViewHeight: CGFloat?
    
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
        
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        placeholderView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        clearButton.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        textView.text = nil
        textViewDidChange(textView)
    }
}


// Text Fields management
extension TextViewField: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        // We need this delay as a partial fix to a long standing bug: to keep the caret inside the `UITextView` always visible
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            textView.sendScrollRequest(animated: false)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // Main textView should have tag = 1, placeholder = 0
        // Placeholder view sholdn't be editable
        guard textView.tag == 1 else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(640)) {
            textView.sendScrollRequest(animated: false)
        }
        
        clearButton.isHidden = textView.text.count == 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        clearButton.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        // Main textView should have tag = 1, placeholder = 0
        // Placeholder view sholdn't be editable
        //guard textView.tag == 1 else { return }
        
        // Check placeholder visibility
        //placeholderView.isHidden = textView.text.count > 0
        
        if textView.text.count > 0 {
            placeholderView.text = nil
        } else { placeholderView.text = placeholderText }
        
        // Check clearButton visibility
        clearButton.isHidden = textView.text.count == 0
        
        // Check the textViewHeight was changed
        // Do nothing if the height wasn't change
        guard
        textViewHeight != textView.intrinsicContentSize.height ||
        placeholderViewHeight != placeholderView.intrinsicContentSize.height
        
        else { return }
        
        textView.setNeedsLayout()
        placeholderView.setNeedsLayout()
        
        informSizeWasUpdated(object: nil, receivers: nil, identifiers: [UIIdentifiers.actionsTableView, UIIdentifiers.operationsTableView])
        
        textViewHeight = textView.intrinsicContentSize.height
        placeholderViewHeight = placeholderView.intrinsicContentSize.height
    }
}
