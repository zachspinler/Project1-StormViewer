//
//  ViewController.swift
//  Project1-StormViewer
//
//  Created by Zach Spinler on 3/1/20.
//  Copyright © 2020 Zach Spinler. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        loadNSSLImages()
    
    }
    
    func configureNavigationBar() {
        title = " Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    // Added background thread for loading image files
    func loadNSSLImages() {
        DispatchQueue.global(qos: .background).async {
        let fm      = FileManager.default
        let path    = Bundle.main.resourcePath!
        let items   = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                self.pictures.append(item)
                // Sort pictures array by number
                self.pictures.sort()
            }
        }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
    }
}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            // Success. Set it's selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.title = "Picture\(vc.selectedPictureNumber) of \(pictures.count)"
            
        
            // Push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

