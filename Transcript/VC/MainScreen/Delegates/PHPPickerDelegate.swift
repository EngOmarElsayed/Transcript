//
//  PHPPickerDelegate.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 06/07/2024.
//

import PhotosUI

class PHPPickerDelegate: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    if results.isEmpty {
      picker.dismiss(animated: true)
    } else {
      results[0].itemProvider
    }
  }
}
