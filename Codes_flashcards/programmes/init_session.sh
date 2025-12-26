#!/bin/bash

# ./init_session.sh <fichier>
#		$0				$1

FICHIER=$1
BOITES=4
LIGNES=0

# détermination du nombre de cartes
while read line
do
	LIGNES=$(expr $LIGNES + 1)
done < "$FICHIER"

CARTES=$(expr $LIGNES - 1)
DIV_CARTES=$(expr $CARTES / $BOITES)
RESTE_CARTES=$(expr $CARTES % $BOITES)

# remplissage des boîtes
INITIAL=2
for ((i=1; i<BOITES; i++))
do
    eval cp ./cartes/carte_{$INITIAL..$(expr $INITIAL + $DIV_CARTES - 1)}.md boites/$i/
    INITIAL=$(expr $INITIAL + $DIV_CARTES)
done
eval cp cartes/carte_{$INITIAL..$(expr $INITIAL + $DIV_CARTES + $RESTE_CARTES - 1)}.md boites/$BOITES/

# remplissage du dossier session
for ((i=1; i<=BOITES; i++))
do
    cd boites/$i/
    eval mv $(ls | shuf | head -n $(expr $BOITES - $i + 1)) ../../session/$i/
    cd ../../
done

