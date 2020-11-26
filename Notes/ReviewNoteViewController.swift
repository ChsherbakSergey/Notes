//
//  ReviewNoteViewController.swift
//  Notes
//
//  Created by Sergey on 11/25/20.
//

import UIKit

class ReviewNoteViewController: UIViewController {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var composeButton: UIButton!
    
    public var noteTitle: String?
    public var note: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
    }

    func setInitialUI() {
        //
        navigationController?.navigationBar.barTintColor = .white
        //
        noteTitleLabel.text = noteTitle
        noteView.text = note
        //Buttons
        checkmarkButton.tintColor = UIColor.systemYellow
        cameraButton.tintColor = UIColor.systemYellow
        pencilButton.tintColor = UIColor.systemYellow
        composeButton.tintColor = UIColor.systemYellow
        //right bar Buttun
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: self, action: #selector(didTapEditButton))
    }
    
    @objc private func didTapEditButton() {
        print("Did tap Edit Button")
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
