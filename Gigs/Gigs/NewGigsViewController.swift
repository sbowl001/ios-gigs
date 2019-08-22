//
//  NewGigsViewController.swift
//  Gigs
//
//  Created by Stephanie Bowles on 5/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit

class NewGigsViewController: UIViewController {

    
    var gigController: GigController!
    var gig: Gig? {
        didSet{
            updateViews()
        }
    }
    
    
    @IBOutlet weak var jobTitleLabel: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var jobDescriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let dueDate = datePicker.date
        guard let title = jobTitleLabel.text, !title.isEmpty,
            let description = jobDescriptionField.text, !description.isEmpty
            else { return }
        
        gigController.createGig(title: title, description: description, dueDate: dueDate) { (_) in
//            if let error = error {
//                NSLog("Error creating new gig: \(error)")
//            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateViews() {
        
        //           guard let selectedGig = gig,
//        isViewLoaded else {
//            title = "Add New Gig"
//            return
//        }
        if gig != nil {
            guard let gig = gig else { return }
            jobTitleLabel.text = gig.title
            datePicker.date = gig.dueDate
            jobDescriptionField.text = gig.description
            navigationItem.title = gig.title
        } else {
            navigationItem.title = "New Gig"
        }
    }
 
    
}
