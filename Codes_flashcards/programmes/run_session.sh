#!/bin/bash

# ./run_session.sh <fichier>
#		$0				$1

FICHIER=$1
BOITES=4

# afficher toutes les cartes de la session
ls -R session/*

# parcourir les boîtes et démarrer la session
for ((i=1;i<=BOITES;i++))
do
	
	if [ $i -gt 2 ]; then
		echo 'Voulez-vous arrêter la session ? (o/n) ?'
		read answer
		if [ "$answer" == "o" ]; then 
			for ((j=1;j<=BOITES;j++))
			do
				eval rm session/$j/carte_*.md 2> /dev/null
			done
		        ./programmes/init_session.sh "$FICHIER"
			exit 0
		fi
	fi
	RESULTAT_SHUF=$(ls session/$i/ | shuf)
	for carte in $RESULTAT_SHUF
	do
		eval mdp session/$i/$carte
		
		echo 'Connaissez-vous ce mot ? (o/n) ?'
		read answer
		if [ "$answer" == "o" ]; then 
			if [ $i -lt 4 ]; then
				eval mv session/$i/$carte session/$(expr $i + 1)/$carte
			fi
		else
			if [ $i -gt 1 ]; then
				eval mv session/$i/$carte session/$(expr $i - 1)/$carte
			fi
		fi
	done
done

