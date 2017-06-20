//
//  ViewController.swift
//  exiftoolsApp
//
//  Created by Bucha Kanstantsin on 6/20/17.
//  Copyright © 2017 BuchaBros. All rights reserved.
//

import Cocoa
import Foundation


class ViewController: NSViewController {

    @IBOutlet weak var text: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - actions -
    
    @IBAction func run(sender: NSButton) {
        let exiftoolPath = Bundle.main.path(forResource: "exiftoolbin", ofType: "")
        let imagePath = Bundle.main.path(forResource: "cyberpunk", ofType: "jpg")
        
        let arguments = ["-v", imagePath!]
        
        sender.isEnabled = false
        
        let task = Process.init()
        task.launchPath = exiftoolPath!
        task.arguments = arguments
        
        let stdOut = Pipe()
        task.standardOutput = stdOut
        let stdErr = Pipe()
        task.standardError = stdErr

        let handler =  { [weak self] (file: FileHandle!) -> Void in
            let data = file.availableData
            guard let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                else { return}
            DispatchQueue.main.async {
                self?.text.string = output as String
            }
        }

        stdErr.fileHandleForReading.readabilityHandler = handler
        stdOut.fileHandleForReading.readabilityHandler = handler

        task.terminationHandler = { (task: Process?) -> () in
          stdErr.fileHandleForReading.readabilityHandler = nil
          stdOut.fileHandleForReading.readabilityHandler = nil
        }
        
        task.launch()
        task.waitUntilExit()
        
        sender.isEnabled = true
    }

}

