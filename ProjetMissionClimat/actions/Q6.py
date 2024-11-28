import tkinter as tk
from utils import display
from tkinter import ttk
from utils import db
from datetime import datetime
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

class Window(tk.Toplevel):
    def __init__(self, parent):
        super().__init__(parent)

        """
                "On souhaite tracer un graphique pour comparer les températures des départements de la zone "
                "climatique H1 en 2018 avec les records de températures historiques enregistrés dans notre base "
                "de données pour l’ensemble du pays, pour chaque jour de l’année.\n\n"
                "Pour l’ensemble de cet exercice, seules les données de la colonne temperature_moy_mesure de "
                "la table Mesures seront prises en compte.\n\n"
                "On souhaite afficher ces données sur le même graphique, avec les 4 courbes suivantes :\n"
                "    - Les records de fraîcheur historiques pour chaque jour de l’année (toutes années confondues, toutes zones climatiques confondues).\n"
                "    - Les records de chaleur historiques pour chaque jour de l’année (toutes années confondues, toutes zones climatiques confondues).\n"
                "    - Les températures du département le plus froid de la zone H1 pour chaque jour de l’année 2018.\n"
                "    - Les températures du département le plus chaud de la zone H1 pour chaque jour de l’année 2018.\n\n"
                "Les départements les plus froids et les plus chauds de la zone H1 sont ceux pour lesquels la "
                "moyenne de leurs températures sur l’année 2018 est respectivement la plus basse et la plus élevée.\n\n"
                "Pour tracer le graphique, basez-vous sur le code fourni en exemple dans F4. Attention, seule la "
                "requête SQL doit être modifiée dans le code que vous reprendrez de F4. Vous ne devez pas modifier "
                "le code de génération du graphique.\n\n"
                "Indication : travaillez indépendamment sur chaque courbe demandée. Le plus difficile sera de rassembler "
                "les données nécessaires pour tracer les 4 courbes dans une même requête."
        """
        # Définition de la taille de la fenêtre, du titre et des lignes/colonnes de l'affichage grid
        display.centerWindow(1500, 800, self)
        self.title('F4 : températures en Isère en 2018')
        display.defineGridDisplay(self, 1, 1)
        #granularité en jours
        query ="""
            WITH Rec_toute_annee AS( 
                SELECT date_mesure, min(temperature_moy_mesure) AS temp_min, max(temperature_moy_mesure) AS temp_max
                FROM Mesures
                GROUP BY date_mesure HAVING strftime('%m %d', date_mesure)
            ),
            Dep_rec_max_2018 AS(
                SELECT code_departement,max(temperature_moy_mesure) AS temp_max
                FROM Mesures JOIN Departements USING (code_departement)
                WHERE strftime('%Y', date_mesure) = '2018' AND zone_climatique='H1'
                GROUP BY code_departement
                ORDER BY temp_max DESC
                LIMIT 1
            ),
            Dep_rec_min_2018 AS(
                SELECT code_departement,min(temperature_moy_mesure) AS temp_min
                FROM Mesures JOIN Departements USING (code_departement)
                WHERE strftime('%Y', date_mesure) = '2018' AND zone_climatique='H1'
                GROUP BY code_departement
                ORDER BY temp_min ASC
                LIMIT 1
            )
            SELECT R.date_mesure, temp_min, temp_max, temperature_moy_mesure AS dep_min, 0
            FROM Rec_toute_annee R JOIN Mesures M ON (M.date_mesure=R.date_mesure)
            WHERE strftime('%Y', R.date_mesure) = '2018' AND dep_min IN Dep_rec_min_2018
                
        """
        """
            temperature_min_H1_2018, temperature_max_H1_2018
            strftime('%Y', date_mesure) = '2018'
        """
        # Extraction des données et affichage dans le tableau
        result = []
        try:
            cursor = db.data.cursor()
            result = cursor.execute(query)
        except Exception as e:
            print("Erreur : " + repr(e))

        # Extraction et préparation des valeurs à mettre sur le graphique
        graph1 = []
        graph2 = []
        graph3 = []
        graph4 = []
        tabx = []
        for row in result:
            tabx.append(row[0])
            graph1.append(row[1])
            graph2.append(row[2])
            graph3.append(row[3])
            graph4.append(row[4])

        # Formatage des dates pour l'affichage sur l'axe x
        datetime_dates = [datetime.strptime(date, '%Y-%m-%d') for date in tabx]

        # Ajout de la figure et du subplot qui contiendront le graphique
        fig = Figure(figsize=(15, 8), dpi=100)
        plot1 = fig.add_subplot(111)

        # Affichage des courbes
        plot1.plot(range(len(datetime_dates)), graph1, color='#00FFFF', label='Records de fraîcheur historiques sur 1 an')
        plot1.plot(range(len(datetime_dates)), graph2, color='#FF8300', label='Records de chaleur historiques sur 1 an')
        plot1.plot(range(len(datetime_dates)), graph3, color='#0000FF', label='Les températures du département le plus froid de la zone H1 pour chaque jour de l’année 2018')
        plot1.plot(range(len(datetime_dates)), graph4, color='#FF0000', label='Les températures du département le plus chaud de la zone H1 pour chaque jour de l’année 2018')

        # Configuration de l'axe x pour n'afficher que le premier jour de chaque mois
        xticks = [i for i, date in enumerate(datetime_dates) if date.day == 1]
        xticklabels = [date.strftime('%Y-%m-%d') for date in datetime_dates if date.day == 1]
        plot1.set_xticks(xticks)
        plot1.set_xticklabels(xticklabels, rotation=45)
        plot1.legend()

        # Affichage du graphique
        canvas = FigureCanvasTkAgg(fig,  master=self)
        canvas.draw()
        canvas.get_tk_widget().pack()

