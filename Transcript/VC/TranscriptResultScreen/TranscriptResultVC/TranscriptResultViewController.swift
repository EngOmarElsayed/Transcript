//
//  TranscriptResultViewController.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 13/07/2024.
//

import UIKit
import class AVKit.AVPlayerLayer
import class AVFoundation.AVPlayer
import Combine

class TranscriptResultViewController: UIViewController {
  private let viewModel = TranscriptResultViewModel()
  private var cancellable = Set<AnyCancellable>()
  private var videoPlayer: AVPlayer?
  
  //MARK: -  OutLets
  @IBOutlet var loadingProgress: UIProgressView!
  @IBOutlet var loadingLabel: UILabel!
  @IBOutlet var loadingEffect: UIVisualEffectView!
  
  @IBOutlet var videoPlayButton: UIButton!
  @IBOutlet var videoPlayerView: UIView!
  @IBOutlet var transcriptResultView: UITextView!
  
  @IBAction func videoPlayerButtonAction(_ sender: UIButton) {
    videoPlayer?.play()
    sender.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVC()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    Task {
      await viewModel.generateTranscript()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    viewModel.rest()
  }
}

//MARK: -  Setup methods
extension TranscriptResultViewController {
  private func setupVC() {
    setupVideoPlayer()
    listenToPublishers()
  }
  
  private func listenToPublishers() {
    viewModel.$viewState.sink { [weak self] viewState in
      guard let self else { return }
      loadingLabel.text = viewState.rawValue
      loadingProgress.progress = viewState.progress
    }.store(in: &cancellable)
    
    viewModel.$isFinished.sink { [weak self] isFinished in
      guard let self else { return }
      loadingEffect.isHidden = isFinished
      navigationItem.setHidesBackButton(!isFinished, animated: true)
    }.store(in: &cancellable)
    
    viewModel.$transcriptResult.sink { [weak self] transcriptResult in
      guard let self else { return }
      DispatchQueue.main.async {
        self.transcriptResultView.text = transcriptResult
      }
    }.store(in: &cancellable)
  }
  
  private func setupVideoPlayer() {
    videoPlayer = AVPlayer(url: viewModel.videoFileUrl())
    let playerLayer = AVPlayerLayer(player: videoPlayer)
    playerLayer.frame = videoPlayerView.bounds
    playerLayer.videoGravity = .resizeAspect
    videoPlayerView.layer.addSublayer(playerLayer)
  }
}
