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

private struct AudioExtractionKey: InjectionKey {
  static var currentValue: AudioExtractionProtocol = AudioExtraction()
}

private struct FileStorageKey: InjectionKey {
  static var currentValue: FileStorageProtocol = FileStorage(for: .documentDirectory, in: .userDomainMask)
}

private struct MainViewLogicKey: InjectionKey {
  static var currentValue: MainViewLogicProtocol = MainViewLogic()
}

extension InjectedValues {
  var audioTranscript: AudioTranscriptProtocol {
    get { Self[AudioTranscriptKey.self] }
    set { Self[AudioTranscriptKey.self] = newValue }
  }
  
  var audioExtraction: AudioExtractionProtocol {
    get { Self[AudioExtractionKey.self] }
    set { Self[AudioExtractionKey.self] = newValue }
  }
  
  var fileStorage: FileStorageProtocol {
    get { Self[FileStorageKey.self] }
    set { Self[FileStorageKey.self] = newValue }
  }
  
  var mainViewLogic: MainViewLogicProtocol {
    get { Self[MainViewLogicKey.self] }
    set { Self[MainViewLogicKey.self] = newValue }
  }
}
