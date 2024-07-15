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
      
      try await finishingTranscriptGen()
    } catch {
      try? await handleGenerateTranscriptError(error as NSError)
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
  private func handleGenerateTranscriptError(_ error: NSError) async throws {
    if error.code == 1110 {
      transcriptResult = error.localizedDescription
      try? await finishingTranscriptGen()
    } else {
      print(error.localizedDescription)
    }
  }
  
  private func finishingTranscriptGen() async throws {
    changeState(to: .Finished)
    try await Task.sleep(for: .seconds(1))
    toggleIsFinished()
    deleteContent()
  }
  
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
