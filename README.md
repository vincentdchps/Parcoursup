# Parcoursup

![Stars](https://img.shields.io/github/stars/Inc44/Parcoursup?style=social)
![Forks](https://img.shields.io/github/forks/Inc44/Parcoursup?style=social)
![Watchers](https://img.shields.io/github/watchers/Inc44/Parcoursup?style=social)
![Repo Size](https://img.shields.io/github/repo-size/Inc44/Parcoursup)
![Language Count](https://img.shields.io/github/languages/count/Inc44/Parcoursup)
![Top Language](https://img.shields.io/github/languages/top/Inc44/Parcoursup)
[![Issues](https://img.shields.io/github/issues/Inc44/Parcoursup)](https://github.com/Inc44/Parcoursup/issues?q=is%3Aopen+is%3Aissue)
![Last Commit](https://img.shields.io/github/last-commit/Inc44/Parcoursup?color=red)
[![Release](https://img.shields.io/github/release/Inc44/Parcoursup.svg)](https://github.com/Inc44/Parcoursup/releases)
[![Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/Inc44)

## 🎯 Objectif de la base de données

L'objectif principal de cette base de données est de récupérer et d'analyser toutes les informations liées à l'orientation et aux admissions des élèves dans l'enseignement supérieur via la plateforme Parcoursup. Elle permet de suivre de bout en bout le processus d'affectation, depuis le moment où les candidats formulent leurs vœux jusqu'à leur acceptation finale dans les différentes formations. On y retrouve tous les détails sur les établissements, leurs capacités d'accueil, et surtout le profil précis des postulants, par exemple s'ils sont boursiers, leur type de baccalauréat ou encore les mentions qu'ils ont obtenues. Grâce à toutes ces informations, le but est de pouvoir observer la sélectivité de chaque filière, d'étudier les taux d'accès selon les différentes phases d'admission principale ou complémentaire, et de comprendre comment se répartissent les futurs étudiants selon leur origine académique et géographique. Cela donne donc une vision globale pour analyser efficacement les critères d'intégration post-bac sans perdre la trace des spécificités de chaque candidature.

## ⛔ Contraintes d'intégrité

Pour la partie sur les contraintes d'intégrité, on a d'abord les contraintes statiques qui s'appliquent en permanence à notre base. Par exemple, il est impératif que le code UAI de l'établissement et le code d'affectation de la formation soient toujours renseignés pour identifier chaque ligne de manière unique. On doit aussi vérifier la cohérence des effectifs : le nombre de candidates ou de boursiers ne peut absolument pas dépasser le nombre total de vœux ou d'admis. De la même manière, les champs de pourcentages doivent obligatoirement être compris entre 0 et 100, et le total des admis ne peut pas dépasser la capacité finale de l'établissement. Ensuite, concernant les contraintes dynamiques qui s'activent lors d'un changement d'état, on retrouve la règle de non-régression des admissions. Lors d'une mise à jour des données, le nombre total de candidats ayant définitivement accepté une proposition ne peut qu'augmenter ou stagner, car on ne supprime pas une acceptation dans ce processus. Enfin, l'ajout de candidatures en phase complémentaire ne peut se déclencher que si le nombre d'admis en phase principale est resté strictement inférieur à la capacité finale d'accueil de la formation.

## 🤔 Exemples de redondances et d'anomalies existantes dans le schéma

- **Redondances :**
	Le *Lycée Saint Exupéry* (UAI `0782539L`) propose deux formations (CPGE et BTS). L'intégralité de ses métadonnées (statut "Public", département "Yvelines", région "Ile-de-France", académie "Versailles", commune "Mantes-la-Jolie", coordonnées GPS "48.9974, 1.69372") est dupliquée à l'identique sur les deux lignes.
- **Anomalie d'insertion :**
	Il est impossible d'ajouter un nouvel établissement (ex : une université venant d'être construite) dans la base de données tant que cet établissement ne propose pas au moins une formation, car la clé primaire requiert un code de formation (`cod_aff_form`).
- **Anomalie de mise à jour :**
	Si la commune ou les coordonnées GPS de l'établissement *Lycée Saint Exupéry* (UAI `0782539L`) changent, il faut modifier cette information sur plusieurs lignes simultanément (CPGE et BTS). Une modification partielle entraînera une incohérence de la base.
- **Anomalie de suppression :**
	Si l'on supprime les formations "CPGE - Lettres" et "BTS - Services - Support à l'action managériale" du *Lycée Saint Exupéry* (UAI `0782539L`), l'existence même de ce lycée, ainsi que sa localisation et son code UAI, sont définitivement effacés de la base de données.

## ⚙️ Features

| Key                              | Description                                                                                                                                      |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| `session`                        | Session                                                                                                                                          |
| `contrat_etab`                   | Statut de l'établissement de la filière de formation (public, privé…)                                                                            |
| `cod_uai`                        | Code UAI de l'établissement                                                                                                                      |
| `g_ea_lib_vx`                    | Établissement                                                                                                                                    |
| `dep`                            | Code départemental de l'établissement                                                                                                            |
| `dep_lib`                        | Département de l'établissement                                                                                                                   |
| `region_etab_aff`                | Région de l'établissement                                                                                                                        |
| `acad_mies`                      | Académie de l'établissement                                                                                                                      |
| `ville_etab`                     | Commune de l'établissement                                                                                                                       |
| `lib_for_voe_ins`                | Filière de formation                                                                                                                             |
| `select_form`                    | Sélectivité                                                                                                                                      |
| `fili`                           | Filière de formation très agrégée                                                                                                                |
| `lib_comp_voe_ins`               | Filière de formation détaillée                                                                                                                   |
| `form_lib_voe_acc`               | Filière de formation                                                                                                                             |
| `fil_lib_voe_acc`                | Filière de formation détaillée bis                                                                                                               |
| `detail_forma`                   | Filière de formation très détaillée                                                                                                              |
| `g_olocalisation_des_formations` | Coordonnées GPS de la formation                                                                                                                  |
| `capa_fin`                       | Capacité de l'établissement par formation                                                                                                        |
| `voe_tot`                        | Effectif total des candidats pour une formation                                                                                                  |
| `voe_tot_f`                      | Dont effectif des candidates pour une formation                                                                                                  |
| `nb_voe_pp`                      | Effectif total des candidats en phase principale                                                                                                 |
| `nb_voe_pp_internat`             | Dont effectif des candidats ayant postulé en internat                                                                                            |
| `nb_voe_pp_bg`                   | Effectif des candidats néo bacheliers généraux en phase principale                                                                               |
| `nb_voe_pp_bg_brs`               | Dont effectif des candidats boursiers néo bacheliers généraux en phase principale                                                                |
| `nb_voe_pp_bt`                   | Effectif des candidats néo bacheliers technologiques en phase principale                                                                         |
| `nb_voe_pp_bt_brs`               | Dont effectif des candidats boursiers néo bacheliers technologiques en phase principale                                                          |
| `nb_voe_pp_bp`                   | Effectif des candidats néo bacheliers professionnels en phase principale                                                                         |
| `nb_voe_pp_bp_brs`               | Dont effectif des candidats boursiers néo bacheliers professionnels en phase principale                                                          |
| `nb_voe_pp_at`                   | Effectif des autres candidats en phase principale                                                                                                |
| `nb_voe_pc`                      | Effectif total des candidats en phase complémentaire                                                                                             |
| `nb_voe_pc_bg`                   | Effectif des candidats néo bacheliers généraux en phase complémentaire                                                                           |
| `nb_voe_pc_bt`                   | Effectif des candidats néo bacheliers technologique en phase complémentaire                                                                      |
| `nb_voe_pc_bp`                   | Effectif des candidats néo bacheliers professionnels en phase complémentaire                                                                     |
| `nb_voe_pc_at`                   | Effectifs des autres candidats en phase complémentaire                                                                                           |
| `nb_cla_pp`                      | Effectif total des candidats classés par l'établissement en phase principale                                                                     |
| `nb_cla_pc`                      | Effectif des candidats classés par l'établissement en phase complémentaire                                                                       |
| `nb_cla_pp_internat`             | Effectif des candidats classés par l'établissement en internat (CPGE)                                                                            |
| `nb_cla_pp_pasinternat`          | Effectif des candidats classés par l'établissement hors internat (CPGE)                                                                          |
| `nb_cla_pp_bg`                   | Effectif des candidats néo bacheliers généraux classés par l'établissement                                                                       |
| `nb_cla_pp_bg_brs`               | Dont effectif des candidats boursiers néo bacheliers généraux classés par l'établissement                                                        |
| `nb_cla_pp_bt`                   | Effectif des candidats néo bacheliers technologiques classés par l'établissement                                                                 |
| `nb_cla_pp_bt_brs`               | Dont effectif des candidats boursiers néo bacheliers technologiques classés par l'établissement                                                  |
| `nb_cla_pp_bp`                   | Effectif des candidats néo bacheliers professionnels classés par l'établissement                                                                 |
| `nb_cla_pp_bp_brs`               | Dont effectif des candidats boursiers néo bacheliers professionnels classés par l'établissement                                                  |
| `nb_cla_pp_at`                   | Effectif des autres candidats classés par l'établissement                                                                                        |
| `prop_tot`                       | Effectif total des candidats ayant reçu une proposition d'admission de la part de l'établissement                                                |
| `acc_tot`                        | Effectif total des candidats ayant accepté la proposition de l'établissement (admis)                                                             |
| `acc_tot_f`                      | Dont effectif des candidates admises                                                                                                             |
| `acc_pp`                         | Effectif des admis en phase principale                                                                                                           |
| `acc_pc`                         | Effectif des admis en phase complémentaire                                                                                                       |
| `acc_debutpp`                    | Dont effectif des admis ayant reçu leur proposition d'admission à l'ouverture de la procédure principale                                         |
| `acc_datebac`                    | Dont effectif des admis ayant reçu leur proposition d'admission avant le baccalauréat                                                            |
| `acc_finpp`                      | Dont effectif des admis ayant reçu leur proposition d'admission avant la fin de la procédure principale                                          |
| `acc_internat`                   | Dont effectif des admis en internat                                                                                                              |
| `acc_brs`                        | Dont effectif des admis boursiers néo bacheliers                                                                                                 |
| `acc_neobac`                     | Effectif des admis néo bacheliers                                                                                                                |
| `acc_bg`                         | Effectif des admis néo bacheliers généraux                                                                                                       |
| `acc_bt`                         | Effectif des admis néo bacheliers technologiques                                                                                                 |
| `acc_bp`                         | Effectif des admis néo bacheliers professionnels                                                                                                 |
| `acc_at`                         | Effectif des autres candidats admis                                                                                                              |
| `acc_mention_nonrenseignee`      | Dont effectif des admis néo bacheliers sans information sur la mention au bac                                                                    |
| `acc_sansmention`                | Dont effectif des admis néo bacheliers sans mention au bac                                                                                       |
| `acc_ab`                         | Dont effectif des admis néo bacheliers avec mention Assez Bien au bac                                                                            |
| `acc_b`                          | Dont effectif des admis néo bacheliers avec mention Bien au bac                                                                                  |
| `acc_tb`                         | Dont effectif des admis néo bacheliers avec mention Très Bien au bac                                                                             |
| `acc_tbf`                        | Dont effectif des admis néo bacheliers avec mention Très Bien avec félicitations au bac                                                          |
| `acc_bg_mention`                 | Effectif des admis néo bacheliers généraux ayant eu une mention au bac                                                                           |
| `acc_bt_mention`                 | Effectif des admis néo bacheliers technologiques ayant eu une mention au bac                                                                     |
| `acc_bp_mention`                 | Effectif des admis néo bacheliers professionnels ayant eu une mention au bac                                                                     |
| `acc_term`                       | Dont effectif des admis issus du même établissement (BTS/CPGE)                                                                                   |
| `acc_term_f`                     | Dont effectif des admises issues du même établissement (BTS/CPGE)                                                                                |
| `acc_aca_orig`                   | Dont effectif des admis issus de la même académie                                                                                                |
| `acc_aca_orig_idf`               | Dont effectif des admis issus de la même académie (Paris/Créteil/Versailles réunies)                                                             |
| `pct_acc_debutpp`                | % d'admis ayant reçu leur proposition d'admission à l'ouverture de la procédure principale                                                       |
| `pct_acc_datebac`                | % d'admis ayant reçu leur proposition d'admission avant le baccalauréat                                                                          |
| `pct_acc_finpp`                  | % d'admis ayant reçu leur proposition d'admission avant la fin de la procédure principale                                                        |
| `pct_f`                          | % d'admis dont filles                                                                                                                            |
| `pct_aca_orig`                   | % d'admis néo bacheliers issus de la même académie                                                                                               |
| `pct_aca_orig_idf`               | % d'admis néo bacheliers issus de la même académie (Paris/Créteil/Versailles réunies)                                                            |
| `pct_etab_orig`                  | % d'admis néo bacheliers issus du même établissement (BTS/CPGE)                                                                                  |
| `pct_bours`                      | % d'admis néo bacheliers boursiers                                                                                                               |
| `pct_neobac`                     | % d'admis néo bacheliers                                                                                                                         |
| `pct_mention_nonrenseignee`      | % d'admis néo bacheliers sans information sur la mention au bac                                                                                  |
| `pct_sansmention`                | % d'admis néo bacheliers sans mention au bac                                                                                                     |
| `pct_ab`                         | % d'admis néo bacheliers avec mention Assez Bien au bac                                                                                          |
| `pct_b`                          | % d'admis néo bacheliers avec mention Bien au bac                                                                                                |
| `pct_tb`                         | % d'admis néo bacheliers avec mention Très Bien au bac                                                                                           |
| `pct_tbf`                        | % d'admis néo bacheliers avec mention Très Bien avec félicitations au bac                                                                        |
| `pct_bg`                         | % d'admis néo bacheliers généraux                                                                                                                |
| `pct_bg_mention`                 | Dont % d'admis avec mention (BG)                                                                                                                 |
| `pct_bt`                         | % d'admis néo bacheliers technologiques                                                                                                          |
| `pct_bt_mention`                 | Dont % d'admis avec mention (BT)                                                                                                                 |
| `pct_bp`                         | % d'admis néo bacheliers professionnels                                                                                                          |
| `pct_bp_mention`                 | Dont % d'admis avec mention (BP)                                                                                                                 |
| `prop_tot_bg`                    | Effectif des candidats en terminale générale ayant reçu une proposition d'admission de la part de l'établissement                                |
| `prop_tot_bg_brs`                | Dont effectif des candidats boursiers en terminale générale ayant reçu une proposition d'admission de la part de l'établissement                 |
| `prop_tot_bt`                    | Effectif des candidats en terminale technologique ayant reçu une proposition d'admission de la part de l'établissement                           |
| `prop_tot_bt_brs`                | Dont effectif des candidats boursiers en terminale technologique ayant reçu une proposition d'admission de la part de l'établissement            |
| `prop_tot_bp`                    | Effectif des candidats en terminale professionnelle ayant reçu une proposition d'admission de la part de l'établissement                         |
| `prop_tot_bp_brs`                | Dont effectif des candidats boursiers en terminale générale professionnelle ayant reçu une proposition d'admission de la part de l'établissement |
| `prop_tot_at`                    | Effectif des autres candidats ayant reçu une proposition d'admission de la part de l'établissement                                               |
| `lib_grp1`                       | Regroupement 1 effectué par les formations pour les classements                                                                                  |
| `ran_grp1`                       | Rang du dernier appelé du groupe 1                                                                                                               |
| `lib_grp2`                       | Regroupement 2 effectué par les formations pour les classements                                                                                  |
| `ran_grp2`                       | Rang du dernier appelé du groupe 2                                                                                                               |
| `lib_grp3`                       | Regroupement 3 effectué par les formations pour les classements                                                                                  |
| `ran_grp3`                       | Rang du dernier appelé du groupe 3                                                                                                               |
| `list_com`                       | list_com                                                                                                                                         |
| `tri`                            | tri                                                                                                                                              |
| `cod_aff_form`                   | cod_aff_form                                                                                                                                     |
| `detail_forma2`                  | Concours communs et banque d'épreuves                                                                                                            |
| `lien_form_psup`                 | Lien de la formation sur la plateforme Parcoursup                                                                                                |
| `taux_acces_ens`                 | Taux d'accès                                                                                                                                     |
| `part_acces_gen`                 | Part des terminales générales qui étaient en position de recevoir une proposition en phase principale                                            |
| `part_acces_tec`                 | Part des terminales technologiques qui étaient en position de recevoir une proposition en phase principale                                       |
| `part_acces_pro`                 | Part des terminales professionnelles qui étaient en position de recevoir une proposition en phase principale                                     |
| `etablissement_id_paysage`       | etablissement_id_paysage                                                                                                                         |
| `composante_id_paysage`          | composante_id_paysage                                                                                                                            |

## ⚠️ Disclaimers

- **phpMyAdmin**: Import may take several minutes for a bzip2-compressed SQL file due to 14,252 entries with 117 attributes each.

## 📖 Usage Examples

### Standard Conversion

Convert specified input file using defaults for output, database, and table.
```bash
python -m parcoursup.cli -i fr-esr-parcoursup.json
```

Convert specified input file using defaults for output, database, and table. Rename keys and define primary keys.
```bash
python -m parcoursup.cli -i fr-esr-parcoursup.json -r acad_mies:academies g_olocalisation_des_formations:geolocalisation_des_formations -p cod_uai cod_aff_form
```

## 🎨 Command-Line Arguments

| Argument                      | Description                     |
|-------------------------------|---------------------------------|
| `-i, --input <path>`          | Path to the input `.json` file. |
| `-o, --output <path>`         | Path to the output `.sql` file. |
| `-d, --database`              | Name of the MySQL database.     |
| `-t, --table`                 | Name of the MySQL table.        |
| `-r, --rename`                | Rename keys. Use key:new_key.   |
| `-p, --primary`               | Primary keys.                   |

## 🐛 Bugs

Not yet found.

## ⛔ Known Limitations

Not yet known.

## 🤝 Contribution

Contributions, suggestions, and new ideas are heartily welcomed. If you're considering significant modifications, please initiate an issue for discussion before submitting a pull request.

## 📜 License

[![MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 💖 Support

[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/xamituchido)
[![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/inc44)
[![Patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white)](https://www.patreon.com/Inc44)