package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
)

func main() {
	file, err := ioutil.ReadFile("day02_input.txt")
	if err != nil {
		log.Fatalln(err.Error())
	}

	file_string := string(file)
	inputs := strings.Split(file_string, "\n")

	Solution01(inputs)
	Solution02(inputs)
}

func Solution01(inputs []string) {
	total_score := 0
	for _, game := range inputs {
		if game == "" {
			continue
		}

		result := 0
		moves := strings.Split(game, " ")

		opponent_move := GetMove(moves[0])
		player_move := GetMove(moves[1])

		move_point := GetMovePoints(player_move)
		result = Game(opponent_move, player_move)

		total_score += result + move_point
	}

	fmt.Println("Solution 01:", total_score)
}

func Solution02(inputs []string) {
	total_score := 0

	for _, game := range inputs {
		if game == "" {
			continue
		}

		result := 0
		moves := strings.Split(game, " ")
		opponent_move := GetMove(moves[0])

		player_move := GetExpectedMove(moves[1], opponent_move)
		move_point := GetMovePoints(player_move)

		result = Game(opponent_move, player_move)

		total_score += result + move_point
	}

	fmt.Println("Solution 02:", total_score)
}

func Game(opponent_move, player_move string) int {
	// Win  = 6
	// Lose = 0
	// Draw = 3

	result := 0
	if opponent_move == "Rock" {
		if player_move == "Paper" {
			result = 6
		} else if player_move == "Scissors" {
			result = 0
		} else {
			result = 3
		}
	}

	if opponent_move == "Paper" {
		if player_move == "Scissors" {
			result = 6
		} else if player_move == "Rock" {
			result = 0
		} else {
			result = 3
		}
	}

	if opponent_move == "Scissors" {
		if player_move == "Rock" {
			result = 6
		} else if player_move == "Paper" {
			result = 0
		} else {
			result = 3
		}
	}

	return result
}

func GetMovePoints(move string) int {
	point := 0
	switch move {
	case "Rock":
		point = 1
	case "Paper":
		point = 2
	case "Scissors":
		point = 3
	}
	return point
}

func GetMove(move string) string {
	label := ""
	if move == "X" || move == "A" {
		label = "Rock"
	}

	if move == "Y" || move == "B" {
		label = "Paper"
	}

	if move == "Z" || move == "C" {
		label = "Scissors"
	}

	return label
}

func GetExpectedMove(ExpectedResult string, opponent_move string) string {
	// X = Lose
	// Y = Draw
	// Z = Win

	player_move := ""

	if ExpectedResult == "X" {
		if opponent_move == "Rock" {
			player_move = "Scissors"
		}

		if opponent_move == "Paper" {
			player_move = "Rock"
		}

		if opponent_move == "Scissors" {
			player_move = "Paper"
		}
	}

	if ExpectedResult == "Y" {
		player_move = opponent_move
	}

	if ExpectedResult == "Z" {
		if opponent_move == "Scissors" {
			player_move = "Rock"
		}

		if opponent_move == "Paper" {
			player_move = "Scissors"
		}

		if opponent_move == "Rock" {
			player_move = "Paper"
		}
	}

	return player_move
}
