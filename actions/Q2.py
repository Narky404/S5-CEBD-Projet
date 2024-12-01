import tkinter as tk
from utils import display
from tkinter import ttk

class Window(tk.Toplevel):
    def __init__(self, parent):
        super().__init__(parent)

        # Définition de la taille de la fenêtre, du titre et des lignes/colonnes de l'affichage grid
        display.centerWindow(600, 400, self)
        self.title('Q2 : département le plus chaud par zone climatique')
        display.defineGridDisplay(self, 2, 1)
    
        #Consigne
        """Modifier cette fonction en s'inspirant du code de F1, pour qu'elle affiche le(s) département(s) "
                       "avec la température moyenne (c.a.d. moyenne des moyennes de toutes les mesures) la plus haute "
                       "par zone climatique. \nSchéma attendu : (zone_climatique, nom_departement, temperature_moy_max)"""

        #TODO Q1 Modifier la suite du code (en se basant sur le code de F1) pour répondre à Q1
        # On définit les colonnes que l'on souhaite afficher dans la fenêtre et la requête
        columns = ('zone_climatique', 'nom_departement','temperature_moy_max')
        query = """WITH Par_dep AS (
            SELECT code_departement, AVG(temperature_moy_mesure) as temp_moy_dep
            FROM Departements JOIN Mesures USING (code_departement) 
            GROUP BY code_departement
            )
            SELECT zone_climatique, nom_departement, MAX(temp_moy_dep) AS temperature_moy_max 
            FROM Departements JOIN Mesures USING (code_departement) JOIN Par_dep USING (code_departement) 
            GROUP BY zone_climatique
            """
        # On utilise la fonction createTreeViewDisplayQuery pour afficher les résultats de la requête
        #TODO Q1 Aller voir le code de createTreeViewDisplayQuery dans utils/display.py
        tree = display.createTreeViewDisplayQuery(self, columns, query,200)
        tree.grid(row=0, sticky="nswe")

        #TODO Q2 Modifier la suite du code (en se basant sur le code de F1) pour répondre à Q2

        # On définit les colonnes que l'on souhaite afficher dans la fenêtre et la requête

        # On utilise la fonction createTreeViewDisplayQuery pour afficher les résultats de la requête