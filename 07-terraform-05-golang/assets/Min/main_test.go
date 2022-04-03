package main

import "testing"

func TestMin(t *testing.T) {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	expected_result := 9
	result := min(x)
	if result != expected_result {
		t.Errorf("Expected %v, got %v", expected_result, result)
	}
	x = []int{42, 57, 14, 28, -79, 90, -96, -57, -60, 83}
	expected_result = -96
	result = min(x)
	if result != expected_result {
		t.Errorf("Expected %v, got %v", expected_result, result)
	}
}
