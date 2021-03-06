//
//  ViewController.swift
//  rechord
//
//  Created by Julian Tigler on 11/11/19.
//  Copyright © 2019 High5! Apps. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class MainViewController: UIViewController {
    
    var chordAnalyzer: ChordAnalyzer!
    
    @IBOutlet weak var chordLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startedListeningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavbarImage()
        
        self.chordAnalyzer = ChordAnalyzer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.chordLabel.text = ""
        self.startedListeningLabel.isHidden = true
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.chordAnalyzer.start(chordTypes: getEnabledChordTypes(), onChordChanged: { (chord) in
            DispatchQueue.main.async {
                self.startedListeningLabel.isHidden = true
                self.chordLabel.text = chord.symbol
            }
        })
        
        activityIndicator.stopAnimating()
        startedListeningLabel.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.chordAnalyzer.stop()
    }
    
    private func setNavbarImage() {
        let imageView = UIImageView(image: UIImage(named: "logo-navbar"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private func getEnabledChordTypes() -> [Chord.Type] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let chordTypes = appDelegate.chordTypes
        let defaults = UserDefaults.standard
        
        var enabledChordTypes = [Chord.Type]()
        for chordType in chordTypes {
            if defaults.bool(forKey: chordType.friendlyName) {
                enabledChordTypes.append(chordType)
            }
        }
        
        return enabledChordTypes
    }
}
