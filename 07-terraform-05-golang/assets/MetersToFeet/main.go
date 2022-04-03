package main

import "fmt"

func convert_to_feet(input float64) float64 {
	return input / 0.3048
}

func main() {
	fmt.Print("Enter length in meters: ")
	var input float64
	fmt.Scanf("%f", &input)
	output := convert_to_feet(input)
	fmt.Println("Length in feet:", output)
}
