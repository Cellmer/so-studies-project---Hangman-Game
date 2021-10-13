#!/bin/bash

# Author           : Michał Cellmer - 184685( s184685@student.pg.edu.pl )
# Created On       : 26.04.2021
# Last Modified By : Michał Cellmer - 184685( s184685@student.pg.edu.pl )
# Last Modified On : 26.04.2021
# Version          : 1.0
#
# Description      : Gra w wisielca w języku polskim (więcej informacji w manualu)
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

# załącz plik z funckjami rysującymi wisielca
. drawingFunctions.rc


#kod jednej rozgrywki
game()
{
	password=$(shuf -n 1 $file) #hasło do odgadnięcia, wybierane jako losowe z wybranego pliku
	password=${password^^} #zamień na duże litery, żeby ułatwić w późniejszej analizie

	mistakes=0
	used="" #użyte przez użytkownika pasujące litery
	used_wrong="" #użyte przez użytkownika niepasujące litery
	while [[ $mistakes -le $MAX_MISTAKES ]]  #Pętla jednej rozgrywki
	do
		echo "KATEGORIA: $category"
		echo "Pozostało nieudanych prób: $((MAX_MISTAKES-mistakes))      Użyte litery: $used_wrong"
		draw$mistakes
		echo "                      $(echo "$password" | sed "s#[^$used ,;-]#_#g" | sed "s/ /  /g")" #wyświetla hasło z wszystkimi literami oprócz tych zapisanych w zmiennej used zamienionymi na podkreślniki
		#echo "$password"
		echo
		echo "Wpisz literę z polskiego alfabetu (wielkość nie ma znaczenia): "
		read letter
		letter=${letter^}
		found=$(echo "$password" | grep -c -i "$letter") #Jeśli 0 to litery nie znaleziono, jeśli 1 to znaleziono
		if [[ $found -eq 0 ]]
		then
			mistakes=$((mistakes+1))
			if [[ $(echo "$used_wrong" | grep -c "$letter") -eq 0 ]]; then
				used_wrong+="$letter, "
			fi
		else
			used+="$letter"
		fi
		
		end=$(echo "$password" | sed "s#[^$used ,;-]#_#g" | grep -c "_") #jeśli 0 to użytkownik odgadł hasło
		if [[ $end -eq 0 ]]
		then
			clear
			echo "BRAWO!!! ODGADŁEŚ HASŁO : $password"
			echo "Kliknij enter aby kontunować:"
			read
			break
		fi
		clear
	done
	
	if [[ $mistakes -gt $MAX_MISTAKES ]]
	then
		draw$((MAX_MISTAKES+1))
		echo "PRZEGRAŁEŚ!!!!"
		echo "Hasłem było: $password" 
		echo "Kliknij enter aby kontunować:"
		read
	fi
}

                           
##################################################################################################################################################################
#                                                      GŁÓWNY SKRYPT
##################################################################################################################################################################

MAX_MISTAKES=8
isOption=0

#Obsługa opcji
while getopts hvf: OPT; do
	case $OPT in
	h) isOption=1; man ./hangman.1 ;;
	v) echo "Wersja 1.1"; isOption=1 ;;
	f) file=$OPTARG; isOption=1; game ;;
	*) echo "Skrypt nie obsługuje takiej opcji!!!"; isOption=1; read ;;
	esac
done

#Pętla całęj gry (działa tylko jeśli nie było żadnych opcji)
if [[ $isOption -eq 0 ]]; then
	while [[ $opt != 5 ]]
	do
		clear
		echo "Wybierz kategorię lub zakończ grę!"
		echo "1) Filmy i seriale"
		echo "2) Muzyka"
		echo "3) Powiedzenia i przysłowia"
		echo "4) Zwierzęta"
		echo "5) Wyjdź z gry" 
		
		read opt

		case $opt in
		1) file="categories/film.txt" category="Filmy i seriale" ;;
		2) file="categories/music.txt" category="Muzyka";;
		3) file="categories/sayings.txt" category="Powiedzenia i przysłowia";;
		4) file="categories/animals.txt" category="Zwierzęta";;
   		5) break ;;
   		*) echo "Nieprawidłowa opcja!! Spróbuj jeszcze raz"; sleep 1.3; continue;;
		esac
	
		clear
	
		game
	
	done
fi












