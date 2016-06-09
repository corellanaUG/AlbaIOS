import UIKit

class FondoImageView: UIImageView
{
    func bgChanged()
    {
        self.image = UIImage(named: "fondo")
        self.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        bgChanged()
    }
    
}
