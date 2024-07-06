//
//  FileStorage.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 06/07/2024.
//

import XCTest
import FileManger

final class FileMangerTests: XCTestCase {
  override func tearDown() {
    FileMangerTest.tearDown()
  }
  
  func test_FileStorage_initCreatesPathForAudioAndVideoFiles() {
    let expectedAudioFileUrl = FileMangerTest.audioFile
    let expectedVideoFileUrl = FileMangerTest.videoFile
    
    let fileStorage = FileStorage(for: .cachesDirectory, in: .userDomainMask)
    
    XCTAssertEqual(fileStorage.audioUrl(), expectedAudioFileUrl, "\(fileStorage.audioUrl()) is not equal to the expected \(expectedAudioFileUrl)")
    XCTAssertEqual(fileStorage.videoUrl(), expectedVideoFileUrl, "\(fileStorage.videoUrl()) is not equal to the expected \(expectedVideoFileUrl)")
  }
  
  func test_FileStorage_copyContentCopyToAudioFile() {
    let copyUrl = FileMangerTest.videoFile
    let fileStorage = FileStorage(for: .cachesDirectory, in: .userDomainMask)
    
    try? Data(repeating: 30, count: 50).write(to: copyUrl)
    try? fileStorage.copyContent(from: copyUrl, to: .audioFile)
    let expectedData = FileMangerTest.contant(at: copyUrl)
    let resultedData = FileMangerTest.contant(at: fileStorage.audioUrl())
    
    XCTAssertEqual(resultedData, expectedData, "\(resultedData?.debugDescription ?? "") is not equal to the expected \(expectedData?.debugDescription ?? "")")
  }
  
  func test_FileStorage_copyContentCopyToVideoFile() {
    let copyUrl = FileMangerTest.audioFile
    let fileStorage = FileStorage(for: .cachesDirectory, in: .userDomainMask)
    
    try? Data(repeating: 30, count: 50).write(to: copyUrl)
    try? fileStorage.copyContent(from: copyUrl, to: .videoFile)
    let expectedData = FileMangerTest.contant(at: copyUrl)
    let resultedData = FileMangerTest.contant(at: fileStorage.videoUrl())
    
    XCTAssertEqual(resultedData, expectedData, "\(resultedData?.debugDescription ?? "") is not equal to the expected \(expectedData?.debugDescription ?? "")")
  }
  
  func test_FileStorage_deleteContentOfAudioFile() {
    let copyUrl = FileMangerTest.audioFile
    let fileStorage = FileStorage(for: .cachesDirectory, in: .userDomainMask)
    
    try? Data(repeating: 30, count: 50).write(to: copyUrl)
    try? fileStorage.deleteContent(from: .audioFile)
    let resultedData = FileMangerTest.contant(at: fileStorage.audioUrl())
    
    XCTAssertNil(resultedData, "The file content contented \(resultedData?.debugDescription ?? "")")
  }
  
  func test_FileStorage_deleteContentOfVideoFile() {
    let copyUrl = FileMangerTest.videoFile
    let fileStorage = FileStorage(for: .cachesDirectory, in: .userDomainMask)
    
    try? Data(repeating: 30, count: 50).write(to: copyUrl)
    try? fileStorage.deleteContent(from: .videoFile)
    let resultedData = FileMangerTest.contant(at: fileStorage.videoUrl())
    
    XCTAssertNil(resultedData, "The file content contented \(resultedData?.debugDescription ?? "")")
  }
}

fileprivate class FileMangerTest {
  private static let fileManger = FileManager.default
  
  private static var directoryUrl: URL {
    fileManger.urls(for: .cachesDirectory, in: .userDomainMask).first!
  }
  
  static var audioFile: URL {
    directoryUrl.appendingPathComponent("audio", conformingTo: .mp3)
  }
  
  static var videoFile: URL {
    directoryUrl.appendingPathComponent("video", conformingTo: .movie)
  }
  
  static func tearDown() {
    try? fileManger.removeItem(at: audioFile)
    try? fileManger.removeItem(at: videoFile)
  }
  
  static func contant(at url: URL) -> Data? {
    return fileManger.contents(atPath: url.absoluteString)
  }
}
