//
//  CreateNoteViewController.swift
//  Notes
//
//  Created by Sergey on 11/25/20.
//

import UIKit

class CreateNoteViewController: UIViewController {


    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var composeButton: UIButton!
    
    var completion: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setDelegates()
        titleTextView.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    @objc private func didTapDoneButton() {
        guard let title = titleTextView.text, !title.isEmpty, let noteText = noteTextView.text, !noteText.isEmpty else {
            return
        }
        noteTextView.resignFirstResponder()
        completion?(title, noteText)
    }
    
    func setInitialUI() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        //Buttons
        checkmarkButton.tintColor = UIColor.systemYellow
        cameraButton.tintColor = UIColor.systemYellow
        pencilButton.tintColor = UIColor.systemYellow
        composeButton.tintColor = UIColor.systemYellow
    }
    
    func setDelegates() {
        titleTextView.delegate = self
        noteTextView.delegate = self
    }

    @IBAction func checkmarkButtonIsTapped(_ sender: Any) {
        print("checkmark Button Is Tapped")
    }
    
    @IBAction func cameraButtonIsTapped(_ sender: Any) {
        print("camera Button Is Tapped")
    }
    
    @IBAction func pencilButtonIsTapped(_ sender: Any) {
        print("pencil Button Is Tapped")
    }
    
    @IBAction func composeButtonIsTapped(_ sender: Any) {
        print("compose Button Is Tapped")
    }
    
}

extension CreateNoteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextView {
            noteTextView.becomeFirstResponder()
        } else if textField == noteTextView {
            noteTextView.resignFirstResponder()
        }
        return true
        
    }
    
}



extension CreateNoteViewController: UITextViewDelegate {
    
}
