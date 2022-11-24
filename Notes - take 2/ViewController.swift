//
//  ViewController.swift
//  Notes - take 2
//
//  Created by Jakub Łata on 24/11/2022.
//

import UIKit

class ViewController: UITableViewController {

    //Store notes in an array
    var notes: [Note] = []
    
    @IBAction func createNote() {
        //Using the singleton class that was declared in Note.swift file to create a new note
        let _ = NoteManager.main.create()
        reload()
    }
    
    //Setup the cells in tableview controller, using number of sections, rows and setting up reusable cells
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].contents
        return cell
    }
    
    //Method for reloading the TableView after some action
    func reload() {
        
        //Store in notes updated array of all notes fetched from the database through the singleton class NoteManager command getAllNotes
        notes = NoteManager.main.getAllNotes()
        
        self.tableView.reloadData()
    }
    
}

