//
//  TranscriptResultViewModel.swift
//  Transcript
//MIT License
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
