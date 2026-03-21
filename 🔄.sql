USE parcoursup;
UPDATE
	parcoursup
SET
	dep = '56',
	dep_lib = 'Morbihan',
	ville_etab = 'Vannes'
WHERE
	ABS(geolocalisation_des_formations_lon - (-2.7463)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (47.6446)) < 0.0001;
UPDATE
	parcoursup
SET
	ville_etab = 'Talence'
WHERE
	ABS(geolocalisation_des_formations_lon - (-0.6)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (44.8167)) < 0.0001;
UPDATE
	parcoursup
SET
	dep = '78',
	dep_lib = 'Yvelines',
	academies = 'Versailles',
	ville_etab = 'Saint-Germain-en-Laye'
WHERE
	ABS(geolocalisation_des_formations_lon - (2.0698)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (48.9001)) < 0.0001;
UPDATE
	parcoursup
SET
	ville_etab = 'Puteaux'
WHERE
	ABS(geolocalisation_des_formations_lon - (2.2333)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (48.8667)) < 0.0001;
UPDATE
	parcoursup
SET
	dep = '92',
	dep_lib = 'Hauts-de-Seine',
	ville_etab = 'Issy-les-Moulineaux'
WHERE
	ABS(geolocalisation_des_formations_lon - (2.2757)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (48.8265)) < 0.0001;
UPDATE
	parcoursup
SET
	ville_etab = 'Lyon 7e  Arrondissement'
WHERE
	ABS(geolocalisation_des_formations_lon - (4.8362)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (45.7508)) < 0.0001;
UPDATE
	parcoursup
SET
	ville_etab = 'Bron'
WHERE
	ABS(geolocalisation_des_formations_lon - (4.9172)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (45.7216)) < 0.0001;
UPDATE
	parcoursup
SET
	dep = '54',
	dep_lib = 'Meurthe-et-Moselle',
	region_etab_aff = 'Grand Est',
	academies = 'Nancy-Metz',
	ville_etab = 'Nancy'
WHERE
	ABS(geolocalisation_des_formations_lon - (6.1803)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (48.6777)) < 0.0001;
UPDATE
	parcoursup
SET
	ville_etab = 'Strasbourg'
WHERE
	ABS(geolocalisation_des_formations_lon - (7.75)) < 0.0001
	AND ABS(geolocalisation_des_formations_lat - (48.5833)) < 0.0001;