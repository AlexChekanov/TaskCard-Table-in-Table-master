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
        
        clearButton.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        textViewHeight = textView.intrinsicContentSize.height
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        textView.text = nil
        placeholderView.isHidden = false
    }
}


// Text Fields management
extension TextViewField: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        // We need this delay as a partial fix to a long standing bug: to keep the caret inside the `UITextView` always visible
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            textView.sendScrollRequest(animated: false)
            //self?.scrollToCaret(textView, animated: false)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // Main textView should have tag = 1, placeholder = 0
        // Placeholder view sholdn't be editable
        guard textView.tag == 1 else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(640)) {
            textView.sendScrollRequest(animated: false)
            //self?.scrollToCaret(textView, animated: false)
        }
        
        clearButton.isHidden = textView.text.count == 0
    }
    
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
    //
    
    func textViewDidEndEditing(_ textView: UITextView) {
        clearButton.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        // Main textView should have tag = 1, placeholder = 0
        // Placeholder view sholdn't be editable
        guard textView.tag == 1 else { return }
        
        // Check placeholder visibility
        placeholderView.isHidden = textView.text.count > 0
        // Check clearButton visibility
        clearButton.isHidden = textView.text.count == 0
        
        // Check the textViewHeight was changed
        // Do nothing if the height wasn't change
        guard textViewHeight != textView.intrinsicContentSize.height else { return }
        
        //guard let tableView = tableView else { return }
        
        informSizeWasUpdated(object: nil, receivers: nil, identifiers: [UIIdentifiers.actionsTableView, UIIdentifiers.operationsTableView])
        //        selfSizeUpdate(in: tableView)
        textViewHeight = textView.intrinsicContentSize.height
    }
    
//    func postSizeWasUpdated() {
//
//        let notification = Notification(name: .sizeUpdateRequest)
//
//        NotificationCenter.default.post(notification)
//    }
    
}

// scroll
