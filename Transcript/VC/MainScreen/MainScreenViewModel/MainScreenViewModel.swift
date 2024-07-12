//
//  MainScreenViewModel.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 12/07/2024.
//

import Foundation
import Injection
import AudioTranscript

final class MainScreenViewModel {
  let langArray: [LocaleLanguage] = LocaleLanguage.allCases
  
  @Published var isReadyToSubmit: Bool = false
  @Published var isAllowedAccess: Bool = false
  @Published var isVideoSelected: Bool = false {
    didSet {
      isReadyToSubmit = isVideoSelected
    }
  }
  
  private var lang: LocaleLanguage = .UsEnglish {
    didSet {
      isReadyToSubmit = isVideoSelected
    }
  }
  
  @Injected(\.mainViewLogic) private var mainViewLogic
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
  
  func changeSelectedLang(to lang: LocaleLanguage) {
    self.lang = lang
    print(self.lang.rawValue)
  }
}
