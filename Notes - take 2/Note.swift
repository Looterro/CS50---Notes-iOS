//
//  Note.swift
//  Notes - take 2
//
//  Created by Jakub Łata on 24/11/2022.
//

import Foundation
import SQLite3

struct Note {
    let id: Int
    //make sure contents are mutable
    var contents: String
}

//Handling all the actions regarding notes
class NoteManager {
    
    //Reference to the database, making opening the file faster, since connecting by itself is slow
    var database: OpaquePointer!
    
    //Create a SINGLETON, meaning this class will be created only one instance of it. Variable main allows this class to reference itself, static keyword allows for accessing this property without an instance
    static let main = NoteManager()
    
    //Protect against anyone else instantiating your class. When working with other people or creating an API this is specifically useful to make sure there are no more NoteManagers than this one
    private init() {
    }
    
    //Get a path somewhere in files to safely read and save files
    func connect() {
        
        //If pointer is already established through the function, dont let the function go on and immediately return - this prevents unnecessary multiple connections if the path is already pointed at
        if database != nil {
            return
        }
        
        //safeguard against crash when user not having permissions to acess that path in filemanager
        do {
            
            //create a path notes.sqlite in user File manager
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            
            //check if data works by using the commands - open sqlite, first argument is the file we want to open and then the second is the reference, the pointer to the path
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                
                // Check if function to execute create table worked and continue
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (contents TEXT)", nil, nil, nil) == SQLITE_OK {
                    
                } else {
                    print("Could not create table")
                }
                
            }
            else {
                print("Could not connect")
            }
            
        } catch let error {
            print("Could not create database")
        }
    }
    
    //function to create notes, returns an int with id
    func create() -> Int {
        
        //Make sure that there is a database pointer established
        connect()
        
        //create a pointer to a memory cell
        var statement: OpaquePointer!
        
        //After connecting to the file, prepare, execute and finalize the query, "&" is necessary to enable function to use pointer
        if sqlite3_prepare_v2(database, "INSERT INTO notes (contents) VALUES ('New note')", -1, &statement, nil) != SQLITE_OK {
            
            print("Could not create query")
            //return -1 so that system knows it couldnt create the note
            return -1
            
        }
        
        //If this action cannot be performed then throw error, but otherwise proceed with it
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Could not insert note")
            return -1
        }
        
        //finalize to the query to clean up after the command so it cannot be called again with other commands next time
        sqlite3_finalize(statement)
        
        //return the id (rowid) of the row that the action was performed on, so that other actions can be immediately performed on it
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    //Function to get all the notes, it returns an array of notes(struct note)
    func getAllNotes() -> [Note] {
        
        //Make sure pointer is set on the right database
        connect()
        
        //Variable to store the result of the query, an empty array that stores items of struct note
        var result: [Note] = []
        
        //create a pointer to a memory cell
        var statement: OpaquePointer!
        
        //Again follow with prepare, execute and finalize but this time get the data by rowid(id) generated automatically by sqlite3
        if sqlite3_prepare_v2(database, "SELECT rowid, contents FROM notes", -1, &statement, nil) != SQLITE_OK {
            print("Error creating select")
            return []
        }
        
        //Earlier we called sqlite3_step once, cause we were creating one cell, but now we have to run this as many times as the cells in data
        while sqlite3_step(statement) == SQLITE_ROW {
            
            //sqlite3_column int is asking for a value at some column that will be an integer, since we are looking for a id column its gonna be column 0, then we want to do the same thing with text thats at column 2, but we want to convert the result to swift string
            result.append(Note(id: Int(sqlite3_column_int(statement, 0)), contents: String(cString: sqlite3_column_text(statement, 1))))
            
        }
        
        sqlite3_finalize(statement)
        return result
        
    }
    
    //function to save notes, with the parameter of the note we want to save
    func save(note: Note) {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "UPDATE notes SET contents = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error creating update statement")
        }
        
        //In order to populate the data in places with "?"(bind the data to the query) use sqlite3_bind_text, its important to remember its a 1-indexed list! (Doesnt start from 0). In third parameter you convert swift string to query string
        sqlite3_bind_text(statement, 1, NSString(string: note.contents).utf8String, -1, nil)
        //bind the other argument with an id
        sqlite3_bind_int(statement, 2, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error running update")
        }
        
        sqlite3_finalize(statement)
        
    }
    
}
