--Requête SQL avec utilisation du mot clé DISTINCT

--connaitre les différentes filières propose par parcoursup sans doublons:
--bdd 1 : 
SELECT DISTINCT fili FROM parcoursup;
--bdd 2 :
SELECT DISTINCT fili FROM formation;


--Requête SQL avec bloc emboité (sous-requête) utilisant le mot clé [NOT] IN

--connaitre les academies qui possede un BTS ou une licence:
--bdd 1 :
SELECT DISTINCT academies FROM parcoursup
WHERE fili IN ('BTS', 'Licence');

--bdd 2 :
SELECT DISTINCT academies 
FROM departement d
JOIN etablissement e 
ON d.dep = e.dep
JOIN formation f
ON e.cod_uai = f.cod_uai
WHERE fili IN ('BTS', 'Licence');

--Requête SQL avec bloc emboité avec utilisation du mot clé [NOT] EXISTS
--trouver les etablissements qui n'ont aucune formation sélective:
--bdd 1 :
SELECT DISTINCT p1.cod_uai, p1.g_ea_lib_vx
FROM parcoursup p1
WHERE NOT EXISTS (
    SELECT 1
    FROM parcoursup p2
    WHERE p1.cod_uai = p2.cod_uai
      AND p2.select_form = 'Formation Sélective'
);
    
--bdd 2 :
SELECT e.cod_uai, e.g_ea_lib_vx
FROM etablissement e
WHERE NOT EXISTS (
    SELECT 1
    FROM formation f
    WHERE f.cod_uai = e.cod_uai
      AND f.select_form = 'Formation Sélective'
);



--Requête SQL en utilisant plusieurs fois la même table (alias)

--afficher des paires de formations differentes proposees par le meme etablissement:
--bdd 1 :
SELECT 
    p1.g_ea_lib_vx AS Nom_Etablissement,
    p1.lib_for_voe_ins AS Formation_A,
    p2.lib_for_voe_ins AS Formation_B
FROM parcoursup p1
JOIN parcoursup p2 ON p1.cod_uai = p2.cod_uai AND p1.cod_aff_form < p2.cod_aff_form;

--bdd 2 :
SELECT 
    e.g_ea_lib_vx AS Nom_Etablissement,
    f1.lib_for_voe_ins AS Formation_A,
    f2.lib_for_voe_ins AS Formation_B
FROM formation f1
JOIN formation f2 ON f1.cod_uai = f2.cod_uai AND f1.cod_aff_form < f2.cod_aff_form
JOIN etablissement e ON f1.cod_uai = e.cod_uai;




--Requête SQL en utilisant les clauses GROUP BY et HAVING

--connaitre les etablissements ou leurs nombres de voeux principaux (toutes filieres confondues) sont superieurs a 10000:
--bdd 1 :
SELECT g_ea_lib_vx, SUM(nb_voe_pp) AS 'nombres de voeux principaux'
FROM parcoursup
GROUP BY g_ea_lib_vx
HAVING SUM(nb_voe_pp) > 10000

--bdd 2 :
SELECT e.g_ea_lib_vx , SUM(s.nb_voe_pp) AS 'nombres de voeux principaux'
FROM etablissement e
JOIN formation f ON e.cod_uai = f.cod_uai
JOIN statistiques s ON f.cod_aff_form = s.cod_aff_form
GROUP BY e.g_ea_lib_vx
HAVING SUM(s.nb_voe_pp) > 10000;


--Requête SQL avec opérations ensemblistes (UNION ou INTERSECT ou EXCEPT)

--connaitre les etablissements qui ont beaucoup de voeux soit qui ont beaucoup d'admis:
--bdd 1 :
SELECT g_ea_lib_vx
FROM parcoursup
WHERE voe_tot > 5000
UNION
SELECT g_ea_lib_vx
FROM parcoursup
WHERE acc_tot > 1000;

