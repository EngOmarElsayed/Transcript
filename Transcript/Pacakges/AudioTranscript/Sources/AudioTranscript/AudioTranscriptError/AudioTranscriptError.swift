//
//  AudioTranscriptError.swift
//
//
//  Created by Eng.Omar Elsayed on 11/07/2024.
//

import Foundation

enum AudioTranscriptError {
  case NotAuthorized
  case unsupportedLang(lang: Locale)
  case isNotAvailable
}

extension AudioTranscriptError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .NotAuthorized:
      return "The app is not Authorized to use the speech detection"
      
    case .unsupportedLang(let lang):
      return "This \(lang.identifier) language is not supported by the speech detection yet"
      
    case .isNotAvailable:
      return "The speech detection isn't available at the moment"
    }
  }
  
  var recoverySuggestion: String? {
    switch self {
    case .NotAuthorized:
      return "Go to the settings and allow the app to access the speech detection"
    case .unsupportedLang:
      return "Choose another language"
    case .isNotAvailable:
      return "Check your network or try again later"
    }
  }
}
