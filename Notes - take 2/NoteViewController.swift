//
//  NoteViewController.swift
//  Notes - take 2
//
//  Created by Jakub Łata on 24/11/2022.
//

import UIKit

class NoteViewController: UIViewController {
    
    var note: Note!
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Populate textView with passed note contents
        textView.text = note.contents
    }
    
    //When user exits the view, save the changes
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Make sure that the new written contents overrite the note variable contents
        note.contents = textView.text
        //call singleton class to save the note in the database
        NoteManager.main.save(note: note)
        
    }
}
