//
//  PALogin.swift
//  Music
//
//  Created by Dmitriy Groschovskiy on 4/28/18.
//  Copyright © 2018 Google, Inc. All rights reserved.
//

import UIKit
import Firebase

class PALogin: UIViewController, UIAlertViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.username.delegate=self
        self.password.delegate=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    @IBAction func authWithCredentials(sender: UIButton) {
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            if error != nil {
                self.showNotificationMessage(messageText: "Credentials for authorization is invalid. Please check the information you entered and try again.")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func restoreAccountCredentials() {
        if (self.username.text == nil) {
            showNotificationMessage(messageText: "Please enter your username in text field at top and press recovery button again. Thank you!")
        } else {
            showNotificationMessage(messageText: "We send message with recovery steps to your email address. Please check your inbox and try login with new password. Thank you!")
        }
    }

    func showNotificationMessage(messageText: String) {
        let alertController = UIAlertController(title: "Pear Music Connect", message: messageText, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(closeAction)
        self.present(alertController, animated: true) { print("Debug: Message successful sended!") }
    }

}
