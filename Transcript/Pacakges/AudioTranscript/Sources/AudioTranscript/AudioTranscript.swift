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

extension AudioTranscript {
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
  
  public func generateTranscript(for audioUrl: URL, lang: LocaleLanguage? = nil) throws -> String {
    guard authorizationState == .authorized else { throw }
    let locale = lang == nil ? Locale.current: Locale(identifier: lang!.rawValue)
    
    return ""
  }
}

enum AudioTranscriptError {
  case NotAuthorized
}

extension AudioTranscriptError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .NotAuthorized:
      return "The app is not Authorized to use the speech detection"
    }
  }
  
  var recoverySuggestion: String? {
    switch self {
    case .NotAuthorized:
      return "Go to the settings and allow the app to access the speech detection"
    }
  }
}

public enum LocaleLanguage: String {
  case GbEnglish = "en-GB"
  case UsEnglish = "en-US"
  case EgArabic = "ar-EG"
}

extension LocaleLanguage {
  public var description: String {
    switch self {
    case .GbEnglish:
      return "English (United Kingdom)"
    case .UsEnglish:
      return "English (United States)"
    case .EgArabic:
      return "Arabic (Egypt)"
    }
  }
}
