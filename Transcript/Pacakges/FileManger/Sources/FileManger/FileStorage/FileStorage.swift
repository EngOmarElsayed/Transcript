//
//  FileStorage.swift
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
import UniformTypeIdentifiers

public final class FileStorage {
  private var audioFileUrl: URL
  private var videoFileUrl: URL
  
  private let directoryUrl: URL
  private let fileManger = FileManager.default
  
  public init(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) {
    self.directoryUrl = fileManger.urls(for: directory, in: domainMask).first!
    self.audioFileUrl = directoryUrl.appendingPathComponent("audio", conformingTo: .mpeg4Audio)
    self.videoFileUrl = directoryUrl.appendingPathComponent("video", conformingTo: .mpeg4Movie)
  }
}

extension FileStorage: FileStorageProtocol {
  public func audioUrl() -> URL {
    return audioFileUrl
  }
  
  public func videoUrl() -> URL {
    return videoFileUrl
  }
  
  public func copyContent(from copyUrl: URL, to localUrl: URL? = nil) throws {
    let localUrl = localUrl == nil ? videoFileUrl: localUrl!
    try? deleteContent(from: localUrl)
    try fileManger.copyItem(at: copyUrl, to: localUrl)
  }
  
  public func deleteContent(from localUrl: URL) throws {
    try fileManger.removeItem(at: localUrl)
  }
}

