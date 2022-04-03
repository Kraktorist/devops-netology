package main

import "fmt"

func min(x []int) int {
	var min_elem int = x[0]
	for _, elem := range x {
		if min_elem > elem {
			min_elem = elem
		}
	}
	return min_elem
}

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	fmt.Printf("Array: %v\n", x)
	min_elem := min(x)
	fmt.Println("Minimal element is:", min_elem)
}
