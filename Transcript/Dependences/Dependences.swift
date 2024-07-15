//
//  Dependences.swift
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

private struct TranscriptGenerationLogicKey: InjectionKey {
  static var currentValue: TranscriptGenerationLogicProtocol = TranscriptGenerationLogic()
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
  
  var transcriptGenerationLogic: TranscriptGenerationLogicProtocol {
    get { Self[TranscriptGenerationLogicKey.self] }
    set { Self[TranscriptGenerationLogicKey.self] = newValue }
  }
}
