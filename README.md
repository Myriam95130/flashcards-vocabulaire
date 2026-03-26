# Flashcards Vocabulaire

## Les objectifs 

L’objectif de ce lexique est de mémoriser du vocabulaire complexe (ou pas) dans le but
d’enrichir et de diversifier son expression orale et écrite. Il s’agit, en grande partie,
d’expressions et de mots peu courants que l’on retrouve plutôt dans des ouvrages littéraires
ou scientifiques. Le vocabulaire a été recensé sur une période d’environ douze mois. 

Les mots ont été recensés au gré de mes lectures et notés. Il s’agissait le plus souvent de mots que je n’avais jamais vus ou entendus. J’entrais seulement les mots dans l’application notes de mon téléphone, sans forcément entrer leur définition ou leurs contextes d’occurrence. J’ai donc décidé, dans le cadre de ce projet, de reprendre tout le vocabulaire que j’ai pu recenser entre octobre 2022 et novembre 2023. Cela m’a permis de tout remettre au propre en intégrant les définitions, les contextes d’occurrences et les domaines concernés. 

N'oublions pas qu'un mot peut être polysémique et peut changer de sens en fonction des domaines scientifiques ou littéraires, d’où la colonne « contexte » dans le fichier .csv. Un mot peut également être synonyme d’un autre mot en fonction des contextes (cf la synonymie contextuelle) ; cela concerne le plus souvent les expressions et idiomes. Il est important pour un natif de maîtriser la synonymie contextuelle afin de domestiquer son discours. Nous enrichissons constamment notre vocabulaire et notre manière d’exprimer nos pensées évolue constamment au cours de notre vie.

## Les programmes 

Le programme se décompose en 3 partie : clean_session, generer_cartes et init_session. 

## clean_session : 

## Programme `clean_session.sh` 

Ce script sert à réinitialiser chaque session :

```bash
#!/bin/bash

# ./clean_session.sh

BOITES=4

for ((i=1; i<=BOITES; i++))
do
    rm session/$i/carte_*.md
done
```

## Programme `generer_cartes.sh`

Ce script lit un fichier CSV (séparé par `;`) et génère une carte `.md` par ligne, avec question et réponse :

```bash
#!/bin/bash

FICHIER="$1"
COMPTE=0
while read line
do
    COMPTE=$(expr $COMPTE + 1)
    CARTE="./cartes/carte_$COMPTE.md"
    MOT=$(    echo "$line" | cut -d \; -f 1 )
    CONTEXTE=$(  echo "$line" | cut -d \; -f 2 )
    DEFINITION=$(echo "$line" | cut -d \; -f 3 )
    EXEMPLE=$(   echo "$line" | cut -d \; -f 4 )
    echo "
-> # Question

$MOT

------

-> # Réponse

- Contexte    : $CONTEXTE
- Définition  : $DEFINITION
- Exemple     : $EXEMPLE
    " > "$CARTE"

    echo "$COMPTE -- $line"
done < "$FICHIER"
```

**Usage :** `./generer_cartes.sh fichier.csv`

## Programme `init_session.sh`

Ce script initialise une session en répartissant les cartes dans les boîtes, puis en déplaçant une sélection aléatoire vers le dossier session :

```bash
#!/bin/bash

# ./init_session.sh <fichier>
#        $0              $1

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
```

**Usage :** `./init_session.sh <fichier>`

