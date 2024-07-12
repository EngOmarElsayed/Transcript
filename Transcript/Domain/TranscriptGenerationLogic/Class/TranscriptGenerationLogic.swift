//
//  TranscriptGenerationLogic.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 11/07/2024.
//

import Foundation
import Injection
import enum AudioTranscript.LocaleLanguage

final class TranscriptGenerationLogic: TranscriptGenerationLogicProtocol {
  @Injected(\.fileStorage) private var fileStorage
  @Injected(\.audioExtraction) private var audioExtraction
  @Injected(\.audioTranscript) private var audioTranscript
  
  private lazy var audioFile: URL = {
    return fileStorage.audioUrl()
  }()
  
  private lazy var videoFile: URL = {
    return fileStorage.videoUrl()
  }()
}

//MARK: - audioExtraction Methods
extension TranscriptGenerationLogic {
  func extractAudioFromVideo() async throws {
    try await audioExtraction.extractAudio(from: videoFile, to: audioFile)
  }
}

//MARK: - audioTranscript Methods
extension TranscriptGenerationLogic {
  func generateTranscript(for lang: LocaleLanguage) async throws -> String {
    return try await audioTranscript.generateTranscript(for: audioFile, lang: lang)
  }
}
