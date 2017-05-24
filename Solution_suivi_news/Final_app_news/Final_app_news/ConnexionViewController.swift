//
//  ConnexionViewController.swift
//  Final_app_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

var id_compte:String  = String()
let url_connexion = "http://localhost:5000/user/account"

class ConnexionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mMailTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    
    let textfield_placeholder_mail = "email: exemple@gmail.com"
    let textfield_placeholder_password = "mot de passe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Connexion"
        //self.mMailTextField.text = "dan.azoulay@imerir.com"
        //self.mPasswordTextField.text = "Azerty02_"
        self.initialize_textfields_view()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* Les actions sur les boutons */
    @IBAction func onPressedButtonRegister(_ sender: UIButton) {
        let inscriptionVC = InscriptionViewController(nibName: "InscriptionViewController", bundle: nil)
        self.navigationController?.pushViewController(inscriptionVC, animated: true)
    }
    
    @IBAction func onPressedButtonLogin(_ sender: UIButton) {
        //On verifie que les champs sont correctement remplis
        let correctly_filled : Bool = check_correctly_filled()
        
        //Les champs sont correctement remplis
        if (correctly_filled == true) {
            
            //On vérifie l'existence de l'utilisateur dans la base de données MongoDB
            let email = self.mMailTextField.text!
            let password = self.mPasswordTextField.text!
            
            let request = RequestManager.do_post_request_account(atUrl: url_connexion, withData: ["mail":email, "motdepasse":password])
            print(request)
            
            //Deux solutions 
                //L'utilisateur existe dans la base de données
            if (request.count == 1) {
                print("Il faut afficher le controler suivant, avec l'ensemble des sports du compte")
                //On récupère les sports favoris de l'utilisateur
                let favoriteSports : [String] = request[0]["sport"] as! [String]
                print(favoriteSports)
                id_compte = request[0]["_id"] as! String
                
                //On le connecte à l'application
                let UserSportsVC = UserSportsTableViewController(nibName: "UserSportsTableViewController", bundle: nil, favoriteSports: favoriteSports)
                self.navigationController?.pushViewController(UserSportsVC, animated: true)
            }
            
                //L'utilisateur n'existe pas dans la base de données
            else if (request.count == 0) {
                print("L'utilisateur n'existe pas dans la base de données")
                display_alert_with_one_action(title: "Echec de l'authentification", message: "Email ou mot de passe incorrect", titleAction: "Fermer")
            }
        }
        self.reset_textfields_view()
    }
    
    /* 
     Permet de vérifier si les champs de texte sont correctement remplis
     Retourne "true" si correctement remplis, false sinon
     */
    internal func check_correctly_filled () -> Bool {
        let all_textfield_empty = TextFieldManager.isEmpty_textfields(textfields: [self.mMailTextField, self.mPasswordTextField])
        
        //Un ou plusieurs textfiels sont vides
        if (all_textfield_empty == true) {
            self.display_alert_with_one_action(title: "Champs incomplets", message: "Veuillez remplir tous les champs", titleAction: "Fermer")
            return false
        }
        
        //Les textfiels sont remplis
        if (all_textfield_empty == false) {
            let mail_valide = TextFieldManager.isValide_email(textfield: self.mMailTextField)
            
            //Si le mail n'est pas valide alors on retourne false
            if (mail_valide == false) {
                self.display_alert_with_one_action(title: "Email invalide", message: "L'adresse mail saisie n'est pas valide", titleAction: "Fermer")
                return false
            }
        }
        return true
    }
    
    internal func display_alert_with_one_action (title:String?, message:String?, titleAction:String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alertVC.addAction(done)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    internal func initialize_textfields_view () {
        self.mMailTextField.placeholder = textfield_placeholder_mail
        self.mPasswordTextField.placeholder = textfield_placeholder_password
        self.mPasswordTextField.isSecureTextEntry = true
    }
    
    internal func reset_textfields_view () {
        TextFieldManager.reset_textfields(textfields: [self.mMailTextField, self.mPasswordTextField])
        self.initialize_textfields_view()
    }
    
    /*Implementation des delegate*/
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (TextFieldManager.isEmpty_textfield(textfield: textField) == true) {
            textField.placeholder = ""
        }
        return true
    }
    
}
