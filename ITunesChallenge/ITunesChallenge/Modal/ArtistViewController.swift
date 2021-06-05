//
//  ArtistViewController.swift
//  ITunesChallenge
//
//  Created by Imo on 05/06/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ArtistViewController: UIViewController {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    var data:JSON?
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        closeImage.isUserInteractionEnabled = true
        closeImage.addGestureRecognizer(tap)
        
        albumImage.sd_setImage(with: URL(string: data?["artworkUrl100"].string ?? ""), placeholderImage: UIImage(named: "itunes.jpg"))
        
        artistLabel.text = data?["artistName"].string
        albumLabel.text = data?["collectionName"].string
        releaseDate.text = data?["releaseDate"].string
        
        if let ntracks = data?["trackCount"].int {
            trackLabel.text = "Tracks: \(ntracks)"
        }
        
        if let price = data?["collectionPrice"].double {
            priceLabel.text = String(format: "$ %.2f", price)
        }
    }
    
    @objc func tapAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openBrowserAction(_ sender: Any) {
        if let url = URL(string: data?["artistViewUrl"].string ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
