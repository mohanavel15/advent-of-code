package main

import (
	"fmt"
	"log"
	"os"
	"strings"
)

func main() {
	file, err := os.ReadFile("day06_input.txt")
	if err != nil {
		log.Fatalln(err.Error())
	}

	input := string(file)

	Solution01(input)
	Solution02(input)
}

func Solution01(input string) {
	input_len := len(input)
	for i := range input {
		if input_len-i < 3 {
			break
		}

		last_index := i + 4

		marker := input[i:last_index]
		has_repeat := false

		for mi, r := range marker {
			if strings.IndexRune(marker[mi+1:], r) != -1 {
				has_repeat = true
				break
			}
		}

		if !has_repeat {
			fmt.Println("Answer 01:", last_index)
			break
		}
	}
}

func Solution02(input string) {
	input_len := len(input)
	for i := range input {
		if input_len-i < 3 {
			break
		}

		last_index := i + 14

		marker := input[i:last_index]
		has_repeat := false

		for mi, r := range marker {
			if strings.IndexRune(marker[mi+1:], r) != -1 {
				has_repeat = true
				break
			}
		}

		if !has_repeat {
			fmt.Println("Answer 02:", last_index)
			break
		}
	}
}
