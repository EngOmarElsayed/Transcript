//
//  FileStorage.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 06/07/2024.
//

import Foundation
import UniformTypeIdentifiers

public final class FileStorage {
  private var audioFileUrl: URL
  private var videoFileUrl: URL
  
  private let directoryUrl: URL
  private let fileManger = FileManager.default
  
  public init(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) {
    self.directoryUrl = fileManger.urls(for: directory, in: domainMask).first!
    self.audioFileUrl = directoryUrl.appendingPathComponent("audio", conformingTo: .mpeg4Audio)
    self.videoFileUrl = directoryUrl.appendingPathComponent("video", conformingTo: .movie)
  }
}

extension FileStorage: FileStorageProtocol {
  public func audioUrl() -> URL {
    return audioFileUrl
  }
  
  public func videoUrl() -> URL {
    return videoFileUrl
  }
  
  public func copyContent(from copyUrl: URL, to localUrl: URL) throws {
    try fileManger.copyItem(at: copyUrl, to: videoFileUrl)
  }
  
  public func deleteContent(from localUrl: URL) throws {
    let emptyData = Data()
    try emptyData.write(to: videoFileUrl)
  }
}

