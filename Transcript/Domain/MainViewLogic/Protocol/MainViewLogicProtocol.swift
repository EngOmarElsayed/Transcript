//
//  MainViewLogicProtocol.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 12/07/2024.
//

import Foundation

protocol MainViewLogicProtocol {
  func copyContent(from url: URL) throws
  func requestAccessSpeechDetection(completion: @escaping (Bool) -> Void)
}
