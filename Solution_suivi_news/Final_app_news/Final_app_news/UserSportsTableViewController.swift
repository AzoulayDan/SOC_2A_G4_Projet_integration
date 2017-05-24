//
//  UserSportsTableViewController.swift
//  Final_app_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

class UserSportsTableViewController: UITableViewController {
    var mUserSports = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sports suivis"
        self.navigationItem.hidesBackButton = true
        print(self.mUserSports)
        self.customize_nav_bar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mUserSports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "userSportCell"
        tableView.register(UINib(nibName: "UserSportsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserSportsTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.mSportLabel.text = self.mUserSports[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actus_oneSport :String = self.mUserSports[indexPath.row]
        let newsVC = NewsTableViewController(nibName: "NewsTableViewController", bundle: nil, sportsActus: [actus_oneSport])
        self.navigationController?.pushViewController(newsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /* Override de la méthode d'initialisation */
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, favoriteSports:[String]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.mUserSports = favoriteSports
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Méthodes internes */
    internal func customize_nav_bar() {
        self.navigationItem.hidesBackButton = true
        let others = UIBarButtonItem(title: "Autres Sports", style: .done, target: self, action: #selector(onPressedOtherNavBarButton))
        let all_actus = UIBarButtonItem(title: "Toute l'actus", style: .done, target: self, action: #selector(onPresonPressedAllActusNavBarButton))
        self.navigationItem.setLeftBarButton(others, animated: true)
        self.navigationItem.setRightBarButton(all_actus, animated: true)
    }
    
    internal func onPressedOtherNavBarButton() {
        //On retourne les sports au view controller où l'on peut les choisir
        let choiceVC = ChoiceTableViewController(nibName: "ChoiceTableViewController", bundle: nil, data_dictionnary: [String:Any](), sport_selected: self.mUserSports)
        self.navigationController?.pushViewController(choiceVC, animated: true)
    }
    
    internal func onPresonPressedAllActusNavBarButton () {
        let newsVC = NewsTableViewController(nibName: "NewsTableViewController", bundle: nil, sportsActus: [String]())
        self.navigationController?.pushViewController(newsVC, animated: true)
    }
}
