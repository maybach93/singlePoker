//
//  StartViewController.swift
//  pokerRoom
//
//  Created by Vitalii Poponov on 20.01.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var playerNameTextField: UITextField!
    
    //MARK: - Constants
    
    struct Constants {
        let createGameControllerSegueIdentifier = String(describing: CreateGameViewController.self)
        let findGameControllerSegueIdentifier = String(describing: FindGameViewController.self)
    }

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func tapRecognizerPressed(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func createGameButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants().createGameControllerSegueIdentifier, sender: nil)
    }

    @IBAction func findGameButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants().findGameControllerSegueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let player = Player()
        player.name = playerNameTextField.text!
        
        switch segue.destination {
        case let createGameVC as CreateGameViewController:
            createGameVC.player = player
        case let findGameVC as FindGameViewController:
            findGameVC.player = player
        default:
            break
        }
    }
}
