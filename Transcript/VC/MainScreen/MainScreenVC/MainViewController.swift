//
//  ViewController.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 05/07/2024.
//

import UIKit
import PhotosUI
// File is successfully uploaded ✅

class MainViewController: UIViewController {
  private let viewModel = MainScreenViewModel()
  private var phpPicker: PHPickerViewControllerDelegate!
  
  //MARK: -  Outlets
  @IBOutlet var blurEffect: UIVisualEffectView!
  @IBOutlet var uploadedLabel: UILabel!
  @IBOutlet var generateButton: UIButton!
  @IBOutlet var popButton: UIButton!
  
  @IBAction func generateTranscriptAction(_ sender: UIButton) {
    
  }
  
  @IBAction func rectangleTapAction(_ sender: UITapGestureRecognizer) {
    let picker = setupPickerView()
    present(picker, animated: true)
  }
  
  //MARK: -  ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVC()
    viewModel.requestAccess()
  }
}

//MARK: -  Setup Methods
extension MainViewController {
  private func setupVC() {
    setupViewControllerVar()
    setupPopUpButton()
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

