//
//  ViewController.swift
//  Notes
//
//  Created by Sergey on 11/25/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let noNotesLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "No Notes Yet..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .systemGray2
        return label
    }()
    
    @IBOutlet weak var numberOfNotesLabel: UILabel!
    var noteCount = 0
    
    public var models = [(title: String, note: String)]()
//    public var models = [(title: String, note: NSMutableAttributedString)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInittialUI()
        setDelegatesAndDatasources()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Checks quantity of notes to show the right label
        noteCount = models.count
        if noteCount == 1 {
            numberOfNotesLabel.text = "\(noteCount) Note"
        } else {
            numberOfNotesLabel.text = "\(noteCount) Notes"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //set frame of noNotesLabel
        noNotesLabel.frame = CGRect(x: (view.frame.size.width / 2) - 100, y: (view.frame.size.height / 2) - 50, width: 200, height: 100)
    }

    func setUpInittialUI() {
        //Title of the controller
        title = "Notes"
        //Background Color of the controller
        view.backgroundColor = .systemGray6
        //Adding subviews
        view.addSubview(noNotesLabel)
        //setup of TableView
        tableView.layer.cornerRadius = 10
    }
    
    func setDelegatesAndDatasources() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didTapAddNote(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "createNewNote") as? CreateNoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.titleAgain = ""
        vc.noteTextAgain = ""
        vc.completion = { [weak self] noteTitle, note in
            self?.noNotesLabel.isHidden = true
            self?.tableView.isHidden = false
            self?.models.append((noteTitle, note))
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        //Code for working with NSMutableAttributedString
//        let cellNote = NSMutableAttributedString(attributedString: model.note)
//        cell.detailTextLabel?.attributedText = cellNote
        cell.detailTextLabel?.text = model.note
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        //Show the chosen note
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? ReviewNoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.indexPath = indexPath.row
        vc.noteTitle = model.title
        //Code for working with NSMutableAttributedString
//        let cellNote = NSMutableAttributedString(attributedString: model.note)
//        vc.note = cellNote
        vc.note = model.note
        vc.completion = { [weak self] noteTitle, note in
            self?.models.remove(at: indexPath.row)
            self?.models.insert((noteTitle, note), at: indexPath.row)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            models.remove(at: indexPath.row)
            noteCount -= 1
            DispatchQueue.main.async { [weak self] in
                guard let noteQuantity = self?.noteCount else {
                    return
                }
                if self?.noteCount == 1 {
                    self?.numberOfNotesLabel.text = "\(noteQuantity) Note"
                } else if self?.noteCount == 0 {
                    self?.tableView.isHidden = true
                    self?.noNotesLabel.isHidden = false
                    self?.numberOfNotesLabel.text = "\(noteQuantity) Notes"
                } else {
                    self?.numberOfNotesLabel.text = "\(noteQuantity) Notes"
                }
            }
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
