/* csv_join.go:
 *
 * An implementation of the UNIX join utility for CSV files. Written in Go for practice in the
 * language.
 */
package main

import (
	"encoding/csv"
	"fmt"
)

// Hash join, quick, memory-intensive.
func hash_join() {
	return
}

// Merge join, almost as quick as hash join, not memory-intensive.
func merge_join() {
	return
}

// Nested-loop join, simple and straightforward, very slow on large datasets.
func nested_join() {
	return
}

func main() {
	fmt.Println("csv_join")
}

// EOF.