--bdd 2 :
SELECT e.g_ea_lib_vx
FROM etablissement e
JOIN formation f ON e.cod_uai = f.cod_uai
JOIN statistiques s ON f.cod_aff_form = s.cod_aff_form
WHERE s.voe_tot > 5000
UNION
SELECT e.g_ea_lib_vx
FROM etablissement e
JOIN formation f ON e.cod_uai = f.cod_uai
JOIN statistiques s ON f.cod_aff_form = s.cod_aff_form
WHERE s.acc_tot > 1000;

--Requête SQL d'insertion de tuples

--inserer une nouvelle ligne fictive dans la table parcoursup :
--bdd 1 :
INSERT INTO parcoursup (
    session, contrat_etab, cod_uai, g_ea_lib_vx, dep, dep_lib, region_etab_aff, academies, ville_etab, lib_for_voe_ins,
    select_form, fili, lib_comp_voe_ins, form_lib_voe_acc, fil_lib_voe_acc, detail_forma, geolocalisation_des_formations_lon, geolocalisation_des_formations_lat,
    capa_fin, voe_tot, voe_tot_f, nb_voe_pp, nb_voe_pp_internat, nb_voe_pp_bg, nb_voe_pp_bg_brs, nb_voe_pp_bt, nb_voe_pp_bt_brs,
    nb_voe_pp_bp, nb_voe_pp_bp_brs, nb_voe_pp_at, nb_voe_pc, nb_voe_pc_bg, nb_voe_pc_bt, nb_voe_pc_bp, nb_voe_pc_at,
    nb_cla_pp, nb_cla_pc, nb_cla_pp_internat, nb_cla_pp_pasinternat, nb_cla_pp_bg, nb_cla_pp_bg_brs, nb_cla_pp_bt, nb_cla_pp_bt_brs,
    nb_cla_pp_bp, nb_cla_pp_bp_brs, nb_cla_pp_at, prop_tot, acc_tot, acc_tot_f, acc_pp, acc_pc, acc_debutpp, acc_datebac, acc_finpp,
    acc_internat, acc_brs, acc_neobac, acc_bg, acc_bt, acc_bp, acc_at, acc_mention_nonrenseignee, acc_sansmention, acc_ab, acc_b, acc_tb,
    acc_tbf, acc_bg_mention, acc_bt_mention, acc_bp_mention, acc_term, acc_term_f, acc_aca_orig, acc_aca_orig_idf, pct_acc_debutpp,
    pct_acc_datebac, pct_acc_finpp, pct_f, pct_aca_orig, pct_aca_orig_idf, pct_etab_orig, pct_bours, pct_neobac, pct_mention_nonrenseignee,
    pct_sansmention, pct_ab, pct_b, pct_tb, pct_tbf, pct_bg, pct_bg_mention, pct_bt, pct_bt_mention, pct_bp, pct_bp_mention,
    prop_tot_bg, prop_tot_bg_brs, prop_tot_bt, prop_tot_bt_brs, prop_tot_bp, prop_tot_bp_brs, prop_tot_at, lib_grp1, ran_grp1,
    lib_grp2, ran_grp2, lib_grp3, ran_grp3, list_com, tri, cod_aff_form, detail_forma2, lien_form_psup, taux_acces_ens,
    part_acces_gen, part_acces_tec, part_acces_pro, etablissement_id_paysage, composante_id_paysage
)
VALUES (
    2026, 'Public', '1234567A', 'form fictive', '37', 'Indre-et-Loire', 'Centre-Val de Loire', 'Orléans-Tours', 'Tours', 'Formation informatique',
    'formation sélective', 'Licence', 'form fictive - Licence informatique', 'Licence Informatique', 'Informatique', 'Informatique', 0.0, 0.0,
    0, 1, 2, 3, 4, 5, 6, 7, 
    8, 9, 10, 11, 12, 13, 14, 15,
    0, 1, 2, 3, 4, 5, 6, 7,
    8, 9, 10, 11, 12, 13, 14, 15,
    0, 1, 2, 3, 4, 5, 6, 7,
    8, 9, 10, 0, 12, 13, 14, 15,
    0, 1, 2, 3, 4, 5, 6, 7,
    8, 9, 10, 11, 12, 13, 14, 15,
    0, 1, 2, 3, 4, 5, 6, 7, 
    8, 9, 10, 11, 12, 13, 14, 15, 
    0, 1, 2, 3, 'Autres candidats', 830, 
    'Bacheliers professionnels toutes series', 840, 
    'Bacheliers technologiques toutes series', 850, 
    'Liste d\'appel commune à plusieurs formations', '1_universités', 860,   
    NULL, 'http://lien.formation',
    1, 2, 3, 4, NULL, NULL
);

