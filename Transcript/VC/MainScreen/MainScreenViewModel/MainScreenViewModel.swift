//
//  MainScreenViewModel.swift
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

import Foundation
import Injection
import AudioTranscript
import UniformTypeIdentifiers
import UserDefaults

final class MainScreenViewModel {
  let langArray: [LocaleLanguage] = LocaleLanguage.allCases
  
  @Published var isLoading: Bool = false
  @Published var isReadyToSubmit: Bool = false
  @Published var isVideoSelected: Bool = false {
    didSet {
      isReadyToSubmit = isVideoSelected && isAllowedAccess
    }
  }
  
  private var isAllowedAccess: Bool = false
  @Injected(\.mainViewLogic) private var mainViewLogic
  @UserDefault(\.chosenLang) private var lang: LocaleLanguage = .GbEnglish {
    didSet {
      isReadyToSubmit = isVideoSelected && isAllowedAccess
    }
  }
}

extension MainScreenViewModel {
  func requestAccess() {
    mainViewLogic.requestAccessSpeechDetection { [weak self] result in
      guard let self else { return }
      isAllowedAccess = result
    }
  }
  
  func copyContent(from url: URL) {
    do {
      try mainViewLogic.copyContent(from: url)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func convertItemToVideo(_ item: NSItemProvider) {
    isLoading = true
    item.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
      guard let url, let self else { return }
      copyContent(from: url)
      DispatchQueue.main.async { self.videoIsSelected() }
    }
  }
  
  func changeSelectedLang(to lang: LocaleLanguage) {
    self.lang = lang
  }
}

//MARK: -  Private Methods
extension MainScreenViewModel {
  private func videoIsSelected() {
    isLoading = false
    isVideoSelected = true
  }
}

