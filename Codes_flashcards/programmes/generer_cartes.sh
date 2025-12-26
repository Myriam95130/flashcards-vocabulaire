#!/bin/bash

FICHIER="$1"
COMPTE=0
while read line
do
	COMPTE=$(expr $COMPTE + 1)
	CARTE="./cartes/carte_$COMPTE.md"
	MOT=$( echo "$line"  | cut -d \; -f 1  )
	CONTEXTE=$( echo "$line"  | cut -d \; -f 2  )
	DEFINITION=$( echo "$line"  | cut -d \; -f 3  )
	EXEMPLE=$( echo "$line"  | cut -d \; -f 4  )
	echo "
-> # Question

$MOT

-----

-> # Réponse
	
- Contexte   : $CONTEXTE
- Définition : $DEFINITION
- Exemple     : $EXEMPLE
	" > "$CARTE"

	echo "$COMPTE -- $line"
done < "$FICHIER"
