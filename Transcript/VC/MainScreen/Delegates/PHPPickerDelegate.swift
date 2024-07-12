//
//  PHPPickerDelegate.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 06/07/2024.
//

import PhotosUI

final class PHPPickerDelegate: PHPickerViewControllerDelegate {
  let pickerCompletion: () -> Void
  
  init(pickerCompletion: @escaping () -> Void) {
    self.pickerCompletion = pickerCompletion
  }
}

extension PHPPickerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    if results.isEmpty {
      picker.dismiss(animated: true)
    } else {
      // Fetch video then
      pickerCompletion()
    }
  }
}
