package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strconv"
	"strings"
)

func main() {
	file, err := ioutil.ReadFile("day04_input.txt")
	if err != nil {
		log.Fatalln(err.Error())
	}

	file_string := string(file)
	inputs := strings.Split(file_string, "\n")

	Solution01(inputs)
	Solution02(inputs)
}

func Solution01(inputs []string) {
	total_overlap := 0

	for _, input := range inputs {
		ranges := strings.Split(input, ",")

		var range_1_start, range_1_end, range_2_start, range_2_end int64

		range_1_start_stop := strings.Split(ranges[0], "-")
		range_1_start, _ = strconv.ParseInt(range_1_start_stop[0], 10, 64)
		range_1_end, _ = strconv.ParseInt(range_1_start_stop[1], 10, 64)

		range_2_start_stop := strings.Split(ranges[1], "-")
		range_2_start, _ = strconv.ParseInt(range_2_start_stop[0], 10, 64)
		range_2_end, _ = strconv.ParseInt(range_2_start_stop[1], 10, 64)

		if range_1_start <= range_2_start && range_1_end >= range_2_end {
			total_overlap += 1
		} else if range_2_start <= range_1_start && range_2_end >= range_1_end {
			total_overlap += 1
		}
	}

	fmt.Println("Total Overlap:", total_overlap)
}

func Solution02(inputs []string) {
	any_overlap := 0

	for _, input := range inputs {
		ranges := strings.Split(input, ",")

		var range_1_start, range_1_end, range_2_start, range_2_end int64

		range_1_start_stop := strings.Split(ranges[0], "-")
		range_1_start, _ = strconv.ParseInt(range_1_start_stop[0], 10, 64)
		range_1_end, _ = strconv.ParseInt(range_1_start_stop[1], 10, 64)

		range_2_start_stop := strings.Split(ranges[1], "-")
		range_2_start, _ = strconv.ParseInt(range_2_start_stop[0], 10, 64)
		range_2_end, _ = strconv.ParseInt(range_2_start_stop[1], 10, 64)

		if range_1_start <= range_2_start && range_1_end >= range_2_start {
			any_overlap += 1
		} else if range_2_start <= range_1_start && range_2_end >= range_1_start {
			any_overlap += 1
		}
	}

	fmt.Println("Any Overlap:", any_overlap)
}
