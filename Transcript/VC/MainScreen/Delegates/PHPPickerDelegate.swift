//
//  PHPPickerDelegate.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 06/07/2024.
//

import PhotosUI

final class PHPPickerDelegate: PHPickerViewControllerDelegate {
  private let pickerCompletion: (NSItemProvider) -> Void
  
  init(pickerCompletion: @escaping (NSItemProvider) -> Void) {
    self.pickerCompletion = pickerCompletion
  }
}

extension PHPPickerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    if !results.isEmpty {
      guard let item = results.first?.itemProvider, item.hasItemConformingToTypeIdentifier(UTType.movie.identifier) else { return }
      pickerCompletion(item)
    }
  }
}
