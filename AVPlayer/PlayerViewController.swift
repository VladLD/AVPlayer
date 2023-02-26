import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var songImageView: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var playbackStatusSlider: UISlider!
    @IBOutlet private weak var timePlayedLabel: UILabel!
    @IBOutlet private weak var timeToPlayLabel: UILabel!
    @IBOutlet private weak var backwardButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var volumeSlider: UISlider!
    
    private var asset: AVAsset!
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    private var timeObserver: Any?
    private var rateObserver: NSKeyValueObservation?
    
    private var playlist: [Song] = []
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setPlayer()
    }
    
    deinit {
        timeObserver.map { player.removeTimeObserver($0) }
        rateObserver?.invalidate()
        rateObserver = nil
        rateObserver.map { player.removeObserver($0, forKeyPath: #keyPath(AVPlayer.rate)) }
        player = nil
    }
    
    func setPlaylist(_ playlist: [Song], index: Int) {
        self.playlist = playlist
        self.currentIndex = index
    }
    
    private func setPlayer() {
        playItem(at: currentIndex)
        
        let audioSession = AVAudioSession.sharedInstance()
        player.volume = audioSession.outputVolume
        volumeSlider.setValue(player.volume, animated: true)
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] time in
            guard let self else { return }
            
            let currentSeconds = time.seconds
            let totalSeconds = self.playerItem.duration.seconds
            let timeLeft = totalSeconds - currentSeconds
            self.timePlayedLabel.text = self.getTimeString(from: currentSeconds)
            self.timeToPlayLabel.text = self.getTimeString(from: timeLeft)
            
            let progress = currentSeconds / totalSeconds
            self.playbackStatusSlider.value = Float(progress)
        })
        
        rateObserver = player.observe(\.rate, options: [.new]) { [weak self] player, change in
            guard let self else { return }
            
            let name = change.newValue != 0 ? "pause.fill" : "play.fill"
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: name, withConfiguration: configuration)
            self.playPauseButton.setImage(image, for: .normal)
        }
        
        player.play()
    }
    
    private func getTimeString(from timeInterval: Double) -> String {
        let date1 = Date()
        let date2 = date1.addingTimeInterval(timeInterval)
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date1, to: date2)
        
        var timeString = ""
        if let hour = components.hour, hour != 0 {
            timeString = String(format: "%02d", hour) + ":"
        }
        if let minute = components.minute {
            timeString += String(format: "%02d", minute) + ":"
        }
        if let second = components.second {
            timeString += String(format: "%02d", second)
        }
        return timeString
    }
    
    private func setViews() {
        let song = playlist[currentIndex]
        
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.image = UIImage(named: "bckg")
        
        songImageView.layer.cornerRadius = 10
        songImageView.image = song.image
        songNameLabel.text = song.name
        artistNameLabel.text = song.artist
        
        playbackStatusSlider.setThumbImage(UIImage(), for: .normal)
        playbackStatusSlider.setThumbImage(UIImage(), for: .highlighted)
    }
    
    private func playItem(at index: Int) {
        let index = index < 0 ? index + playlist.count : index % playlist.count
        guard let url = Bundle.main.url(
            forResource: playlist[index].fileName, withExtension: "mp3"
        ) else {
            return
        }
        
        currentIndex = index
        asset = AVAsset(url: url)
        playerItem = AVPlayerItem(asset: asset)
        
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        setViews()
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapPlayPauseButton() {
        player.rate = player.rate != 0 ? 0 : 1
    }
    
    @IBAction private func didTapBackwardButton() {
        playItem(at: currentIndex - 1)
    }
    
    @IBAction private func didTapForwardButton() {
        playItem(at: currentIndex + 1)
    }
    
    @IBAction func playbackValueChanged(_ sender: UISlider, forEvent event: UIEvent) {
        let seekToSeconds = playerItem.duration.seconds * Double(sender.value)
        let time = CMTime(seconds: seekToSeconds, preferredTimescale: 1)
        player.seek(to: time)
    }
    
    @IBAction func volumeValueChanged(_ sender: UISlider, forEvent event: UIEvent) {
        player.volume = sender.value
    }
    
}