--bdd 2 :
INSERT INTO departement (dep, dep_lib, region_etab_aff, academies) 
VALUES ('37', 'Indre-et-Loire', 'Centre-Val de Loire', 'Orléans-Tours');
INSERT INTO etablissement (cod_uai, contrat_etab, g_ea_lib_vx, dep, ville_etab, etablissement_id_paysage) 
VALUES ('1234567A', 'Public', 'form fictive', '37', 'Tours', NULL);
INSERT INTO formation (
    cod_aff_form, cod_uai, lib_for_voe_ins, select_form, fili, lib_comp_voe_ins, 
    form_lib_voe_acc, fil_lib_voe_acc, detail_forma, geolocalisation_des_formations_lon, 
    geolocalisation_des_formations_lat, list_com, tri, detail_forma2, lien_form_psup, composante_id_paysage
) 
VALUES (
    860, '1234567A', 'Formation informatique', 'formation sélective', 'Licence', 'form fictive - Licence informatique', 
    'Licence Informatique', 'Informatique', 'Informatique', 0.0, 
    0.0, 'Liste d''appel commune à plusieurs formations', '1_universités', NULL, 'http://lien.formation', NULL
);
INSERT INTO statistiques (
    session, cod_aff_form, 
    capa_fin, voe_tot, voe_tot_f, nb_voe_pp, nb_voe_pp_internat, nb_voe_pp_bg, nb_voe_pp_bg_brs, nb_voe_pp_bt, nb_voe_pp_bt_brs, 
    nb_voe_pp_bp, nb_voe_pp_bp_brs, nb_voe_pp_at, nb_voe_pc, nb_voe_pc_bg, nb_voe_pc_bt, nb_voe_pc_bp, nb_voe_pc_at, 
    nb_cla_pp, nb_cla_pc, nb_cla_pp_internat, nb_cla_pp_pasinternat, nb_cla_pp_bg, nb_cla_pp_bg_brs, nb_cla_pp_bt, nb_cla_pp_bt_brs, 
    nb_cla_pp_bp, nb_cla_pp_bp_brs, nb_cla_pp_at, prop_tot, acc_tot, acc_tot_f, acc_pp, acc_pc, acc_debutpp, acc_datebac, acc_finpp, 
    acc_internat, acc_brs, acc_neobac, acc_bg, acc_bt, acc_bp, acc_at, acc_mention_nonrenseignee, acc_sansmention, acc_ab, acc_b, acc_tb, 
    acc_tbf, acc_bg_mention, acc_bt_mention, acc_bp_mention, acc_term, acc_term_f, acc_aca_orig, acc_aca_orig_idf, pct_acc_debutpp, 
    pct_acc_datebac, pct_acc_finpp, pct_f, pct_aca_orig, pct_aca_orig_idf, pct_etab_orig, pct_bours, pct_neobac, pct_mention_nonrenseignee, 
    pct_sansmention, pct_ab, pct_b, pct_tb, pct_tbf, pct_bg, pct_bg_mention, pct_bt, pct_bt_mention, pct_bp, pct_bp_mention, 
    prop_tot_bg, prop_tot_bg_brs, prop_tot_bt, prop_tot_bt_brs, prop_tot_bp, prop_tot_bp_brs, prop_tot_at, 
    lib_grp1, ran_grp1, lib_grp2, ran_grp2, lib_grp3, ran_grp3, 
    taux_acces_ens, part_acces_gen, part_acces_tec, part_acces_pro
) 
VALUES (
    2026, 860, 
    0, 1, 2, 3, 4, 5, 6, 7, 8, 
    9, 10, 11, 12, 13, 14, 15, 0, 
    1, 2, 3, 4, 5, 6, 7, 8, 
    9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 
    4, 5, 6, 7, 8, 9, 10, 0, 12, 13, 14, 15, 
    0, 1, 2, 3, 4, 5, 6, 7, 8, 
    9, 10, 11, 12, 13, 14, 15, 0, 1, 
    2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 
    13, 14, 15, 0, 1, 2, 3, 
    'Autres candidats', '830', 'Bacheliers professionnels toutes series', 840, 'Bacheliers technologiques toutes series', 850, 
    '1', '2', '3', '4'
);

