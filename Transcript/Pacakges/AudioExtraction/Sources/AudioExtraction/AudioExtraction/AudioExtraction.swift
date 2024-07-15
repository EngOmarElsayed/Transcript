//
//  AudioExtraction.swift
//
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

import AVFoundation

public struct AudioExtraction {
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
    print(avAssetExportSession.status.rawValue)
  }
  
  private func checkCompatibility(for avAsset: AVAsset) async -> Bool {
    await AVAssetExportSession.compatibility(ofExportPreset: AVAssetExportPresetAppleM4A, with: avAsset, outputFileType: .m4a)
  }
}
