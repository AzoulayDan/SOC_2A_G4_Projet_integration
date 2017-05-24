#-*- encoding:utf-8 -*-
from flask import Flask, request
from flask_cors import CORS, cross_origin
import json
from pymongo import MongoClient
import datetime
import time

app = Flask(__name__)
app.debug = True
CORS(app)

#Connection à la base de données
client = MongoClient('mongodb://13.94.243.105:27017')

#Accès à la base de données utilisée
db = client.jeuxOlympiques


'''
Cette route permet la récupération de l'ensemble des données d'une collection
'''
@app.route('/<collection_name>', methods = ['GET'])
def datas_collection(collection_name):
	#Récupération des données de la collection 'collection_name'
	collection = db[collection_name]
	all_documents = collection.find({})

	#Parcours all_documents et récupération des données
	datas = []
	for adocument in all_documents:
		adocument['_id'] = str(adocument['_id'])
		datas.append(adocument)
	return json.dumps(datas), 200, {'Content-Type':'application/json'}


'''
Cette route permet la récupération d'un document dans une collection à partir de son identifiant
'''
@app.route('/<collection_name>/<document_id>', methods = ['GET'])
def get_document(collection_name, document_id):
	collection = db[collection_name]
	all_documents = collection.find({})
    
	#Récupération du document concerné
	data = []
	for adocument in all_documents:
		adocument['_id'] = str(adocument['_id'])
		if (adocument['_id'] == document_id):
			data.append(adocument)

	return json.dumps(data), 200, {'Content-Type':'application/json'}

'''
Cette route permet la récupération de l'ensemble des coordonnées d'un type de lieux
'''
@app.route('/lieu/lieu_type/<type_lieu>', methods = ['GET'])
def datas_type_lieux(type_lieu):
	#Recupération des données de la collection 'collection_name'
	collection = db['lieu']
	all_documents = collection.find({})

	#Parcours all_documents et récupération des données de lieux en fonction du type de lieu
	datas = []
	for adocument in all_documents:
		adocument['_id'] = str(adocument['_id'])
		if (adocument['type'] == type_lieu):
			datas.append(adocument)
	return json.dumps(datas), 200, {'Content-Type':'application/json'}


'''
Cette route permet la récupération des articles à partir d'un type d'articles
'''
@app.route('/article_news/article_type/<type_article>', methods = ['GET'])
def data_type_article_news(type_article):
	#Recupération des données de la collection 'collection_name'
	collection = db['article_news']
	all_documents = collection.find({})

	#Parcours all_documents et récupération des données de lieux
	datas = []
	for adocument in all_documents:
		print(adocument)
		adocument['_id'] = str(adocument['_id'])
		if (adocument['type'] == type_article):
			datas.append(adocument)
	return json.dumps(datas), 200, {'Content-Type':'application/json'}


'''
Cette route permet la récupération des données d'un document de la collection compte si il existe.
Les données à envoyer: {"mail": 'un_mail", "motdepasse":"un_mot_de_passe"}
Test: curl -i -X GET -H "Content-Type:application/json" -H "Accept:application/json" -d '{"mail":"dan.azoulay@imerir.com", "motdepasse":"Azerty02_"}' -i http://localhost:5000/user/account
'''
@app.route('/account/user', methods= ['GET'])
def collect_user_account ():
    client_data = request.get_json()
    print(client_data)
    
    if (("mail" not in client_data) and ("motdepasse" not in client_data)):
        return 'Bad request', 400
        
    if (len(client_data.keys()) > 2):
        return 'Bad request', 400

   	#Récupération de la totalité des documents
    collection = db['compte']
    all_documents = collection.find({})
        
    #Récupération du compte si le compte existe
    mon_compte = []
    for adocument in all_documents:
        value_password = adocument['motdepasse']
        value_email = adocument['mail']

        if (client_data['mail'] == value_email and  client_data['motdepasse'] == value_password):
            adocument['_id'] = str(adocument['_id'])
            mon_compte.append(adocument)
        
    if (len(mon_compte) == 0):
        return "No content", 204
    
    print(mon_compte)
    return json.dumps(mon_compte), 200, {'Content-Type':'application/json'}


'''
Cette route permet d'ajouter un document dans une collection
Donnée à envoyer: un document au format json
Test: curl -i -X POST -H "Content-Type: application/json" -d '{"mail" : "essaie@test.com", "prenom" : "Dan", "nom" : "Azoulay", "motdepasse" : "Azerty04_", "type" : "public", "sport" : [ "athletisme", "ping-pong" ]}' -i http://localhost:5000/brouillon/creation
'''
@app.route('/<collection_name>/creation', methods = ['POST'])
def create_document(collection_name):
	client_data = request.get_json()
	
	if (client_data == None):
		return "Bad request", 400

	#On recupère la  collection
	collection = db[collection_name]

	#On génère la date actuelle et on l'arrange
	now = datetime.datetime.utcnow().replace(microsecond = 0).isoformat()
	nowStr = str(now)
	date_final = nowStr.replace('T', ' ')

	#On l'insère dans ce que l'on doit ajouter
	client_data['date'] = date_final

	#On effectue l'insertion dans la base de données
	result = collection.insert_one(client_data)
	return json.dumps(str(result.inserted_id)), 201, {'Content-Type':'application/json'}

'''
Cette route permet de modifier le champs d'un document se trouvant dans une collection
Données à envoyer : nomCollection, id_document_à_modifier, nom_champs_a_modifier, nouvelle_valeur_champs
Test: curl -i -X PATCH -H "Content-Type: application/json" -d '{"collection" : "brouillon", "id": "5922bd97971a1109fa937699", "field_name" : "sport" , "new_value" : [ "MERDO", "YOLLO" ]}' -i http://localhost:5000/update
'''
@app.route('/update', methods = ['PATCH'])
def to_update_document():
	print(request)
	client_data = request.get_json()
	print(client_data)

	#Récupération des données du client
	client_name_collection = client_data['collection']
	client_document_id = client_data['id']
	client_name_field = client_data['field_name']
	client_new_value_field = client_data['new_value']

	#Récupération des données de la collection
	collection = db[client_name_collection]
	all_documents = collection.find({})

	data_to_edit = []
	for adocument in all_documents:
		print(adocument)
		if (str(adocument['_id']) == client_document_id):
			adocument['_id'] = str(adocument['_id'])
			data_to_edit.append(adocument)

	result = collection.update_one({client_name_field: data_to_edit[0][client_name_field]} , {'$set':{ client_name_field: client_new_value_field }})
	print(result.matched_count)
	print(result.modified_count)
	return ' ' , 204


'''
Cette méthode permet de faire en sorte de récupérer une donnée, si le compte existe, en post
'''
@app.route('/user/account', methods = ['POST'])
def user_account():
	client_data = request.get_json()

	if (("mail" not in client_data) and ("motdepasse" not in client_data)):
		return "Bad request", 400

	if (len(client_data.keys()) > 2):
		return "Bad request", 400

	collection = db['compte']
	all_documents = collection.find({})

	mon_compte = []
	for adocument in all_documents:
		value_password = adocument['motdepasse']
		value_email = adocument['mail']

		if ((client_data['mail'] == value_email) and (client_data['motdepasse'] == value_password)):
			adocument['_id'] = str(adocument['_id'])
			mon_compte.append(adocument)

	if (len(mon_compte) == 0):
		return "No content", 204

	print(mon_compte)
	return json.dumps(mon_compte), 200, {'Content-Type':'application/json'}

'''
Lancement de l'application
'''
if __name__ == '__main__':
	app.run()
