import UIKit

private enum Constant {
    static let cellID = "SongTableViewCell"
    static let segueID = "showPlayer"
}

class PlaylistViewController: UIViewController {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    private let playlist: [Song] = Songs.playlist
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.image = UIImage(named: "bckg")
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 20)
        tableView.separatorColor = .darkGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: Constant.cellID, bundle: nil),
            forCellReuseIdentifier: Constant.cellID
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constant.segueID,
              let playerVC = segue.destination as? PlayerViewController,
              let indexPath = sender as? IndexPath
        else {
            return
        }
        
        playerVC.setPlaylist(playlist, index: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellID, for: indexPath) as? SongTableViewCell
        else {
            return UITableViewCell()
        }
        cell.setData(playlist[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constant.segueID, sender: indexPath)
    }
}
