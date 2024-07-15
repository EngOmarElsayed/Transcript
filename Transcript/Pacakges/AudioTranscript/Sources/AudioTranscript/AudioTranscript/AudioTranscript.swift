//
//  AudioTranscript.swift
//
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

import Foundation
import Speech

public final class AudioTranscript {
  private var authorizationState: SFSpeechRecognizerAuthorizationStatus = .notDetermined
  public init() {}
}

//MARK: -  AudioTranscriptProtocol
extension AudioTranscript: AudioTranscriptProtocol {
  public func requestAudioAuthorization(completion: @escaping (Bool) -> Void)  {
    SFSpeechRecognizer.requestAuthorization { [weak self] authState in
      guard let self else { return }
      self.authorizationState = authState
      
      switch authState {
      case .notDetermined, .denied, .restricted:
        completion(false)
        
      case .authorized:
        completion(true)
        
      @unknown default:
        completion(false)
      }
    }
  }
  
  public func generateTranscript(for audioUrl: URL, lang: LocaleLanguage? = nil) async throws -> String {
    guard authorizationState == .authorized else { throw AudioTranscriptError.NotAuthorized }
    let locale = lang == nil ? Locale.current: Locale(identifier: lang!.rawValue)
    
    guard let sF = SFSpeechRecognizer(locale: locale) else { throw AudioTranscriptError.unsupportedLang(lang: locale) }
    guard sF.isAvailable else { throw AudioTranscriptError.isNotAvailable }
    
    return try await createRecognitionRequest(for: audioUrl, and: sF)
  }
}

//MARK: -  Private Methods
extension AudioTranscript {
  private func createRecognitionRequest(for audioUrl: URL, and sF: SFSpeechRecognizer) async throws -> String {
    let request = SFSpeechURLRecognitionRequest(url: audioUrl)
    request.shouldReportPartialResults = false
    request.addsPunctuation = true
    
    return try await recognitionTask(for: request, and: sF)
  }
  
  private func recognitionTask(for request: SFSpeechURLRecognitionRequest, and sF: SFSpeechRecognizer) async throws -> String {
    try await withCheckedThrowingContinuation { continuation in
      sF.recognitionTask(with: request) { result, error in
        switch (result, error) {
        case (.none, let error?):
          continuation.resume(throwing: error)
          
        case(let result?, .none):
          continuation.resume(returning: result.bestTranscription.formattedString)
          
        case(let result?, .some(_)):
          continuation.resume(returning: result.bestTranscription.formattedString)
          
        default:
          continuation.resume(returning: "")
        }
      }
    }
  }
}
