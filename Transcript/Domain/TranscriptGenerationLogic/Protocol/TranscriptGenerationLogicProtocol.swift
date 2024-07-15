//
//  File.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 12/07/2024.
//

import Foundation
import enum AudioTranscript.LocaleLanguage

protocol TranscriptGenerationLogicProtocol {
  func extractAudioFromVideo() async throws
  func generateTranscript(for lang: LocaleLanguage) async throws -> String
  func deleteAudioFileContent() throws
  func videoUrl() -> URL
}
