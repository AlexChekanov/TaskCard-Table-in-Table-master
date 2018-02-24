import UIKit

class ActionTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel! {
        
        didSet {
            
            let texts: [String] = [
                
                "Curabitur congue nulla sit amet cursus accumsan. Sed sagittis dictum velit ut porttitor. Nunc fermentum rhoncus nunc, vel lacinia libero molestie sit amet. Sed dapibus elit in ante facilisis egestas.",
                
                "Duis id leo ac nisl tincidunt tempor vitae ac eros. Phasellus sollicitudin pretium felis nec tempor. Nulla ex eros, luctus et ex non, ullamcorper volutpat lacus. Sed finibus nunc non tempus aliquet. Fusce volutpat leo orci, nec cursus lectus ultricies eget.",
                
                "Nullam suscipit ultricies fringilla. Etiam aliquet augue et arcu porta euismod.",
                
                "Curabitur iaculis, tortor et finibus ultrices, sapien nulla lacinia magna, et accumsan massa eros nec quam.",
                
                "Maecenas erat ante, dapibus sit amet ante id, porta maximus quam. Duis elit justo, porttitor mollis enim eget, eleifend venenatis libero. Nullam in turpis quis dolor consequat faucibus. Sed lacinia sed massa tincidunt consectetur. Praesent dignissim, nisl ac maximus rhoncus, ex lacus scelerisque orci, et scelerisque risus magna nec purus. Sed tincidunt pellentesque ligula sit amet lacinia. Pellentesque cursus tempus sagittis. Nunc aliquet quis odio at elementum. Nullam suscipit ultricies fringilla. Etiam aliquet augue et arcu porta euismod. Nullam tempor fringilla velit ac iaculis. Curabitur iaculis, tortor et finibus ultrices, sapien nulla lacinia magna, et accumsan massa eros nec quam. Sed turpis ligula, ornare in elit sit amet, pharetra elementum augue. Curabitur ac nisl non mauris gravida tristique.",
                
                "Praesent dignissim, nisl ac maximus rhoncus, ex lacus scelerisque orci, et scelerisque risus magna nec purus.",
                
                "Donec accumsan arcu in felis vehicula, sit amet placerat sem mollis. Vivamus tincidunt, neque sit amet tincidunt laoreet, velit mauris pretium leo, eu pretium diam arcu sit amet nunc. Mauris mollis malesuada libero sed scelerisque. Cras vestibulum malesuada justo, et ultricies ex maximus ut. Sed consectetur sodales fermentum. Phasellus sed sollicitudin leo. Donec tristique nisl nec libero rutrum tristique a sit amet orci. Quisque ac magna ac augue tempor convallis. Cras euismod malesuada orci, quis malesuada mi euismod vitae. Etiam turpis purus, accumsan sed enim porttitor, accumsan porttitor nulla. Phasellus non suscipit lectus, ac tempor est. In hac habitasse platea dictumst.",
                
                "Curabitur lacinia lacinia dolor, sit amet suscipit neque laoreet eu. Nulla maximus egestas quam, vitae porttitor lectus sodales vulputate.",
                
                "Ut eget ultrices urna, non laoreet odio. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Suspendisse porttitor odio condimentum, pharetra elit eget, sagittis velit. In sollicitudin felis nec quam porta congue. Proin congue ipsum at malesuada porttitor. Ut rutrum efficitur tincidunt. Phasellus eros augue, dictum eu maximus et, dignissim et mauris. Suspendisse potenti. In non lacus eget lorem porttitor interdum at sodales velit. Duis sit amet risus orci. Suspendisse elementum ligula ac est auctor, sed commodo velit faucibus."
            ]
            
            label.text = texts[Int(arc4random_uniform(UInt32(texts.count)))]
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
