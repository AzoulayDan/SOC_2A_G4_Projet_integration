#-*- encoding:utf-8 -*-
import json
from pymongo import MongoClient
import datetime
import time
from random import *
import os, urlparse
import paho.mqtt.client as mqtt


#Connection à la base de données
client = MongoClient('mongodb://13.94.243.105:27017')
#Accès à la base de données utilisée
db = client.jeuxOlympiques

#Définition des callback
#Cette fonction permet de se connecter au broker
def connect(client, obj, rc):
	#Connexion au broker mqtt
	print ""

#Cette fonction va envoyer au brocker des informations concernant le topic
def publish(client, obj, rc):
	#Envoie d'un message sur le brocker
	print ""
	#print (str(obj))

#Simule la fréquentation pour un site
def frequentation_site (time = 3):
	now = datetime.datetime.utcnow().replace(microsecond=0).isoformat()
	nowStr = str(now)
	date_final = nowStr.replace('T', ' ')

	freq_site1 = {}
	freq_site1['site'] = 'Stade de France'
	freq_site1['value'] = randrange(1000, 3000, 2)
	freq_site1['date'] = date_final

	freq_site2 = {}
	freq_site2['site'] = 'Parc des Princes'
	freq_site2['value'] = randrange(1000, 3000, 2)
	freq_site2['date'] = date_final

	freq_site3 = {}
	freq_site3['site'] = 'Paris Expo Portes de Versaille'
	freq_site3['value'] = randrange(1000, 3000, 2)
	freq_site3['date'] = date_final

	liste_lieux_freq = [freq_site1, freq_site2, freq_site3]
	final_document = choice(liste_lieux_freq)
	print(final_document)
	return freq_site1

#Simule le volume des echanges
def volume_achat_sur_parc (time = 3):
	now = datetime.datetime.utcnow().replace(microsecond=0).isoformat()
	nowStr = str(now)
	date_final = nowStr.replace('T', ' ')

	adocument = {}
	adocument['volume_echange'] = 'volume echange en euro'
	adocument['value'] = randrange(1000, 3000, 2)
	adocument['date'] = date_final
	return adocument

#Simule les news
def news_simulation (time = 3):
	now = datetime.datetime.utcnow().replace(microsecond=0).isoformat()
	nowStr = str(now)
	date_final = nowStr.replace('T', ' ')
	liste_type_info = ['General', 'Judo', 'Boxe']
	liste_delegation = ['France', 'Anleterre', 'Belgique']
	liste_titre = ['Combat', 'Finale']
	lsit_athlete = ['Phelps', 'Rinner', 'Babar']
	liste_news = ['Meteo actuelle très maussade', 'Teddy Riner pret a en decoudre', 'Entree des participants sur le ring']

	new_document = {}
	new_document['athlete'] = choice(lsit_athlete)
	new_document['titre'] = choice(liste_titre)
	new_document['date'] = date_final
	new_document['new'] = choice(liste_news)
	new_document['type'] = choice(liste_type_info)
	return new_document

#Publisher publiant les données
def publisher():
	client = mqtt.Client()
	client.on_connect = connect
	client.on_publish = publish

	url_str = os.environ.get('CLOUDMQTT_URL', 'mqtt://hrrgcrqx:af3wqGskmMfY@m20.cloudmqtt.com:12771')
	url = urlparse.urlparse(url_str)

	client.username_pw_set(url.username, url.password)	
	client.connect(url.hostname, url.port)

	#Envoie des messages
	rc = 0
	collection_freq = db.brouillonFrequentation	#On accède à la collection fréquentation brouillon
	collection_article = db.article_news #On accède à la collection de l'article news
	while rc == 0:
		document_frequentation = frequentation_site()
		collection_freq.insert_one(document_frequentation)	#On ajoute la données simulée de fréquentation dans la base de données
		client.publish("/jo/frequentation", str(document_frequentation))
		print (document_frequentation)

		document_new = news_simulation()
		#collection_article.insert_one(document_new)  #On ajoute les news simulées dans la table des news
		client.publish("/jo/news", str(document_new))
		print(document_new)

		document_echange = volume_achat_sur_parc()
		client.publish("/jo/echange", str(document_echange))
		print(document_echange)

		time.sleep(1)
		rc = client.loop()

publisher()
