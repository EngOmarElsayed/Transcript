//
//  TranscriptResultViewState.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 15/07/2024.
//

import Foundation

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
