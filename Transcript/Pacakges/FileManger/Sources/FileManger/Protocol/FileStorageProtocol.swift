//
//  FileStorageProtocol.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 06/07/2024.
//

import Foundation

public protocol FileStorageProtocol {
  func audioUrl() -> URL
  func videoUrl() -> URL
  
  func copyContent(from copyUrl: URL, to localUrl: CopyUrlToFile) throws
  func deleteContent(from localUrl: CopyUrlToFile) throws
}

