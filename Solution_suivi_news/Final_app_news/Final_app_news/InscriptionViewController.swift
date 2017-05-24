//
//  InscriptionViewController.swift
//  Final_app_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

class InscriptionViewController: UIViewController {
    @IBOutlet weak var mTextFieldName: UITextField!
    @IBOutlet weak var mTextFieldLastName: UITextField!
    @IBOutlet weak var mTextFieldMail: UITextField!
    @IBOutlet weak var mTextFieldPassword: UITextField!
    @IBOutlet weak var mTextFieldVerifPassword: UITextField!

    let name_placeholder = "Nom"
    let lastname_placeholder = "Prénom"
    let mail_placeholder = "Mail : exmaple@example.com"
    let password_placeholer = "Mot de passe"
    let  verifPassword_placeholder = "Confirmation du mot de passe"
    var mIncorrect_verif : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Inscription"
        self.customize_nav_bar()
        self.initialize_textfields_view()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* Méthodes internes */
    /* Customisation de la navigation bar */
    internal func customize_nav_bar () {
        self.navigationItem.hidesBackButton = true
        let cancel = UIBarButtonItem(title: "Annuler", style: .done, target: self, action: #selector(onPressedPreviousNavBarButton))
        let next = UIBarButtonItem(title: "Suivant", style: .done, target: self, action: #selector(onPressedNextNavBarButton))
        self.navigationItem.setLeftBarButton(cancel, animated: true)
        self.navigationItem.setRightBarButton(next, animated: true)
    }
    
    /*
     Cette méthode permet de vérifier si les champs sont rmeplis correctement
     Retourne "true" si c'est correctement remplie, false sinon
     */
    internal func is_fiels_correctly_filled () -> Bool {
        //Sont-ils tous rempli?
        let all_filled : Bool = TextFieldManager.isEmpty_textfields(textfields: [self.mTextFieldName, self.mTextFieldLastName, self.mTextFieldMail, self.mTextFieldPassword, self.mTextFieldVerifPassword])
        
        //Non
        if (all_filled == true) {
            self.display_alert_with_one_action(title: "Champs vides", message: "Veuillez remplir tous les champs pour continuer l'inscription", titleAction: "Fermer")
            return false
        }
        
        //Oui
        if (all_filled == false) {
            //L'adresse mail est-elle valide?
            let valide_email_adress = TextFieldManager.isValide_email(textfield: self.mTextFieldMail)
            
            //Non
            if (valide_email_adress == false) {
                self.display_alert_with_one_action(title: "Email invalide", message: "Adresse email invalide", titleAction: "Fermer")
                return false
            }
            
            //Oui
            if (valide_email_adress == true) {
                //Les mots de passe sont-ils identiques?
                //Non
                if ((self.mTextFieldPassword.text! as NSString).isEqual(to: self.mTextFieldVerifPassword.text!) == false) {
                    self.display_alert_with_one_action(title: "Confirmation incorrecte", message: "Les mots de passe saisis ne sont pas les identiques", titleAction: "Fermer")
                    self.mIncorrect_verif = true
                    return false
                }
            }
        }
        return true
    }
    
    /* Cette méthode affiche des alertes personnalisées */
    internal func display_alert_with_one_action (title:String?, message:String?, titleAction:String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alertVC.addAction(done)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /*Cette méthode permet d'initiliaser les placeholder des champs de texte de la vue */
    internal func initialize_textfields_view () {
        self.mTextFieldMail.placeholder = mail_placeholder
        self.mTextFieldLastName.placeholder = lastname_placeholder
        self.mTextFieldName.placeholder = name_placeholder
        self.mTextFieldPassword.placeholder = password_placeholer
        self.mTextFieldVerifPassword.placeholder = verifPassword_placeholder
        self.mTextFieldPassword.isSecureTextEntry = true
        self.mTextFieldVerifPassword.isSecureTextEntry = true
    }
    
    /* Cette méthode permet de remettre à zéro l'ensmeble des champs de texte de la vue */
    internal func reset_all_textfields () {
        TextFieldManager.reset_textfields(textfields: [self.mTextFieldName , self.mTextFieldLastName, self.mTextFieldMail,self.mTextFieldPassword, self.mTextFieldVerifPassword])
        self.initialize_textfields_view()
    }
    
    /* Implementaiton du delegate */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (TextFieldManager.isEmpty_textfield(textfield: textField) == true) {
            textField.placeholder = ""
        }
        return true
    }
    
    /* Les actions sur les boutons */
    internal func onPressedPreviousNavBarButton () {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    internal func onPressedNextNavBarButton () {
        //Le champs sont-ils correctement remplis?
        let correctly_filled_textfields = is_fiels_correctly_filled()
        
        //Oui
        if (correctly_filled_textfields == true) {
            //On stocke dans un dictionnaire l'ensemble des données renseignées par l'utilisateur. Et on le passe à la vue suivante.
            let name : String = self.mTextFieldName.text!
            let lastname : String = self.mTextFieldLastName.text!
            let mail : String = self.mTextFieldMail.text!
            let password :String = self.mTextFieldPassword.text!
            
            let dictionnary_user_datas = ["nom":name, "prenom":lastname, "mail":mail, "password":password]
            print(dictionnary_user_datas)
            let choiceVC = ChoiceTableViewController(nibName: "ChoiceTableViewController", bundle: nil, data_dictionnary: dictionnary_user_datas, sport_selected: [String]())
            self.navigationController?.pushViewController(choiceVC, animated: true)
        }
        
        //Non
        if (correctly_filled_textfields == false) {
            if (self.mIncorrect_verif == true) {
                TextFieldManager.reset_textfields(textfields: [self.mTextFieldPassword, self.mTextFieldVerifPassword])
                self.mTextFieldPassword.placeholder = password_placeholer
                self.mTextFieldVerifPassword.placeholder = verifPassword_placeholder
            }
            else {
                self.reset_all_textfields()
            }
        }
    }
    
    @IBAction func onPressedButtonFieldReset(_ sender: UIButton) {
        self.reset_all_textfields()
    }
    
    
}
