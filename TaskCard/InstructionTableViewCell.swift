import UIKit

class InstructionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel! {
        
        didSet {
            
            let texts: [String] = [
            
                "Curabitur congue nulla sit amet cursus accumsan. Sed sagittis dictum velit ut porttitor. Nunc fermentum rhoncus nunc, vel lacinia libero molestie sit amet. Sed dapibus elit in ante facilisis egestas.",
                
                "Morbi rutrum turpis quis sem efficitur, sed vulputate tellus dapibus.",
                
                "Curabitur lacinia lacinia dolor, sit amet suscipit neque laoreet eu. Nulla maximus egestas quam, vitae porttitor lectus sodales vulputate.",
                
                "Ut eget ultrices urna, non laoreet odio. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Suspendisse porttitor odio condimentum, pharetra elit eget, sagittis velit. In sollicitudin felis nec quam porta congue. Proin congue ipsum at malesuada porttitor. Ut rutrum efficitur tincidunt. Phasellus eros augue, dictum eu maximus et, dignissim et mauris. Suspendisse potenti. In non lacus eget lorem porttitor interdum at sodales velit. Duis sit amet risus orci. Suspendisse elementum ligula ac est auctor, sed commodo velit faucibus.",
                
                "Suspendisse semper eros ut mauris maximus dignissim. In ultricies congue dictum. Sed consectetur sagittis justo, in volutpat libero finibus in. In non ligula sed libero auctor rutrum. Nam mauris massa, laoreet eu aliquet eu, vulputate nec diam. Nam dictum placerat velit, rutrum tincidunt tellus vulputate et. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam pretium feugiat libero, nec semper sapien elementum et.",
                
                "Nullam suscipit ultricies fringilla. Etiam aliquet augue et arcu porta euismod. Nullam tempor fringilla velit ac iaculis.",
                
                "Vivamus mattis, lorem ac tincidunt scelerisque, erat nunc malesuada nulla, et posuere dolor magna eget orci. Duis ullamcorper, felis et finibus sagittis, velit odio posuere ligula, et bibendum justo elit vitae erat. Sed et est faucibus metus rutrum congue faucibus eget nunc. Nam et lacinia neque, eget rutrum elit."
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
