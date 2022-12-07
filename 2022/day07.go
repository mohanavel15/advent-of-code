package main

import (
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	file, err := os.ReadFile("day07_input.txt")
	if err != nil {
		log.Fatalln(err.Error())
	}

	file_string := string(file)
	inputs := strings.Split(file_string, "\n")

	Solution(inputs)
}

func Solution(inputs []string) {
	dirs := map[string]int{}
	total_size := 0
	var location = []string{"/"}

	for _, line := range inputs {
		cmds := strings.Split(line, " ")
		if cmds[0] == "$" {
			if cmds[1] == "cd" {
				if cmds[2] == ".." {
					location = location[:len(location)-1]
				} else if cmds[2] == "/" {
					location = []string{"/"}
				} else {
					location = append(location, cmds[2])
				}
			}

			continue
		}

		if cmds[0] != "dir" {
			file_size, _ := strconv.Atoi(cmds[0])
			for i := 0; i <= len(location); i++ {
				dirs[strings.Join(location[:len(location)-i], "-")] += file_size
			}
		}
	}

	for _, dir_size := range dirs {
		if dir_size <= 100000 {
			total_size += dir_size
		}
	}

	fmt.Println("Answer 01:", total_size)

	available := 70000000 - dirs["/"]
	need_space := 30000000 - available

	deletable := []int{}
	for _, dir_size := range dirs {
		if dir_size > need_space {
			deletable = append(deletable, dir_size)
		}
	}

	sort.Ints(deletable)
	fmt.Println("Answer 02:", deletable[0])
}
