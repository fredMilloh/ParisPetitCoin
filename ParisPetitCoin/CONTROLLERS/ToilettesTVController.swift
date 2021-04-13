//
//  ToilettesTVController.swift
//  ParisPetitCoin
//
//  Created by fred on 06/04/2021.
//

import UIKit

class ToilettesTVController: UITableViewController {
    
    @IBOutlet weak var toilettesTable: UITableView!
    
    var toilettes = [Toilette]()

    override func viewDidLoad() {
        super.viewDidLoad()
        receiveData()
        
        }
        
        func receiveData() {
            let service = Service()
            service.getDataSet { [weak self] (statut, toilettes) in
                guard let self = self else { return }
                if statut {
                    guard let toilettes = toilettes else { return }
                    self.toilettes = toilettes
                    self.toilettesTable.reloadData()
                } else {
                    self.toilettes = []
                }
            }
            
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toilettes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToiletteCell", for: indexPath)
        let toilette = toilettes[indexPath.row].fields
        cell.textLabel?.text = (toilette.adresse ?? "") + " " + (toilette.arrondissement ?? "")
        cell.detailTextLabel?.text = toilette.state ?? ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //cell pour afficher popup info = adresse, status
        /*
        let detailMovie = self.storyboard?.instantiateViewController(identifier: "ToDetail") as! DetailsController
        let movieSelected = movies[indexPath.row]
        detailMovie.movieSelected = movieSelected
        self.navigationController?.pushViewController(detailMovie, animated: true)
 */
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
