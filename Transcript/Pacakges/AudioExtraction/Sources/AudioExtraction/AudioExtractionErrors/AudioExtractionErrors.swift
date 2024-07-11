//
//  File.swift
//  
//
//  Created by Eng.Omar Elsayed on 11/07/2024.
//

import Foundation

internal enum AudioExtractionErrors: Error {
  case fileNotCompatibility
  case failedToCreateAVAssetExportSession
}

extension AudioExtractionErrors: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .fileNotCompatibility:
      return "The file you choose isn't compatible"
      
    case .failedToCreateAVAssetExportSession:
      return NSLocalizedString("Failed to create AVAssetExportSession", comment: "Try again later")
    }
  }
  
  var recoverySuggestion: String? {
    switch self {
    case .fileNotCompatibility:
      return "Choose another file"
      
    case .failedToCreateAVAssetExportSession:
      return "Try again later or try another file"
    }
  }
}
