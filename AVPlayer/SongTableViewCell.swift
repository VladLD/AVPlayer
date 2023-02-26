import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var songImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    
        songImage.contentMode = .scaleAspectFill
        songImage.layer.cornerRadius = 5
        nameLabel.textColor = .white
        artistLabel.textColor = .white
    }
    
    func setData(_ song: Song) {
        songImage.image = song.image
        nameLabel.text = song.name
        artistLabel.text = song.artist
    }
}
