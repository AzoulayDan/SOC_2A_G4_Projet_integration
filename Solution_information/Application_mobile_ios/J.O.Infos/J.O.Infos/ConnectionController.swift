//
//  ViewController.swift
//  J.O.Infos
//
//  Created by joffrey pijoan on 17/05/2017.
//  Copyright © 2017 joffrey pijoan. All rights reserved.
//

import UIKit

class ConnectionController: UIViewController {
    
    let url_request = "http://172.30.1.18:5000/user/account"

    let coredata = ConcetCompte.account_ID().count
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func clickedConnectionButton(_ sender: Any) {
        if ((loginTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!) {
            display_alert_with_one_action(title: "Erreur formulaire", message: "Veuillez remplir le formulaire complet pour vous connecter", titleAction: "Fermer")
        }
        else {
            let email_tf_text = loginTextField.text!
            let password_tf_text = passwordTextField.text!
            print(password_tf_text)
            //On regarde si l'utilisateur existe dans la base de données
            let result_request = RequestManager.do_post_request_account(atUrl: url_request, withData: ["mail":email_tf_text, "motdepasse":password_tf_text])
            print(result_request)
            
            //L'utilisateur n'existe pas dans la base de données
            if (result_request.count == 0) {
                display_alert_with_one_action(title: "Champs incorrects", message: "Email ou mot de passe incorrects", titleAction: "Fermer")
            }
            
            //L'utilisateur existe dans la base de données
            if (result_request.count > 0) {
                //Les informations sur lui sont enregistrés dans une static var
                IdCompte.idCompte = (result_request[0]["_id"] as! NSString) as String
                print(IdCompte.idCompte)

                performSegue(withIdentifier: "segueToMenuInfos", sender: nil)
            }
        }
    }
    
    internal func display_alert_with_one_action (title:String?, message:String?, titleAction:String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alertVC.addAction(done)
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

class IdCompte {
    static var idCompte :String = ""
}

