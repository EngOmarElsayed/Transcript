//
//  AudioTranscriptProtocol.swift
//
//
//  Created by Eng.Omar Elsayed on 11/07/2024.
//

import Foundation

public protocol AudioTranscriptProtocol {
  func requestAudioAuthorization(completion: @escaping (Bool) -> Void)
  func generateTranscript(for audioUrl: URL, lang: LocaleLanguage?) async throws -> String
}
