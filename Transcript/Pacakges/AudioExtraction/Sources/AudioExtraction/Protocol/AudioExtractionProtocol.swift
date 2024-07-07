//
//  AudioExtractionProtocol.swift
//  
//
//  Created by Eng.Omar Elsayed on 07/07/2024.
//

import Foundation

protocol AudioExtractionProtocol {
  func extractAudio(from fileUrl: URL, to outputUrl: URL) async
}
