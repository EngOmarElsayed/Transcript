import XCTest
import AVFAudio
import AVFoundation
@testable import AudioExtraction

final class AudioExtractionTests: XCTestCase {
  override func setUp() {
    FileMangerTest.tearDown()
  }
  
  override func tearDown() {
    FileMangerTest.tearDown()
  }
  
  func test_AudioExtraction_extractAudioAndWriteItToFile() async throws {
    if let videoUrl = Bundle.module.url(forResource: "test", withExtension: ".mov") {
      let audioFileUrl = FileMangerTest.audioFile
      
      try await AudioExtraction.extractAudio(from: videoUrl, to: audioFileUrl)
      
      playAudio(from: audioFileUrl)
    } else {
      XCTFail("didn't found file name")
    }
  }
  
  //MARK: -  Helpers
  
  fileprivate func playAudio(from url: URL) {
    do {
      let audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer.play()
    } catch {
      XCTFail("Failed to play audio file: \(error.localizedDescription)")
    }
  }
}

//MARK: -  Mocking FileManger for test

fileprivate class FileMangerTest {
  private static let fileManger = FileManager.default
  
  private static var directoryUrl: URL {
    fileManger.urls(for: .cachesDirectory, in: .userDomainMask).first!
  }
  
  static var audioFile: URL {
    directoryUrl.appendingPathComponent("audio", conformingTo: .mpeg4Audio)
  }
  
  static func tearDown() {
    try? fileManger.removeItem(at: audioFile)
  }
  
  static func contant(at url: URL) -> Data? {
    return fileManger.contents(atPath: url.absoluteString)
  }
}
