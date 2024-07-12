//
//  LocaleLanguage.swift
//  
//
//  Created by Eng.Omar Elsayed on 11/07/2024.
//

import Foundation

public enum LocaleLanguage: String {
  case GbEnglish = "en-GB"
  case UsEnglish = "en-US"
  case EgArabic = "ar-EG"
}

extension LocaleLanguage {
  public var description: String {
    switch self {
    case .GbEnglish:
      return "English (UK 🇬🇧)"
    case .UsEnglish:
      return "English (US 🇺🇸)"
    case .EgArabic:
      return "Arabic (Egypt 🇪🇬)"
    }
  }
}

extension LocaleLanguage: CaseIterable {}
