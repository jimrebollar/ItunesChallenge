//
//  ViewController.swift
//  ITunesChallenge
//
//  Created by Imo on 05/06/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MainController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data:JSON = JSON()
    var filteredData: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        filteredData = data
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

extension MainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! RowViewCell
        cell.exampleLabel?.text = filteredData[indexPath.row]["artistName"].string
        cell.albumLabel?.text = filteredData[indexPath.row]["collectionName"].string
        cell.albumImage.sd_setImage(with: URL(string:filteredData[indexPath.row]["artworkUrl100"].string ?? ""), placeholderImage: UIImage(named: "itunes.jpg"))
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(named: "backCellColor")
        }else{
            cell.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let modal = storyboard?.instantiateViewController(identifier: "ArtistViewController") as? ArtistViewController {
            modal.data = filteredData[indexPath.row]
            present( modal, animated: true, completion: nil)
        }
    }
}

extension MainController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            data = JSON()
            filteredData = data
            tableView.reloadData()
            return
        }
        
        Network.itunesServiceSearch(searchTerm: searchText) { json, erorMessage in
            self.data = json["results"]
            self.filteredData = self.data
            self.tableView.reloadData()
        }
    }
}
