//
//  ViewController.swift
//  Notes - take 2
//
//  Created by Jakub Łata on 24/11/2022.
//

import UIKit

class ViewController: UITableViewController {

    //Store notes in an array
    let notes: [Note] = []

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
    
}

