create table Departements (
    code_departement TEXT,
    nom_departement TEXT,
    code_region INTEGER,
    zone_climatique TEXT,
    constraint pk_departements primary key (code_departement),
    constraint fk_region foreign key (code_region) references Regions(code_region)
);

create table Regions (
    code_region INTEGER,
    nom_region TEXT,
    constraint pk_regions primary key (code_region)
);

create table Mesures (
    code_departement TEXT,
    date_mesure DATE,
    temperature_min_mesure FLOAT,
    temperature_max_mesure FLOAT,
    temperature_moy_mesure FLOAT,
    constraint pk_mesures primary key (code_departement, date_mesure),
    constraint fk_mesures foreign key (code_departement) references Departements(code_departement)
);

--TODO Q4 Ajouter les créations des nouvelles tables

CREATE TABLE Communes (
    code_commune INTEGER,
    code_departement TEXT, --cas 1 to Many
    nom_commune TEXT,
    statut_commune TEXT,
    altitude_moy_commune INTEGER,
    population_commune INTEGER,
    superficie_commune INTEGER,
    code_canton_commune INTEGER,
    code_arrondissement_commune INTEGER,
    CONSTRAINT pk_communes PRIMARY KEY (code_commune, code_departement),
    CONSTRAINT fk_Communes FOREIGN KEY (code_departement) REFERENCES Departements(code_departement),
    CONSTRAINT ch_Communes CHECK (superficie_commune > 0)
);

--CREATE TABLE Travaux (  id_travaux INTEGER AUTOINCREMENT,  cout_total_HT_travaux FLOAT,  cout_induit_HT_travaux FLOAT,  annee_travaux INTEGER,  type_logement_travaux TEXT,  annee_construction_logement INTEGER,
--    code_region INTEGER, --nous somme dans la regle 1 to Many
--    code_departement INTEGER, -- cas des 0..1 to Many
--    CONSTRAINT pk_travaux PRIMARY KEY (id_travaux),
--    CONSTRAINT fk_code_region FOREIGN KEY (code_region) REFERENCES Regions(code_region)
--    CONSTRAINT fk_code_departement FOREIGN KEY (code_departement) REFERENCES Departements(code_departement)
--);

-- Heritage appliquer avec Reference, la clé primaire de Travaux va vers ses fils
CREATE TABLE Isolations(
    id_Isolation INTEGER PRIMARY KEY AUTOINCREMENT,
    cout_total_HT_Isolation FLOAT,
    cout_induit_HT_Isolation FLOAT,
    annee_Isolation INTEGER,
    type_logement_Isolation TEXT,
    annee_construction_logement INTEGER,
    code_region INTEGER, --nous somme dans la regle 1 to Many
    code_departement TEXT, -- cas des 0..1 to Many
    poste TEXT CHECK (poste IN('COMBLE PERDUES', 'ITI', 'ITE', 'RAMPANTS', 'SARKING', 'TOITURE TERRASSE', 'PLANCHER BAS', NULL)),
    isolant TEXT CHECK ( isolant IN('AUTRES', 'LAINE VEGETALE', 'LAINE MINERALE', 'PLASTIQUE', NULL)),
    epaisseur INTEGER,
    surface_isolation FLOAT,
    
    CONSTRAINT fk_Isolations_departement FOREIGN KEY (code_departement) REFERENCES Departements(code_departement),
    CONSTRAINT fk_Isolations_region FOREIGN KEY (code_region) REFERENCES Regions(code_region),
    CONSTRAINT ch_Isolation_eppaisseru CHECK (epaisseur > 0 OR epaisseur == NULL),
    
    CONSTRAINT ch_Isolation_cout CHECK (cout_total_HT_Isolation > 0 AND (cout_induit_HT_Isolation > 0 OR cout_induit_HT_Isolation == NULL) )
);

CREATE TABLE Chauffages(
    id_Chauffage INTEGER PRIMARY KEY AUTOINCREMENT,
    cout_total_HT_Chauffage FLOAT,
    cout_induit_HT_Chauffage FLOAT,
    annee_Chauffage INTEGER,
    type_logement_Chauffage TEXT,
    annee_construction_logement INTEGER,
    code_region INTEGER, --nous somme dans la regle 1 to Many
    code_departement TEXT, -- cas des 0..1 to Many
    energie_av_travaux TEXT CHECK ( energie_av_travaux IN ( 'AUTRES', 'BOIS', 'ELECTRICITE', 'FIOUL', 'GAZ', NULL)),
    energie_installee TEXT CHECK ( energie_installee IN ( 'AUTRES', 'BOIS', 'ELECTRICITE', 'FIOUL', 'GAZ', NULL)),
    generateur TEXT CHECK ( generateur IN ( 'AUTRES', 'CHAUDIERE', 'INSERT', 'PAC', 'POELE', 'RADIATEUR', NULL)),
    type_chaudiere TEXT CHECK ( type_chaudiere IN ('STANDARD', 'AIR-EAU', 'A CONDENSATION', 'AUTRES', 'AIR-AIR', 'GEOTHERMIE', 'HPE', NULL)),
    CONSTRAINT fk_Chauffage_departement FOREIGN KEY (code_departement) REFERENCES Departements(code_departement),
    CONSTRAINT fk_Chauffage_region FOREIGN KEY (code_region) REFERENCES Regions(code_region),

    CONSTRAINT ch_Chauffage_energie CHECK (energie_installee > 0 OR energie_installee == NULL),
    CONSTRAINT ch_Chauffage_cout CHECK (cout_total_HT_Chauffage > 0 AND (cout_induit_HT_Chauffage > 0 OR cout_induit_HT_Chauffage == NULL) )
);

CREATE TABLE Photovoltaiques(
    id_Photovoltaique INTEGER PRIMARY KEY AUTOINCREMENT,
    cout_total_HT_Photovoltaique FLOAT,
    cout_induit_HT_Photovoltaique FLOAT,
    annee_Photovoltaique INTEGER,
    type_logement_Photovoltaique TEXT,
    annee_construction_logement INTEGER,
    code_region INTEGER, --nous somme dans la regle 1 to Many
    code_departement INTEGER, -- cas des 0..1 to Many
    puissance_installee INTEGER,
    type_panneaux TEXT CHECK (type_panneaux IN ('MONOCRISTALLIN', 'POLYCRISTALLIN', NULL)),
    CONSTRAINT fk_Photovoltaiques FOREIGN KEY (code_departement) REFERENCES Departements(code_departement),
    CONSTRAINT fk_Photovoltaiques_region FOREIGN KEY (code_region) REFERENCES Regions(code_region),

    CONSTRAINT ch_Photovoltaique_puissance CHECK (puissance_installee > 0 OR puissance_installee == NULL),
    CONSTRAINT ch_Photovoltaique_cout CHECK (cout_total_HT_Photovoltaique > 0 AND (cout_induit_HT_Photovoltaique > 0 OR cout_induit_HT_Photovoltaique == NULL) )
);
