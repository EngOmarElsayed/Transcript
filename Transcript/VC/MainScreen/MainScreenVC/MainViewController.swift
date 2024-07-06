//
//  ViewController.swift
//  Transcript
//
//  Created by Eng.Omar Elsayed on 05/07/2024.
//

import UIKit

// File is successfully uploaded ✅

class MainViewController: UIViewController {
  private var phDe = PHPPickerDelegate()
  @IBOutlet var uploadedLabel: UILabel!
  @IBOutlet var generateButton: UIButton!
  
  
  @IBAction func generateTranscriptAction(_ sender: UIButton) {
    
  }
  
  @IBAction func rectangleTapAction(_ sender: UITapGestureRecognizer) {
    
    print("Tapped, Well Done Omar. El7")
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
//    items.menu?.children this will be edited to add the menu
    }
}

