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
    
    var completion: ((String, String, String) -> Void)?
//    var completion: ((String, NSMutableAttributedString) -> Void)?
    
    var titleAgain = ""
    var noteTextAgain = ""
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.dateStyle = .short
        formatter.string(from: Date())
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setDelegates()
        setNotification()
        titleTextView.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func didTapDoneButton() {
        let date = formatter.string(from: Date())
        noteTextView.resignFirstResponder()
        if titleAgain == titleTextView.text && noteTextAgain == noteTextView.text {
            return
        }
        guard let title = titleTextView.text, !title.isEmpty,
              let noteText = noteTextView.text, !noteText.isEmpty else {
            return
        }
        titleAgain = title
        noteTextAgain = noteText
        completion?(title, noteText, date)
        
        
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
        presentPhotoActionSheet()
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
    
    @objc func updateTextView(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardEndFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = UIEdgeInsets.zero
        } else {
            noteTextView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
            noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        }
        noteTextView.scrollRangeToVisible(noteTextView.selectedRange)
    }
    
}

extension CreateNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "", message: "How would you like to select a photo?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        let image = selectedImage
        let attachment = NSTextAttachment()
        attachment.image = image
        let oldWidth = attachment.image!.size.width;
        let scaleFactor = oldWidth / (noteTextView.frame.size.width - 10) //for the padding inside the textView
        attachment.image = UIImage(cgImage: attachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        guard let initialText = noteTextView.attributedText else {
            return
        }
        let newText = NSMutableAttributedString(attributedString: initialText)
        newText.append(NSAttributedString(attachment: attachment))
        noteTextView.attributedText = newText
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


