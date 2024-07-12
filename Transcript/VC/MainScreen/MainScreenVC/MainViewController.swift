//
//  ViewController.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 05/07/2024.
//

import UIKit

// File is successfully uploaded ✅

class MainViewController: UIViewController {
  private let viewModel = MainScreenViewModel()
  private var phpPicker: PHPPickerDelegate!
  
  //MARK: -  Outlets
  @IBOutlet var uploadedLabel: UILabel!
  @IBOutlet var generateButton: UIButton!
  @IBOutlet var popButton: UIButton!
  
  @IBAction func generateTranscriptAction(_ sender: UIButton) {
    
  }
  
  @IBAction func rectangleTapAction(_ sender: UITapGestureRecognizer) {
    
    print("Tapped, Well Done Omar. El7")
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
  }
  
  private func setupViewControllerVar() {
    phpPicker = PHPPickerDelegate(pickerCompletion: { [weak self] in
      guard let self else { return }
      viewModel.isVideoSelected = true
    })
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
}

