//
//  Dependences.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 11/07/2024.
//

import Foundation
import Injection
import FileManger
import AudioExtraction
import AudioTranscript

private struct AudioTranscriptKey: InjectionKey {
  static var currentValue: AudioTranscriptProtocol = AudioTranscript()
}

private struct FileStorageKey: InjectionKey {
  static var currentValue: FileStorageProtocol = FileStorage(for: .documentDirectory, in: .userDomainMask)
}

extension InjectedValues {
  var fileStorage: FileStorageProtocol {
    get { Self[FileStorageKey.self] }
    set { Self[FileStorageKey.self] = newValue }
  }
  
  var audioTranscript: AudioTranscriptProtocol {
    get { Self[AudioTranscriptKey.self] }
    set { Self[AudioTranscriptKey.self] = newValue }
  }
}
