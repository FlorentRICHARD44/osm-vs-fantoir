WITH
f
AS
(SELECT fantoir,'OUI' AS rapproche
	FROM cumul_adresses	WHERE insee_com = '__com__' AND voie_osm IS NOT NULL
UNION
SELECT fantoir,'OUI'
	FROM cumul_voies	WHERE insee_com = '__com__'
UNION
SELECT fantoir,'OUI'
	FROM cumul_places	WHERE insee_com = '__com__' AND libelle_osm IS NOT NULL
),
a
AS
(SELECT fantoir,'QUALIFIÉ'::text AS qualifie
FROM 	(SELECT	*,rank() OVER (PARTITION BY fantoir ORDER BY timestamp_statut DESC) rang
		FROM 	statut_fantoir
		WHERE	insee_com = '__com__')r
WHERE	rang = 1)
SELECT 	COALESCE(f.rapproche,a.qualifie,'NON'),
		fv.*
FROM	fantoir_voie fv
LEFT OUTER JOIN f
ON		fv.fantoir10 = f.fantoir
LEFT OUTER JOIN a
ON		fv.fantoir10 = a.fantoir
WHERE	code_insee = '__com__' AND
        caractere_annul != 'B'; -- Filtre sur les pseudo-Fantoir BAN