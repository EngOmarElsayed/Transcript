//
//  ViewController.swift
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
//

import UIKit
import PhotosUI
import Combine

class MainViewController: UIViewController {
  private let viewModel = MainScreenViewModel()
  private var phpPicker: PHPickerViewControllerDelegate!
  private var cancellable = Set<AnyCancellable>()
  
  //MARK: -  Outlets
  @IBOutlet var undoButton: UIBarButtonItem!
  @IBOutlet var blurEffect: UIVisualEffectView!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var uploadedLabel: UILabel!
  @IBOutlet var generateButton: UIButton!
  @IBOutlet var popButton: UIButton!
  
  
  @IBAction func undoButtonAction(_ sender: UIBarButtonItem) {
    viewModel.isVideoSelected = false
  }
  
  @IBAction func rectangleTapAction(_ sender: UITapGestureRecognizer) {
    let picker = setupPickerView()
    present(picker, animated: true)
  }
  
  //MARK: -  ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVC()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    viewModel.isVideoSelected = false
  }
}

//MARK: -  Setup Methods
extension MainViewController {
  private func setupVC() {
    phpPicker = PHPPickerDelegate(pickerCompletion: viewModel.convertItemToVideo(_:))
    setupPopUpButton()
    subscribeToPublishers()
    viewModel.requestAccess()
  }

  private func subscribeToPublishers() {
    viewModel.$isLoading.sink { [weak self] isLoading in
      guard let self else { return }
      changeBluerEffectVisibility(isLoading)
    }.store(in: &cancellable)
    
    viewModel.$isReadyToSubmit.sink { [weak self] isReadyToSubmit in
      guard let self else { return }
      enableGenButton(isReadyToSubmit)
    }.store(in: &cancellable)
    
    viewModel.$isVideoSelected.sink { [weak self] isVideoSelected in
      guard let self else { return }
      updateLabelImageView(isVideoSelected)
    }.store(in: &cancellable)
  }
    
  private func setupPopUpButton() {
    var arrayOfActions = [UIAction]()
    for lang in viewModel.langArray {
      let action = UIAction(title: lang.description) { [weak self] (action) in
        guard let self else { return }
        viewModel.changeSelectedLang(to: lang)
      }
      arrayOfActions.append(action)
    }
    
    let menu = UIMenu(title: "Select Language", options: .displayInline, children: arrayOfActions)
    popButton.menu = consume menu
    popButton.showsMenuAsPrimaryAction = true
  }
  
  private func setupPickerView() -> PHPickerViewController {
    var configurationForPHP = PHPickerConfiguration()
    configurationForPHP.filter = .videos
    configurationForPHP.selectionLimit = 1
    configurationForPHP.selection = .default
    
    let picker = PHPickerViewController(configuration: configurationForPHP)
    picker.delegate = phpPicker
    
    return picker
  }
}

//MARK: -  UI Changes Methods
extension MainViewController {
  private func enableGenButton(_ isReadyToSubmit: Bool) {
    generateButton.isEnabled = isReadyToSubmit
  }
  
  private func changeBluerEffectVisibility(_ isLoading: Bool) {
    blurEffect.isHidden = !isLoading
  }
  
  private func updateLabelImageView(_ isVideoSelected: Bool) {
    uploadedLabel.text = isVideoSelected ? "File is successfully uploaded ✅": "Tap to uploaded your video"
    undoButton.isHidden = !isVideoSelected
    setupImageView(isVideoSelected)
  }
  
  private func setupImageView(_ isVideoSelected: Bool) {
    var colors: [UIColor] = []
    var imageString = ""
    
    if isVideoSelected {
      colors = [.systemGreen]
      imageString = "photo.badge.checkmark"
    } else {
      colors = [.systemGreen, .imageBlack]
      imageString = "photo.badge.arrow.down"
    }
    
    let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: colors)
    imageView.image = UIImage(systemName: imageString, withConfiguration: symbolConfiguration)
  }
}

