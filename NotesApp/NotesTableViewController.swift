//
//  NotesTableViewController.swift
//  NotesApp
//
//  Created by Mauricio Casillas on 22/09/23.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    @IBOutlet var emptyNotesView: UIView!
    @IBOutlet var tableViewNotes: UITableView!
    var note: Note? 
    
//    guardan el valor del segue que llamó al viewcontroller y el indice del elemento en la tabla
    var lastIndex: Int?
    var lastSegue: String?

    let noteManager = NoteManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (noteManager.countNotes() == 0){
            emptyNotesView.isHidden = false
            tableViewNotes.backgroundView = emptyNotesView
        }else{
            emptyNotesView.isHidden = true
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteManager.countNotes()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        
        cell.cellTitle.text = noteManager.getNote(at: indexPath.row).title
        cell.cellContent.text = noteManager.getNote(at: indexPath.row).date.iso8601String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        note = noteManager.getNote(at: indexPath.row)
        lastIndex = indexPath.row
        performSegue(withIdentifier: "noteDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            noteManager.deleteNote(at: indexPath.row)
            noteManager.saveNotes()
            tableViewNotes.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteDetail" {
            let destination = segue.destination as! UINavigationController
            let destinationTemp = destination.topViewController as! AddNoteViewController
            destinationTemp.newNote = note
            destinationTemp.lastIndex = lastIndex
            destinationTemp.lastSegue = segue.identifier
        }
    }
    
    @IBAction func unWindFromNotesTableViewController(segue: UIStoryboardSegue){
        let source = segue.source as! AddNoteViewController
        
        note = source.newNote
        lastIndex = source.lastIndex
        
        if source.lastSegue == "noteDetail"{
            noteManager.updateNote(note: note!, at: lastIndex!)
            noteManager.saveNotes()
            tableViewNotes.reloadData()
        }else{
            noteManager.createNote(note: note!)
            noteManager.saveNotes()
            tableViewNotes.reloadData()
        }
    }
}
