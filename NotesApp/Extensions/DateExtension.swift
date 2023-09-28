//
//  DateExtension.swift
//  NotesApp
//
//  Created by Mauricio Casillas on 23/09/23.
//

import Foundation

public extension Date {
    var iso8601String: String {
        Formatter.iso8601withFractionalSeconds.string(from: self)
    }
}

