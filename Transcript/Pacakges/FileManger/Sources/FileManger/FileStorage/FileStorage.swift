//
//  FileStorage.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 06/07/2024.
//

import Foundation
import UniformTypeIdentifiers

public final class FileStorage: FileStorageProtocol {
  public let shared = FileStorage()
  
  private var audioFileUrl: URL
  private var videoFileUrl: URL
  
  private let directoryUrl: URL
  private let fileManger = FileManager.default
  
  private init() {
    self.directoryUrl = fileManger.urls(for: .documentDirectory, in: .userDomainMask).first!
    self.audioFileUrl = directoryUrl.appendingPathComponent("audio", conformingTo: .mp3)
    self.videoFileUrl = directoryUrl.appendingPathComponent("video", conformingTo: .movie)
  }
}

extension FileStorage {
  public func audioUrl() -> URL {
    return audioFileUrl
  }
  
  public func videoUrl() -> URL {
    return videoFileUrl
  }
  
  public func copyContent(from copyUrl: URL, to localUrl: CopyUrlToFile) throws {
    switch localUrl {
    case .audioFile:
      try fileManger.copyItem(at: copyUrl, to: audioFileUrl)
      
    case .videoFile:
      try fileManger.copyItem(at: copyUrl, to: videoFileUrl)
    }
  }
  
  public func deleteContent(from localUrl: CopyUrlToFile) throws {
    let emptyData = Data()
    
    switch localUrl {
    case .audioFile:
      try emptyData.write(to: audioFileUrl)
    case .videoFile:
      try emptyData.write(to: videoFileUrl)
    }
  }
}

