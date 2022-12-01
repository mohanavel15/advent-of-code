package main

import (
	"io/ioutil"
	"log"
	"sort"
	"strconv"
	"strings"
)

func main() {
	file, err := ioutil.ReadFile("day01_input.txt")
	if err != nil {
		log.Fatalln(err.Error())
	}

	input := string(file)

	Solution01(input)
	Solution02(input)
}

func Solution01(input string) {
	ElfCalories := strings.Split(input, "\n\n")

	highest_calories := 0

	for _, elf_calories := range ElfCalories {
		total_calories := 0
		for _, calorie_str := range strings.Split(elf_calories, "\n") {
			calorie, _ := strconv.ParseInt(calorie_str, 10, 64)
			total_calories += int(calorie)
		}
		if total_calories > highest_calories {
			highest_calories = total_calories
		}
	}

	log.Println("Highest Calories:", highest_calories)
}

func Solution02(input string) {
	ElfCalories := strings.Split(input, "\n\n")

	elf := []int{}

	for _, elf_calories := range ElfCalories {
		total_calories := 0
		for _, calorie_str := range strings.Split(elf_calories, "\n") {
			calorie, _ := strconv.ParseInt(calorie_str, 10, 64)
			total_calories += int(calorie)
		}
		elf = append(elf, total_calories)
	}

	sort.Slice(elf, func(i, j int) bool {
		return elf[i] > elf[j]
	})

	log.Println("Total calories of top 3 Elfs:", elf[0]+elf[1]+elf[2])
}
