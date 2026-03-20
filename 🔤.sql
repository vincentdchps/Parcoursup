USE parcoursup;
UPDATE
	parcoursup
SET
	dep_lib = CASE
		WHEN dep = '2A' THEN 'Corse-du-Sud'
		ELSE dep_lib
	END,
	region_etab_aff = CASE
		WHEN region_etab_aff IN ('Centre', 'Centre-Val de Loire') THEN 'Centre-Val de Loire'
		WHEN region_etab_aff IN ('Grand Est', 'Grand-Est') THEN 'Grand Est'
		WHEN region_etab_aff IN ('Guadeloupe', 'Saint-Martin') THEN 'Guadeloupe'
		WHEN region_etab_aff IN ('La Réunion', 'Réunion') THEN 'La Réunion'
		WHEN region_etab_aff IN ('Nouvelle Aquitaine', 'Nouvelle-Aquitaine') THEN 'Nouvelle-Aquitaine'
		WHEN region_etab_aff IN ('Pays de la Loire', 'Pays-de-la-Loire') THEN 'Pays de la Loire'
		WHEN region_etab_aff IN (
			'Provence Alpes Côte d''Azur',
			'Provence-Alpes-Côte d''Azur',
			'Provence-Alpes-Côte d’Azur'
		) THEN 'Provence-Alpes-Côte d''Azur'
		ELSE region_etab_aff
	END;