package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
)

func main() {
	file, err := ioutil.ReadFile("day03_input.txt")
	if err != nil {
		log.Fatalln(err.Error())
	}

	file_string := string(file)
	inputs := strings.Split(file_string, "\n")

	Solution01(inputs)
	Solution02(inputs)
}

func Solution01(inputs []string) {
	MatchingLetters := []string{}

	for _, item := range inputs {
		if item == "" {
			continue
		}

		length := len(item)
		half_length := length / 2

		first_half := item[:half_length]
		second_half := item[half_length:]

		for _, letter := range first_half {
			match := strings.Contains(second_half, string(letter))
			if match {
				MatchingLetters = append(MatchingLetters, string(letter))
				break
			}
		}
	}

	fmt.Println(GetSumOfPriority(MatchingLetters))
}

func Solution02(inputs []string) {
	Badges := []string{}
	pointer := 0

	for pointer < len(inputs) {
		item := inputs[pointer]

		for _, letter := range item {
			match1 := strings.Contains(inputs[pointer+1], string(letter))
			match2 := strings.Contains(inputs[pointer+2], string(letter))
			if match1 && match2 {
				Badges = append(Badges, string(letter))
				break
			}
		}

		pointer += 3
	}

	fmt.Println(GetSumOfPriority(Badges))
}

func GetSumOfPriority(priorities []string) int {
	SumOfPriority := 0
	Alphabets := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

	for _, letter := range priorities {
		SumOfPriority += strings.Index(Alphabets, letter) + 1
	}

	return SumOfPriority
}
