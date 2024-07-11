//
//  AudioExtractionProtocol.swift
//  
//
//  Created by Eng.Omar Elsayed on 07/07/2024.
//

import Foundation

public protocol AudioExtractionProtocol {
  static func extractAudio(from fileUrl: URL, to outputUrl: URL) async throws
}
