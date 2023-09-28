//
//  Note.swift
//  NotesApp
//
//  Created by Mauricio Casillas on 22/09/23.
//

import Foundation

struct Note: Codable {
    var title: String
    var content: String
    var date: Date
}
