//
//  MainScreenViewModel.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 12/07/2024.
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

