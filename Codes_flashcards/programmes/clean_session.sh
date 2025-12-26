#!/bin/bash 

# ./clean_session.sh	

BOITES=4

for ((i=1; i<=BOITES; i++))
do
	rm session/$i/carte_*.md
done
