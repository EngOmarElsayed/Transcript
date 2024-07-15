//
//  FileStorage.swift
//  Transcript


Copyright (c) 2024 Omar Elsayed

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Copyright (c) 2024 Omar Elsayed

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. on 06/07/2024.
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
    let audioFile = fileStorage.audioUrl()
    
    try? Data(repeating: 30, count: 50).write(to: copyUrl)
    try? fileStorage.copyContent(from: copyUrl, to: audioFile)
    let expectedData = FileMangerTest.contant(at: copyUrl)
    let resultedData = FileMangerTest.contant(at: fileStorage.audioUrl())
    
    XCTAssertEqual(resultedData, expectedData, "\(resultedData?.debugDescription ?? "") is not equal to the expected \(expectedData?.debugDescription ?? "")")
  }
  
  func test_FileStorage_copyContentCopyToVideoFile() {
    let copyUrl = FileMangerTest.audioFile
    let fileStorage = FileStorage(for: .cachesDirectory, in: .userDomainMask)
    let videoFile = fileStorage.videoUrl()
    
    try? Data(repeating: 30, count: 50).write(to: copyUrl)
    try? fileStorage.copyContent(from: copyUrl, to: videoFile)
    let expectedData = FileMangerTest.contant(at: copyUrl)
    let resultedData = FileMangerTest.contant(at: fileStorage.videoUrl())
    
    XCTAssertEqual(resultedData, expectedData, "\(resultedData?.debugDescription ?? "") is not equal to the expected \(expectedData?.debugDescription ?? "")")
  }
  
  func test_FileStorage_deleteContentOfAudioFile() {
    let copyUrl = FileMangerTest.audioFile
    let fileStorage = FileStorage(for: .cachesDirectory, in: .userDomainMask)
    let audioFile = fileStorage.audioUrl()
    
    try? Data(repeating: 30, count: 50).write(to: copyUrl)
    try? fileStorage.deleteContent(from: audioFile)
    let resultedData = FileMangerTest.contant(at: fileStorage.audioUrl())
    
    XCTAssertNil(resultedData, "The file content contented \(resultedData?.debugDescription ?? "")")
  }
  
  func test_FileStorage_deleteContentOfVideoFile() {
    let copyUrl = FileMangerTest.videoFile
    let fileStorage = FileStorage(for: .cachesDirectory, in: .userDomainMask)
    let videoFile = fileStorage.videoUrl()
    
    try? Data(repeating: 30, count: 50).write(to: copyUrl)
    try? fileStorage.deleteContent(from: videoFile)
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
    directoryUrl.appendingPathComponent("audio", conformingTo: .mpeg4Audio)
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
