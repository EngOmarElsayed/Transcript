//
//  MainViewLogic.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 12/07/2024.
//

import Foundation
import Injection

final class MainViewLogic {
  @Injected(\.fileStorage) private var fileStorage
  @Injected(\.audioTranscript) private var audioTranscript
}

extension MainViewLogic: MainViewLogicProtocol {
  func copyContent(from url: URL) throws {
    try fileStorage.copyContent(from: url, to: nil)
  }
  
  func requestAccessSpeechDetection(completion: @escaping (Bool) -> Void) {
    audioTranscript.requestAudioAuthorization(completion: completion)
  }
}
