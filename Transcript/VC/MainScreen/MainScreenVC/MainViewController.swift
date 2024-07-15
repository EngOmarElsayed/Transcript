//
//  ViewController.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 05/07/2024.
//

import UIKit
import PhotosUI
import Combine

class MainViewController: UIViewController {
  private let viewModel = MainScreenViewModel()
  private var phpPicker: PHPickerViewControllerDelegate!
  private var cancellable = Set<AnyCancellable>()
  
  //MARK: -  Outlets
  @IBOutlet var blurEffect: UIVisualEffectView!
  @IBOutlet var uploadedLabel: UILabel!
  @IBOutlet var generateButton: UIButton!
  @IBOutlet var popButton: UIButton!
  
  @IBAction func rectangleTapAction(_ sender: UITapGestureRecognizer) {
    let picker = setupPickerView()
    present(picker, animated: true)
  }
  
  //MARK: -  ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVC()
  }
}

//MARK: -  Setup Methods
extension MainViewController {
  
  private func setupVC() {
    setupViewControllerVar()
    setupPopUpButton()
    subscribeToPublishers()
    viewModel.requestAccess()
  }
  
  private func subscribeToPublishers() {
    viewModel.$isLoading.sink { [weak self] isLoading in
      guard let self else { return }
      blurEffect.isHidden = !isLoading
    }.store(in: &cancellable)
    
    viewModel.$isReadyToSubmit.sink { [weak self] isReadyToSubmit in
      guard let self else { return }
      generateButton.isEnabled = isReadyToSubmit
    }.store(in: &cancellable)
    
    viewModel.$isVideoSelected.sink { [weak self] isVideoSelected in
      guard let self else { return }
      uploadedLabel.text = isVideoSelected ? "File is successfully uploaded ✅": "Tap to uploaded your video"
    }.store(in: &cancellable)
  }
  
  private func setupViewControllerVar() {
    phpPicker = PHPPickerDelegate(pickerCompletion: viewModel.convertItemToVideo(_:))
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

