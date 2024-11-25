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

CREATE TABLE Comunnes (
    code_commune INTEGER,
    code_departement TEXT, --cas 1 to Many
    nom_commune TEXT,
    statut_commune TEXT,
    altitude_moy_commune INTEGER,
    population_commune INTEGER,
    superficie_commune INTEGER,
    code_canton_commune INTEGER,
    code_arrondissement_commune INTEGER,
    CONSTRAINT pk_commune PRIMARY KEY (code_commune),
    CONSTRAINT fk_code_departement FOREIGN KEY (code_departement) REFERENCES Departements(code_departement)
);

CREATE TABLE Travaux (
    id_travaux INTEGER,
    cout_total_HT_travaux FLOAT,
    cout_induit_HT_travaux FLOAT,
    annee_travaux INTEGER,
    type_logement_travaux TEXT,
    annee_construction_logement INTEGER,
    code_region INTEGER, --nous somme dans la regle 1 to Many
    CONSTRAINT pk_travaux PRIMARY KEY (id_travaux),
    CONSTRAINT fk_code_region FOREIGN KEY (code_region) REFERENCES Regions(code_region)
);

-- cas des 0..1 to Many
CREATE TABLE Travaux_Departement( 
    id_travaux INTEGER,
    code_departement TEXT,
    CONSTRAINT pk_travaux_departement PRIMARY KEY (id_travaux),
    CONSTRAINT fk_id FOREIGN KEY (id_travaux) REFERENCES Travaux(id_travaux),
    CONSTRAINT fk_code_dep FOREIGN KEY (code_departement) REFERENCES Departements(code_departement)
);

-- Heritage appliquer avec Reference, la clé primaire de Travaux va vers ses fils
CREATE TABLE Isolations(
    id_travaux INTEGER,
    poste TEXT,
    isolant TEXT,
    epaisseur INTEGER,
    surface_isolation FLOAT,
    CONSTRAINT pk_isolation PRIMARY KEY (id_travaux),
    CONSTRAINT fk_isolation FOREIGN KEY (id_travaux) REFERENCES Travaux(id_travaux)
);

CREATE TABLE Chauffages(
    id_travaux INTEGER,
    energie_av_travaux TEXT,
    energie_installee TEXT,
    generateur TEXT,
    type_chaudiere TEXT,
    CONSTRAINT pk_isolation PRIMARY KEY (id_travaux),
    CONSTRAINT fk_isolation FOREIGN KEY (id_travaux) REFERENCES Travaux(id_travaux)
);

CREATE TABLE Photovoltaiques(
    id_travaux INTEGER,
    puissance_installee INTEGER,
    type_panneaux TEXT,
    CONSTRAINT pk_isolation PRIMARY KEY (id_travaux),
    CONSTRAINT fk_isolation FOREIGN KEY (id_travaux) REFERENCES Travaux(id_travaux)
);