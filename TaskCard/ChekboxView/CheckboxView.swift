import UIKit
import UIExtensions

@IBDesignable
class CheckboxView: UIView {
    
    enum State: String {
        
        case done = "●"
        case todo = "○"
        
        mutating func toggle() {
            switch self {
            case .done:
                self = .todo
            case .todo:
                self = .done
            }
        }
    }
    
    @IBOutlet weak var checkboxButton: UIButton!
    
    var state: State = .todo {
        
        didSet {
            checkboxButton.setTitle(state.rawValue, for: .normal)
        }
    }
    
    
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
        state = .todo
        
    }
    
    @IBAction func checkboxButtonPressed(_ sender: Any) {
        state.toggle()
    }
}
