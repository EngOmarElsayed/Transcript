//
//  AudioExtraction.swift
//
//
//  Created by Eng.Omar Elsayed on 07/07/2024.
//

import AVFoundation

public final class AudioExtraction {
  public init() {}
}

//MARK: - AudioExtraction conforms to AudioExtractionProtocol
extension AudioExtraction: AudioExtractionProtocol {
  public func extractAudio(from fileUrl: URL, to outputUrl: URL) async throws {
    try await createAVAssetExportSession(for: outputUrl, from: fileUrl)
  }
}

//MARK: -  Private Methods
extension AudioExtraction {
  private func createAVAssetExportSession(for outputUrl: URL, from videoUrl: URL) async throws {
    let avAsset = AVAsset(url: videoUrl)
    
    guard await checkCompatibility(for: avAsset) else { throw AudioExtractionErrors.fileNotCompatibility }
    
    guard let avAssetExportSession = AVAssetExportSession(asset: consume avAsset, presetName: AVAssetExportPresetAppleM4A) else { throw AudioExtractionErrors.failedToCreateAVAssetExportSession }
    
    avAssetExportSession.outputFileType = .m4a
    avAssetExportSession.outputURL = outputUrl
    
    await avAssetExportSession.export()
  }
  
  private func checkCompatibility(for avAsset: AVAsset) async -> Bool {
    await AVAssetExportSession.compatibility(ofExportPreset: AVAssetExportPresetAppleM4A, with: avAsset, outputFileType: .m4a)
  }
}
