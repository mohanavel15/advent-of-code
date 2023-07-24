package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, err := os.ReadFile("day08_input.txt")
	if err != nil {
		log.Fatalln(err.Error())
	}

	file_string := string(file)
	inputs := strings.Split(file_string, "\n")

	Solution(inputs)
}

func Solution(inputs []string) {
	trees_grid := [][]int{}
	for _, line := range inputs {
		trees := []int{}
		for _, rune_height := range line {
			tree, _ := strconv.Atoi(string(rune_height))
			trees = append(trees, tree)
		}
		trees_grid = append(trees_grid, trees)
	}

	visible_trees := 0
	highest_score := 0

	for x := 0; x < len(trees_grid); x++ {
		for y := 0; y < len(trees_grid[0]); y++ {
			visible, score := CheckTree(x, y, trees_grid)
			if visible {
				visible_trees += 1
			}

			if score > highest_score {
				highest_score = score
			}
		}
	}

	fmt.Println("Answer 01:", visible_trees)
	fmt.Println("Answer 02:", highest_score)
}

func CheckTree(x int, y int, trees_grid [][]int) (bool, int) {
	if x == 0 || x == len(trees_grid)-1 || y == 0 || y == len(trees_grid[0])-1 {
		return true, 0
	}

	tree := trees_grid[x][y]

	top_visible := true
	top_score := 0
	for nx := x - 1; nx > -1; nx-- {
		top_score += 1
		if trees_grid[nx][y] >= tree {
			top_visible = false
			break
		}
	}

	bottom_visible := true
	bottom_score := 0
	for nx := x + 1; nx < len(trees_grid); nx++ {
		bottom_score += 1
		if trees_grid[nx][y] >= tree {
			bottom_visible = false
			break
		}
	}

	left_visible := true
	left_score := 0
	for ny := y - 1; ny > -1; ny-- {
		left_score += 1
		if trees_grid[x][ny] >= tree {
			left_visible = false
			break
		}
	}

	right_visible := true
	right_score := 0
	for ny := y + 1; ny < len(trees_grid); ny++ {
		right_score += 1
		if trees_grid[x][ny] >= tree {
			right_visible = false
			break
		}
	}

	return top_visible || bottom_visible || left_visible || right_visible, top_score * bottom_score * left_score * right_score
}
