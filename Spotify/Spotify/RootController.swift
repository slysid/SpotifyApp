//
//  ViewController.swift
//  Spotify
//
//  Created by Bharath on 15/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import UIKit

class RootController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var seachBox:UITextField?
    @IBOutlet weak var poweredByImage:UIImageView?
    var searchedText:String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.seachBox!.delegate = self
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.poweredByImage!.center = CGPoint(x:self.view.frame.width * 0.5,y:self.view.frame.height * 0.20)
        self.seachBox!.center = CGPoint(x:self.view.frame.width * 0.5,y:self.view.frame.height * 0.40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if searchedText != seachBox!.text {
            
            allAlbums.removeAll()
            allArtists.removeAll()
            allTracks.removeAll()
            searchedText = seachBox!.text!
        }
        
        (segue.destination as! SearchTableController).searchText = seachBox!.text
    }
    
    // UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }


}

