//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Mauricio Casillas on 23/09/23.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    @IBOutlet var noteTitle: UITextView!
    @IBOutlet var noteContent: UITextView!
    var newNote: Note?
    let alert = EmptyFieldAlert()

//        Referencias del ultimo segue y el indice del elemento clickado en la tabla
    var lastIndex: Int?
    var lastSegue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTitle.text = newNote?.title
        noteContent.text = newNote?.content
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        newNote = Note(title: noteTitle.text, content: noteContent.text, date: Date())
        let destination = segue.destination as! NotesTableViewController
        destination.note = newNote
        
//        Referencias del ultimo segue y el indice del elemento clickado en la tabla
        destination.lastSegue = lastSegue
        destination.lastIndex = lastIndex
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if(!noteTitle.text.isEmpty && !noteContent.text.isEmpty){
            return true
        }
        else{
            alert.showAlert(with: "Empty Fields!",
                            message: "Please fill all the \nfields to save the note.",
                            on: self)
            return false
        }
    }
    
    @objc func dismissAlert(){
        alert.dismissAlert()
    }
}

class EmptyFieldAlert {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var globalTargetView: UIView?
    
    func showAlert(with title: String, 
                   message: String,
                   on ViewController: UIViewController){
        
        guard let targetView = ViewController.view else{
            return
        }
        
        globalTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40,
                                 y: -300,
                                 width: targetView.frame.size.width-80,
                                 height: 300)
        
        let titleLabel = UILabel(frame: CGRect(x:0,
                                               y:0,
                                               width: alertView.frame.size.width,
                                               height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x:0,
                                                 y:80,
                                                 width: alertView.frame.size.width,
                                                 height: 170))
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.textAlignment = .center
        alertView.addSubview(messageLabel)
        
        let dismissBtn = UIButton(frame: CGRect(x: 0,
                                                y: alertView.frame.size.height-50,
                                                width: alertView.frame.size.width,
                                                height: 50))
        
        alertView.addSubview(dismissBtn)
        dismissBtn.setTitle("Dismiss", for: .normal)
        dismissBtn.setTitleColor(.link, for: .normal)
        dismissBtn.addTarget(self,
                             action: #selector(dismissAlert),
                             for: .touchUpInside)
        
        UIView.animate(withDuration: 0.25, 
                       animations: {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }, completion: { done in
            if done{
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = targetView.center
                })
            }
            
        })
    }
    
    @objc func dismissAlert(){
        
        guard let targetView = globalTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.size.height,
                                          width: targetView.frame.size.width-80,
                                          height: 300)
        }, completion: { done in
            if done{
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                }, completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                })
            }
            
        })
    }
}