--Requête SQL de mise à jour de tuples

--mettre a jour le nouveau tuple inserer pour que sa session soit 2025:
--bdd 1 :
UPDATE parcoursup
SET session = 2025
WHERE cod_uai = '1234567A';

--bdd 2 :
UPDATE statistiques s
JOIN formation f ON s.cod_aff_form = f.cod_aff_form
SET s.session = 2025
WHERE f.cod_uai = '1234567A';


--CHECK 1 - contrainte de domaine utilisant les mots clés IN ou BETWEEN
-- ecrire une requete pour verifier que la session est comprise entre 2018 et 2026.
--Il faut cette contrainte car parcoursup n''existe que depuis 2018 et on ne peut pas avoir de session dans le futur.

--bdd 1 :
ALTER TABLE parcoursup
ADD CONSTRAINT chk_session_valide
CHECK (session IN (2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026));

--bdd 2 :
ALTER TABLE statistiques
ADD CONSTRAINT chk_session_valide
CHECK (session IN (2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026));

-- CHECK 2 - contrainte de domaine utilisant le mot clé LIKE

--ecrire une requete pour verifier que le contrat_etab ne peut prendre que les valeurs suivantes : 'Public', 'Privé sous contrat d'association', 'Privé enseignement supérieur' ou 'Privé hors contrat'.
--contrat_etab ne peut prendre que les valeurs suivantes : 'Public', 'Privé sous contrat d'association', 'Privé enseignement supérieur' ou 'Privé hors contrat'. Il est donc necessaire de mettre une contrainte pour s'assurer que les données insérées dans cette colonne respectent ces valeurs.
--bdd 1 : 
ALTER TABLE parcoursup
ADD CONSTRAINT chk_contrat_etab_format
CHECK (
    contrat_etab LIKE 'Public' OR
    contrat_etab LIKE 'Privé sous contrat d\'association' OR
    contrat_etab LIKE 'Privé enseignement supérieur' OR
    contrat_etab LIKE 'Privé hors contrat'
);

--bdd 2 :
ALTER TABLE etablissement
ADD CONSTRAINT chk_contrat_etab_format
CHECK (
    contrat_etab LIKE 'Public' OR
    contrat_etab LIKE 'Privé sous contrat d\'association' OR
    contrat_etab LIKE 'Privé enseignement supérieur' OR
    contrat_etab LIKE 'Privé hors contrat'
);



--CHECK 3 - utilisant une combinaison logique de conditions (AND, OR, NOT)

