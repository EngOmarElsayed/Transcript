//
//  TranscriptGenerationLogic.swift
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

//MARK: -  FileStorage Methods
extension TranscriptGenerationLogic {
  func deleteAudioFileContent() throws {
    try fileStorage.deleteContent(from: audioFile)
  }
  
  func videoUrl() -> URL {
    return videoFile
  }
}
