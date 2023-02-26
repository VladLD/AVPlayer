import UIKit

struct Song {
    let artist: String
    let name: String
    let image: UIImage?
    let fileName: String
}

enum Songs {
    static let playlist: [Song] = {[
        Song(artist: "TVORCHI", name: "Heart of Steel", image: UIImage(named: "HeartOfSteel"), fileName: "TVORCHI - Heart of steel"),
        Song(artist: "Степан Гіга", name: "Цей сон", image: UIImage(named: "Son"), fileName: "Степан Гіга - Цей сон"),
        Song(artist: "Chico & Qatoshi", name: "Ластівки", image: UIImage(named: "Lastivky"), fileName: "Chico & Qatoshi - Ластівки"),
        Song(artist: "Степан Гіга", name: "Яворина", image: UIImage(named: "Yavoryna"), fileName: "Степан Гіга - Яворина"),
    ]}()
}
