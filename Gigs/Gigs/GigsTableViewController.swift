//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Stephanie Bowles on 5/30/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    private var gigs : [String] = []
    
    let gigController = GigController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.gigController.bearer == nil {
            performSegue(withIdentifier: "PresentLogIn", sender: self)
        }  else {
            gigController.getAllGigs { (array) in
                DispatchQueue.main.async {
                    self.gigs = array
                    self.tableView.reloadData()
             }
            }
        }
    }

    // MARK: - Table view data source
 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return gigs.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)

        let df = DateFormatter()
        df.dateStyle = .short
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = df.string(from: gigController.gigs[indexPath.row].dueDate)
        return cell
    }

    /*
     Implement cellForRowAt using the same array of Gigs to get the gig that corresponds to the cell being set up in this method. The cell's text label should show the gig's title. Use a DateFormatter to take the Gig's dueDate property and make it into a more user-friendly readable string and place it in the detail text label of the cell.
     */

 




    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGig" {
            if let gigVC = segue.destination as? NewGigsViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    gigVC.gig = gigController.gigs[indexPath.row]
                }
                gigVC.gigController = gigController
            }
        } else if segue.identifier == "PresentLogIn" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGig" {
            if let gigVC = segue.destination as? NewGigsViewController {
                gigVC.gigController = gigController
            }
        }
    }
 

}
