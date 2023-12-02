#!/bin/bash
showBoard() {
    echo " ${board[1]} | ${board[2]} | ${board[3]} "
    echo "---+---+---"
    echo " ${board[4]} | ${board[5]} | ${board[6]} "
    echo "---+---+---"
    echo " ${board[7]} | ${board[8]} | ${board[9]} "
}
isWinner() {
    local currentPlayer=$1
    if [[ (${board[1]} == $currentPlayer && ${board[2]} == $currentPlayer && ${board[3]} == $currentPlayer) ||
          (${board[4]} == $currentPlayer && ${board[5]} == $currentPlayer && ${board[6]} == $currentPlayer) ||
          (${board[7]} == $currentPlayer && ${board[8]} == $currentPlayer && ${board[9]} == $currentPlayer) ||
          (${board[1]} == $currentPlayer && ${board[4]} == $currentPlayer && ${board[7]} == $currentPlayer) ||
          (${board[2]} == $currentPlayer && ${board[5]} == $currentPlayer && ${board[8]} == $currentPlayer) ||
          (${board[3]} == $currentPlayer && ${board[6]} == $currentPlayer && ${board[9]} == $currentPlayer) ||
          (${board[1]} == $currentPlayer && ${board[5]} == $currentPlayer && ${board[9]} == $currentPlayer) ||
          (${board[3]} == $currentPlayer && ${board[5]} == $currentPlayer && ${board[7]} == $currentPlayer) ]]; then
        echo "Wygrał gracz $currentPlayer!"
        echo "Ostateczny stan planszy:"
        showBoard
        echo "Naciśnij dowolny klawisz aby zakończyć: "
        read choice
        exit 0
    fi
}

declare -a board
for i in {1..9}; do
    board[$i]=" "
done

current_player="X"
while true; do
    clear
    showBoard
    echo "Ruch gracza $current_player. Podaj numer pola (1-9), zapisz grę (10), wczytaj poprzednią grę (11): "
    read choice
    if [[ $choice == 10 ]]; then
        printf "%s\n" "${board[@]}" > stan_planszy.txt
        echo "$current_player" >> stan_planszy.txt
        continue
    fi

    if [[ $choice == 11 ]]; then
        if [ -e stan_planszy.txt ]; then
            i=1
            while read -r line; do
                if [ $i -le 9 ]; then
                    board[$i]=$line
                    if [[ $line == "" ]]; then
                       board[$i]=" "
                    fi
                fi
                if [[ $i == 10 ]]; then
                    current_player=$line
                fi

                ((i++))
            done < stan_planszy.txt
            read -n1 currentPlayer < stan_planszy.txt
            echo "Wczytano stan planszy z pliku stan_planszy.txt. Ładowanie..."
            sleep 2
            continue
        else
            echo "Plik stan_planszy.txt nie istnieje."
            sleep 2
            continue
        fi
    fi

    if [[ ${board[$choice]} == " " && $choice -ge 1 && $choice -le 9 ]]; then
        board[$choice]=$current_player
        isWinner $current_player

        if ! [[ " ${board[*]} " =~ " " ]]; then
            echo "Remis!"
            exit 0
        fi

        # Zmiana gracza
        if [ $current_player == "X" ]; then
            current_player="O"
        else
            current_player="X"
        fi
    else
        echo "Coś zaszło nie tak, nie możesz dokonać tej akcji. Spróbuj ponownie."
        sleep 2
    fi
done