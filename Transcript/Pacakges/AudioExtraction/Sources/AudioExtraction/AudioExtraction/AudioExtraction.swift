//
//  AudioExtraction.swift
//
//
//  Created by Eng.Omar Elsayed on 07/07/2024.
//

import AVFoundation

public final class AudioExtraction {
  private var avAsset: AVAsset?
  private var avAssetExportSession: AVAssetExportSession?
  
  public init() {}
}

//MARK: - AudioExtraction conforms to AudioExtractionProtocol

extension AudioExtraction: AudioExtractionProtocol {
  public func extractAudio(from fileUrl: URL, to outputUrl: URL) async {
    createAVAsset(for: fileUrl)
    createAVAssetExportSession(for: outputUrl)
    await exportAudio()
  }
}

//MARK: -  Private Methods

extension AudioExtraction {
  private func createAVAsset(for fileUrl: URL) {
    avAsset = AVAsset(url: fileUrl)
  }
  
  private func createAVAssetExportSession(for outputUrl: URL) {
    guard let avAsset else { return }
    avAssetExportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetAppleM4A)
    avAssetExportSession?.outputFileType = .mp3
    avAssetExportSession?.outputURL = outputUrl
  }
  
  private func exportAudio() async {
    guard let avAssetExportSession else { return }
    await avAssetExportSession.export()
  }
}
