package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, err := os.ReadFile("day05_input.txt")
	if err != nil {
		log.Fatalln(err.Error())
	}

	file_string := string(file)
	inputs := strings.Split(file_string, "\n")

	Solution01(inputs)
	Solution02(inputs)
}

func Solution01(inputs []string) {
	IsInstruction := false
	crates := map[string][]string{}

	for _, line := range inputs {
		if line == "" {
			IsInstruction = true
			continue
		}

		if !IsInstruction {
			length := len(line)
			line_crates := []string{}
			for i := 0; i < length; i += 4 {
				line_crates = append(line_crates, line[i:i+3])
			}

			for index, crate := range line_crates {
				key := fmt.Sprint(index + 1)
				if len(strings.TrimSpace(crate)) == 3 {
					crates[key] = append(crates[key], crate)
				}
			}
		}

		if IsInstruction {
			Instruction := strings.Split(line, " ")
			number_of_crates, _ := strconv.ParseInt(Instruction[1], 10, 64)
			from := Instruction[3]
			to := Instruction[5]

			to_move := []string{}
			to_move = append(to_move, crates[from][:number_of_crates]...)

			for i, j := 0, len(to_move)-1; i < j; i, j = i+1, j-1 {
				to_move[i], to_move[j] = to_move[j], to_move[i]
			}

			to_move = append(to_move, crates[to]...)

			crates[from] = crates[from][number_of_crates:]
			crates[to] = to_move
		}
	}

	answer := ""

	keys := make([]string, 0, len(crates))
	for k := range crates {
		keys = append(keys, k)
	}

	for i := 0; i < len(keys); i++ {
		crate_id := crates[fmt.Sprint(i+1)][0]
		crate_id = strings.Trim(crate_id, "[")
		crate_id = strings.Trim(crate_id, "]")
		answer += crate_id
	}

	fmt.Println("Answer 1:", answer)
}

func Solution02(inputs []string) {
	IsInstruction := false
	crates := map[string][]string{}

	for _, line := range inputs {
		if line == "" {
			IsInstruction = true
			continue
		}

		if !IsInstruction {
			length := len(line)
			line_crates := []string{}
			for i := 0; i < length; i += 4 {
				line_crates = append(line_crates, line[i:i+3])
			}

			for index, crate := range line_crates {
				key := fmt.Sprint(index + 1)
				if len(strings.TrimSpace(crate)) == 3 {
					crates[key] = append(crates[key], crate)
				}
			}
		}

		if IsInstruction {
			Instruction := strings.Split(line, " ")
			number_of_crates, _ := strconv.ParseInt(Instruction[1], 10, 64)
			from := Instruction[3]
			to := Instruction[5]

			to_move := []string{}
			to_move = append(to_move, crates[from][:number_of_crates]...)
			to_move = append(to_move, crates[to]...)

			crates[from] = crates[from][number_of_crates:]
			crates[to] = to_move
		}
	}

	answer := ""

	keys := make([]string, 0, len(crates))
	for k := range crates {
		keys = append(keys, k)
	}

	for i := 0; i < len(keys); i++ {
		crate_id := crates[fmt.Sprint(i+1)][0]
		crate_id = strings.Trim(crate_id, "[")
		crate_id = strings.Trim(crate_id, "]")
		answer += crate_id
	}

	fmt.Println("Answer 2:", answer)
}
