//
//  TranscriptResultViewModel.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 13/07/2024.
//

import Foundation
import Injection
import UserDefaults
import enum AudioTranscript.LocaleLanguage

final class TranscriptResultViewModel {
  @Published var viewState: TranscriptResultViewState = .none
  @Published var transcriptResult: String = ""
  @Published var isFinished: Bool = true
  
  @UserDefault(\.chosenLang) private var lang: LocaleLanguage = .UsEnglish
  @Injected(\.transcriptGenerationLogic) private var transcriptGenerationLogic
}

extension TranscriptResultViewModel {
  func videoFileUrl() -> URL {
    return transcriptGenerationLogic.videoUrl()
  }
  
  func generateTranscript() async {
    do {
      toggleIsFinished()
      changeState(to: .extractingAudio)
      try await transcriptGenerationLogic.extractAudioFromVideo()
      try await Task.sleep(for: .seconds(1))
      
      changeState(to: .generatingTranscript)
      transcriptResult = try await transcriptGenerationLogic.generateTranscript(for: lang)
      try await Task.sleep(for: .microseconds(10))
      
      changeState(to: .Finished)
      try await Task.sleep(for: .seconds(1))
      toggleIsFinished()
      deleteContent()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func rest() {
    viewState = .none
    transcriptResult = ""
    isFinished = true
  }
}

//MARK: -  Private Methods
extension TranscriptResultViewModel {
  private func deleteContent() {
    do {
      try transcriptGenerationLogic.deleteAudioFileContent()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func changeState(to state: TranscriptResultViewState) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      viewState = state
    }
  }
  
  private func toggleIsFinished() {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.isFinished.toggle()
    }
  }
}

enum TranscriptResultViewState: String {
  case none = ""
  case extractingAudio = "Extracting Audio from video"
  case generatingTranscript = "Generating Transcript"
  case Finished = "Finished"
}

extension TranscriptResultViewState {
  var progress: Float {
    switch self {
    case .none:
      return 0.0
    case .extractingAudio:
      return 0.5
    case .generatingTranscript:
      return 0.8
    case .Finished:
      return 1.0
    }
  }
}
