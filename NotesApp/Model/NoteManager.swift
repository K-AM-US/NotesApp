//
//  NoteManager.swift
//  NotesApp
//
//  Created by Mauricio Casillas on 22/09/23.
//

import Foundation

class NoteManager {
    private var notes: [Note] = []
    
    init(){
        loadNotes()
    }
    
    func createNote(note: Note){
        notes.append(note)
    }
    
    func deleteNote(at index: Int){
        notes.remove(at: index)
    }
    
    func updateNote(note: Note, at index: Int){
        notes[index] = note
    }
    
    func countNotes() -> Int {
        return notes.count
    }
    
    func getNote(at index: Int) -> Note{
        return notes[index]
    }
    
    // lo que tengan las notes en este momento
    func getNotes() -> [Note] {
        return notes
    }
    
    func getFilePath() -> URL{
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let noteUrlPath = documentDirectory.appendingPathComponent("notes.json")
        
        return URL(string: noteUrlPath.absoluteString)!
    }
    
//  carga las notas del archivo en donde se van a guardar
    func loadNotes(){
        let notesPath = getFilePath()
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: notesPath.path){
            do{
                let jsonData = fileManager.contents(atPath: notesPath.path)
                notes = try JSONDecoder().decode([Note].self, from: jsonData!)
            }catch let error{
                print(error)
            }
        }else{
            print("ruta: ",notesPath.path)
            fileManager.createFile(atPath: notesPath.path, contents: nil)
        }
    }
    
    func saveNotes(){
        let fileManager = FileManager.default
        do{
            let jsonData = try JSONEncoder().encode(notes)
            fileManager.createFile(atPath: getFilePath().path, contents: jsonData)
            print(getFilePath().path)
        }catch let error{
            print(error)
        }
    }
}
