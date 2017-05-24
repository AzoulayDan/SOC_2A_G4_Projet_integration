//
//  ChoiceTableViewController.swift
//  Final_app_news
//
//  Created by Dan Azoulay on 24/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

//let url_creation = "http://localhost:5000/brouillon/creation"
let url_creation = "http://localhost:5000/compte/creation"
let url_update = "http://localhost:5000/update"

class ChoiceTableViewController: UITableViewController {
    
    @IBOutlet var mTableview: UITableView!
    var mSportSelected = [String]() //Contient l'ensemble des sports sélectionnés
    var mUserDatas = [String:Any]() //Contient l'ensemble des informations sur l'utilisateur
    var mSelected_sports_indexpath = [IndexPath]()
    
    let mSports = ["Athetisme", "Badminton", "Basketball", "Boxe", "Cyclisme sur route", "Equestre", "Escrime", "Football", "Gymnastique", "Halterophilie", "Handball", "Judo", "Natation", "Rugby", "Taekwondo", "Tennis de table", "Tennis", "Tir à l'arc","Tir", "VolleyBall", "Waterpolo"]
    
    let message_header:String = "Suivez l'actualité des sports sélectionnés"
    var mtous : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choix sports"
        self.initialize_navBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.mSports.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.message_header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "choiceCell"
        tableView.register(UINib(nibName: "ChoiceTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChoiceTableViewCell
        cell.mSportLabel.text = self.mSports[indexPath.row]
        
        //Si aucun sport n'a été sélectionné
        if (self.mSportSelected.count == 0) {
            //Si l'utilisateur appuie sur tout, tout se sélectionne
            if (self.mtous == true) {
                cell.mSelectedImage.image = UIImage(named: "selectedGreen.png")
                self.mSelected_sports_indexpath.append(indexPath)
            }
            //L'utilisateur n'a pas appuyé sur tout
            else {
                //Si il y a des choses de sélectionné déjà
                if (self.mSelected_sports_indexpath.count > 0) {
                    if (self.isInArray(indexPath: indexPath, array: self.mSelected_sports_indexpath) == true) {
                        cell.mSelectedImage.image = UIImage(named: "selectedGreen.png")
                    }
                    else {
                        let checkbox_img = UIImage(named: "selectedWhite.png")
                        cell.mSelectedImage.image = checkbox_img
                    }
                }
                
                //Si l'utilisateur n'a encore rien sélectionné
                if (self.mSelected_sports_indexpath.count == 0) {
                    let checkbox_img = UIImage(named: "selectedWhite.png")
                    cell.mSelectedImage.image = checkbox_img
                }
            }
        }
            
        //Si des sports sont déjà sélectionnés à l'initialisation de la vue
        else  {
            //On parcours l'ensemble des éléments du tableau et on fait en sorte d'afficher en vers les éléments sélectionnés auparavant
            for string in self.mSportSelected {
                if ((string as NSString).isEqual(to: self.mSports[indexPath.row]) == true ) {
                    self.mSelected_sports_indexpath.append(indexPath)
                    let index = self.mSportSelected.index(of: string)
                    self.mSportSelected.remove(at: index!)
                    cell.mSelectedImage.image = UIImage(named: "selectedGreen.png")
                }
                else {
                    let checkbox_img = UIImage(named: "selectedWhite.png")
                    cell.mSelectedImage.image = checkbox_img
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChoiceTableViewCell
        
        let image_cell = cell.mSelectedImage.image
        let image_white = UIImage(named:"selectedWhite.png")
        let image_green = UIImage(named:"selectedGreen.png")
        
        //Selection d'une cellule
        if (image_cell?.isEqual(image_white) == true) {
            cell.mSelectedImage.image = image_green
            self.mSelected_sports_indexpath.append(indexPath)
        }

        //Ensuite, désélection d'une cellule
        else {
            //Donc supprésion de l'indexPath de la cellule en question
            cell.mSelectedImage.image = image_white
            let index_element_to_remmove:Int = self.mSelected_sports_indexpath.index(of: indexPath)!
            self.mSelected_sports_indexpath.remove(at: index_element_to_remmove)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /* Override de la méthode d'initialisation */
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, data_dictionnary:[String:Any], sport_selected:[String]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.mUserDatas = data_dictionnary
        self.mSportSelected = sport_selected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func onPressedAllSelectedNavBarButton () {
        if (self.mtous == true){
            self.mtous = false
        } else {
            self.mtous = true
        }
        self.mSelected_sports_indexpath.removeAll()
        self.mTableview.reloadData()
    }
    
    /* Les méthdoes internes */
    internal func initialize_navBar () -> Void {
        self.navigationItem.hidesBackButton = true
        let next = UIBarButtonItem(title: "Terminer", style: .done, target: self, action: #selector(onPressedFinishedRegisterNavBarButton))
        let select_all = UIBarButtonItem(title: "Tous", style: .done, target: self, action: #selector(onPressedAllSelectedNavBarButton))
        self.navigationItem.setLeftBarButton(select_all, animated: true)
        self.navigationItem.setRightBarButton(next, animated: true)
    }
    
    //Return true si l'index est dans array, et false sinon.
    internal func isInArray (indexPath:IndexPath, array:[IndexPath]) -> Bool {
        var isInTab = false
        for index in array {
            if (indexPath == index) {
                isInTab = true
            }
        }
        return isInTab
    }
    
    //Retourne un tableau contenant l'ensemble des sports sélectionées à partir du tbaleau des indexpaths des sports selectionnés
    internal func get_string_sports_selected (sport_selected_indexPath: [IndexPath]) -> [String] {
        var sports_selected = [String]()
        for anIndexPath in sport_selected_indexPath {
            sports_selected.append(self.mSports[anIndexPath.row])
        }
        return sports_selected
    }
    
    internal func display_alert_with_one_action (title:String?, message:String?, titleAction:String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alertVC.addAction(done)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    internal func onPressedFinishedRegisterNavBarButton () {
        //Acuun sport n'a été sélectionné par l'utilisateur
        if (self.mSelected_sports_indexpath.count == 0) {
            self.display_alert_with_one_action(title: "Pas de sports sélectionné", message: "Indiquez les sports que vous désirez suivre", titleAction: "Fermer")
        }
        
        let chosing_sport : [String] = self.get_string_sports_selected(sport_selected_indexPath: self.mSelected_sports_indexpath)
        print(chosing_sport)
        
        //Des sports ont été sélectionés
        print("muserdata")
        print(mUserDatas)
        if (self.mSelected_sports_indexpath.count > 0) {
            if (self.mUserDatas.count >= 0) {
                print("cela rentre ici")
                //On formate le document à passer
                var document = self.mUserDatas
                //Ajout dans le document des champs manquants
                document["montant"] = "0"
                document["sport"] = chosing_sport
                document[" type"] = "putblic"
                
                //On effectue la requête sur la base de données afin de mettre à jour les collection; et ainsi créer le user.
                let request = RequestManager.do_post_request_creation(atUrl: url_creation, withData: document)
                print(request)
                id_compte = request
            }
            else {
                print("cela rentre la dans le patch ")
                //On met en forme le document pour faire un update de la base de données
                let update_query = ["collection":"brouillon", "id":id_compte, "field_name":"sport", "new_value":chosing_sport] as [String : Any]
                RequestManager.do_patch_request(atUrl: (url_update), withData: update_query)
                
            }
            
            let userSportsVC = UserSportsTableViewController(nibName: "UserSportsTableViewController", bundle: nil, favoriteSports: chosing_sport)
            self.navigationController?.pushViewController(userSportsVC, animated: true)
        }
    }

}