--ecrire une contrainte qui permet que pour chaque formation, la capacité finale ou le nombre total de voeux doit etre superieur a 0?
--Sans cela, on pourrait avoir des formations qui n'ont ni capacité ni voeux, ce qui n'aurait pas de sens. Il est donc important de mettre une contrainte pour s'assurer que les données insérées dans ces colonnes respectent cette condition.
--bdd 1 :
ALTER TABLE parcoursup
ADD CONSTRAINT chk_capa_ou_voe
CHECK (
    capa_fin > 0 OR voe_tot > 0
);

--bdd 2 :
ALTER TABLE statistiques
ADD CONSTRAINT chk_capa_ou_voe
CHECK (capa_fin > 0 OR voe_tot > 0);

--TRIGGER 1 - Trigger de type STATEMENT LEVEL

-- !!! SQL est utilise ici car my sql ne supporte pas les triggers FOR EACH STATEMENT !!!
--lors d'un insertion dans la table parcoursup, la colonne dep doit correspondre a un code de departement ou de territoire francais valide 
--cette contrainte permet de garantir la coherence des numeros de departements francais.
--avant l'insertion d'une nouvelle donnée dans parcoursup, on verifie si le numero du departement est compris entre 01 et 95 ou s'il correspond a un des codes de departements d'outre mer (2A, 2B, 971, 972, 973, 974, 976, 978, 987, 988). Si ce n'est pas le cas, l'insertion est refusée et un message d'erreur est affiché.

--bdd 1 :
DELIMITER $$

CREATE TRIGGER trg_check_departement
BEFORE INSERT ON parcoursup
FOR EACH STATEMENT
BEGIN
    IF EXISTS (
        SELECT 1
        FROM parcoursup
        WHERE 
            NOT (
                (dep BETWEEN '01' AND '95')
                OR dep IN ('2A', '2B')
                OR dep IN ('971', '972', '973', '974', '976', '978', '987', '988')
            )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : code département invalide';
    END IF;
END$$

DELIMITER ;

--bdd 2:

DELIMITER $$

CREATE TRIGGER trg_check_departement
BEFORE INSERT ON departement
FOR EACH STATEMENT
BEGIN
    IF EXISTS (
        SELECT 1
        FROM departement
        WHERE 
            NOT (
                (dep BETWEEN '01' AND '95')
                OR dep IN ('2A', '2B')
                OR dep IN ('971', '972', '973', '974', '976', '978', '987', '988')
            )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : code département invalide';
    END IF;
END$$

DELIMITER ;


--TRIGGER 2 - Trigger de type FOR EACH ROW LEVEL

--À chaque insertion d'une nouvelle formation dans la table parcoursup, la colonne select_form est automatiquement renseignée : si le libellé de la formation commence par « Licence », alors select_form est mis à « formation non sélective », sinon il est mis à « formation sélective ».
--Cela assure la cohérence des données dans la colonne select_form en fonction du libellé de la formation, et évite les erreurs d'insertion où select_form pourrait être renseigné de manière incorrecte.
--On applique avant la nouvelle insertion que pour chaque ligne on applique a la colonne select_form la valeur 'formation non sélective' si le libellé de la formation commence par 'Licence' et sinon on lui napplique la valeur'formation sélective'.
--bdd 1:
DELIMITER $$

CREATE TRIGGER trg_classification_form
BEFORE INSERT ON parcoursup
FOR EACH ROW
BEGIN
    IF NEW.lib_for_voe_ins LIKE 'Licence%' THEN
        SET NEW.select_form = 'formation non sélective';
    ELSE
        SET NEW.select_form = 'formation sélective';
    END IF;
END$$

DELIMITER ;


--bdd 2 :
DELIMITER $$

CREATE TRIGGER trg_classification_form
BEFORE INSERT ON formation
FOR EACH ROW
BEGIN
    IF NEW.lib_for_voe_ins LIKE 'Licence%' THEN
        SET NEW.select_form = 'formation non sélective';
    ELSE
        SET NEW.select_form = 'formation sélective';
    END IF;
END$$

DELIMITER ;