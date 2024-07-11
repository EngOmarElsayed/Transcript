//
//  AudioTranscript.swift
//
//
//  Created by Eng.Omar Elsayed on 11/07/2024.
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
    
    let transcript: String = try await withCheckedThrowingContinuation { continuation in
      sF.recognitionTask(with: request) { result, error in
        switch (result, error) {
        case (nil, let error?):
          continuation.resume(throwing: error)
          
        case(let result?, nil):
          continuation.resume(returning: result.bestTranscription.formattedString)
          
        case(let result?, let error?):
          continuation.resume(returning: result.bestTranscription.formattedString)
          
        default:
          continuation.resume(returning: "")
        }
      }
    }
    return transcript
  }
}
