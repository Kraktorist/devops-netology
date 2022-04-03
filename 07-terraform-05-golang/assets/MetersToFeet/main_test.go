package main

import "testing"

func _fault(result, expected_result float64) float64 {
	return 100 * (result - expected_result) / expected_result
}

const max_fault float64 = 0.1 // in percents

func TestConvert_to_feet(t *testing.T) {
	result := convert_to_feet(1)
	expected_result := 3.28084
	if _fault(result, expected_result) > max_fault {
		t.Errorf("Expected %f +/-%f, got %f", expected_result, max_fault, result)
	}
}
