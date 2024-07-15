//
//  File.swift
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
//

import Foundation

internal enum AudioExtractionErrors: Error {
  case fileNotCompatibility
  case failedToCreateAVAssetExportSession
}

extension AudioExtractionErrors: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .fileNotCompatibility:
      return "The file you choose isn't compatible"
      
    case .failedToCreateAVAssetExportSession:
      return NSLocalizedString("Failed to create AVAssetExportSession", comment: "Try again later")
    }
  }
  
  var recoverySuggestion: String? {
    switch self {
    case .fileNotCompatibility:
      return "Choose another file"
      
    case .failedToCreateAVAssetExportSession:
      return "Try again later or try another file"
    }
  }
}
