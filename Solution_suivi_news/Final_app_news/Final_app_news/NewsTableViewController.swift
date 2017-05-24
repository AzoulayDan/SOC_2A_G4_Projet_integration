//
//  NewsTableViewController.swift
//  Final_app_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

let url_all_actus = "http://localhost:5000/article_news"
let url_particularly_actus = "http://localhost:5000/article_news/article_type/"

//let url_test = "http://localhost:5000/article_news/article_type/Judo"


class NewsTableViewController: UITableViewController {
    var actusSports = [String]()
    var mHeaders = [String]()
    var mActus = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.actusSports.count == 0) {
            //L'utilisateur veut accéder à l'actualité sportive en général
            self.title = "Actualités sportives"
            
            //On recupère donc l'ensemble des actualités
            let allDatasActus : [[String:Any]] = RequestManager.do_get_request(atUrl: url_all_actus)
            self.mActus = allDatasActus
            self.mHeaders = self.define_headers_tableview(data: allDatasActus)
            
        } else {
            //L'utilisateur veut accéder à l'actualité sur un sport particulier
            self.title = self.actusSports[0]
            let url_request = url_particularly_actus + self.actusSports[0]
            let a_sport_actu : [[String:Any]] = RequestManager.do_get_request(atUrl: url_request)
            self.mActus = a_sport_actu
            self.mHeaders = self.define_headers_tableview(data: a_sport_actu)
            print(self.mActus)
            print(self.mHeaders)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.mHeaders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let articles_header = self.define_article_in_function_header(header: self.mHeaders[section], datas: self.mActus)
        return articles_header.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.mHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "newsCell"
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NewsTableViewCell
        let articles_header = self.define_article_in_function_header(header: self.mHeaders[indexPath.section], datas: self.mActus)
        let hour_articles = self.define_hour_articles_in_function_header(articles: articles_header)
        cell.mHourNews.text = hour_articles[indexPath.row]
        
        //Mise en forme du contenue de l'aricle
        var content = String()
        if (actusSports.count == 0) {
            //L'utilisateur a accès au information générales
            content = self.configurate_text(type: (articles_header[indexPath.row]["type"] as! String), title: (articles_header[indexPath.row]["titre"] as! String), theNew: (articles_header[indexPath.row]["new"] as! String))
        }
        else if (actusSports.count > 0) {
            //L'utilisateur a accès aux informations sur un seul sport
            content = self.configurate_text(type: nil, title: (articles_header[indexPath.row]["titre"] as! String), theNew: (articles_header[indexPath.row
                ]["new"] as! String))
        }
        cell.fill_cell(content: content)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let articles_header = self.define_article_in_function_header(header: self.mHeaders[indexPath.section], datas: self.mActus)
        var content = String()
        if (actusSports.count == 0) {
            //L'utilisateur a accès au information générales
            content = self.configurate_text(type: (articles_header[indexPath.row]["type"] as! String), title: (articles_header[indexPath.row]["titre"] as! String), theNew: (articles_header[indexPath.row]["new"] as! String))
        }
        else if (actusSports.count > 0) {
            //L'utilisateur a accès aux informations sur un seul sport
            content = self.configurate_text(type: nil, title: (articles_header[indexPath.row]["titre"] as! String), theNew: (articles_header[indexPath.row
                ]["new"] as! String))
        }
        return self.resize_cell_following_his_content(content: content)
        
    }
    
    /* Override de la méthode d'initialisation */
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, sportsActus:[String]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.actusSports = sportsActus
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /* Méthodes internes */
    /* Cette méthode permet de trier les éléments de la donnée du plus recent au plus ancien */
    internal func sorted_datas_element_by_chronologic_order (data:[[String:Any]]) -> [[String:Any]] {
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor.init(key: "date", ascending: false)
        let sort_data : NSArray = ((data as NSArray).sortedArray(using: [sortDescriptor]) as NSArray)
        let final_sort_data : [[String:Any]] = sort_data as! [[String:Any]]
        return final_sort_data
    }
    
    /*Conversion d'un String en Date*/
    func convert_date_to_string (date:Date, withYMD:Bool, withTime:Bool)  -> String {
        let format = DateFormatter()
        format.locale = Locale.init(identifier: "fr_FR")
        
        if ((withTime == true && withYMD == true) || (withYMD == false && withYMD == false)) {
            format.dateFormat = "dd MMMM yyyy h:mm"
        }
        
        if (withTime == true && withYMD == false) {
            format.dateFormat = "hh:mm"
        }
        if (withTime == false && withYMD == true) {
            format.dateFormat = "dd MMMM yyyy"
        }
        let date_to_string = format.string(from: date)
        return date_to_string
    }
    
    /*Conversion d'un Date en String*/
    func convert_string_to_date (string:String) -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let s = format.date(from: string)
        return s!
    }
    
    /*Définition des headers de tableview en fonction de la donnée recue */
    internal func define_headers_tableview (data:[[String:Any]]) -> [String] {
        let datas_sorted = sorted_datas_element_by_chronologic_order(data: data)
        var headers = [String]()
        for aStringDate in datas_sorted {
            //On extrait l'élément header de la chaine
            let date: Date = self.convert_string_to_date(string: aStringDate["date"] as! String)
            let an_header_element : String = self.convert_date_to_string(date: date, withYMD: true, withTime: false)
            
            //On regarde si l'élément est déjà présent dans le tableau de headers
            let present = self.isInHeadersTab(tab: headers, theElement: an_header_element)
            
            if (present == false) {
                headers.append(an_header_element)
            }
        }
        return headers
    }
    
    /* Retourne true si dedans et false sinon */
    internal func isInHeadersTab (tab:[String], theElement:String) -> Bool {
        var inTab = false
        
        for element in tab {
            if ((element as NSString).isEqual(to: theElement) == true) {
                inTab = true
            }
        }
        return inTab
    }
    
    /*Définition des articles correspondants au headers*/
    internal func define_article_in_function_header (header:String, datas:[[String:Any]]) -> [[String:Any]] {
        var articles = [[String:Any]]()
        for anArticle in datas {
            let date_article_date : Date = self.convert_string_to_date(string: anArticle["date"] as! String)
            let a_date_str_article : String = self.convert_date_to_string(date: date_article_date, withYMD: true, withTime: false)
            
            if ((a_date_str_article as NSString).isEqual(to: header) == true) {
                articles.append(anArticle)
            }
        }
        return articles
    }
    
    /*Définition du label heure des cellules */
    internal func define_hour_articles_in_function_header (articles:[[String:Any]]) -> [String] {
        var hour_articles = [String]()
        for aArticle in articles {
            let date_article_date : Date = self.convert_string_to_date(string: aArticle["date"] as! String)
            let an_hour_article : String = self.convert_date_to_string(date: date_article_date, withYMD: false, withTime: true)
            hour_articles.append(an_hour_article)
        }
        return hour_articles
    }

    /* Mise en forme du texte avant l'affichage du news */
    internal func configurate_text (type:String?, title:String?, theNew:String?)  -> String {
        var final_string = String()
        if (type != nil){
            final_string.append(type!)
            final_string.append("  ")
        }
        if (title != nil) {
            final_string.append(title!)
            final_string.append("  ")
        }
        
        if (theNew != nil) {
            final_string.append("\n")
            final_string.append(theNew!)
        }
        return final_string
    }
    
    /* Resize de la cellule d'une tableview en fonction de son contenue */
    internal func resize_cell_following_his_content (content:String) -> CGFloat {
        let cell = NewsTableViewCell()
        let font: UIFont = UIFont.systemFont(ofSize: 17.0)
        let attributes = [NSFontAttributeName: font]
        let text_cell = content
        let content_width_cell = (text_cell as NSString).size(attributes: attributes)
        
        if (content_width_cell.width > cell.frame.width) {
            //258 = width label principal dans la cellule
            let new_height = (content_width_cell.width) * (content_width_cell.height / 258)
            return new_height + 15 //pour garder les marges
        }
        return 60.0 //taille d'une cellule de tableview par défaut
    }
}
