//
//Copyright (c) 2024 Omar Elsayed
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE. on 13/07/2024.
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
  
  @IBOutlet var doneButton: UIBarButtonItem!
  @IBOutlet var pauseButton: UIButton!
  @IBOutlet var videoPlayButton: UIButton!
  @IBOutlet var videoPlayerView: UIView!
  @IBOutlet var transcriptResultView: UITextView!
  
  @IBAction func pauseButton(_ sender: UIButton) {
    videoPlayer?.pause()
    videoPlayButton.isHidden = false
    sender.isHidden = true
  }
  
  @IBAction func videoPlayerButtonAction(_ sender: UIButton) {
    videoPlayer?.play()
    pauseButton.isHidden = false
    sender.isHidden = true
  }
  
  @IBAction func doneButton(_ sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  //MARK: -  VC Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVC()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    Task {
      await viewModel.generateTranscript()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    viewModel.rest()
  }
}

//MARK: -  Setup methods
extension TranscriptResultViewController {
  private func setupVC() {
    setupVideoPlayer()
    listenToPublishers()
    videoPlayerView.addBottomLine(with: .imageBlack, and: 1.0)
    navigationItem.setHidesBackButton(true, animated: true)
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
      doneButton.isHidden = !isFinished
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
