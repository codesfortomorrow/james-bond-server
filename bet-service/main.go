package main

import (
	"bet-service/betdb"
	bethttp "bet-service/http"
	"bet-service/kafka"
)

func main() {
	// Connect database
	betdb.Connect()

	// Connect service as a consumer to kafka
	go func() {
		kafka.Connect()
	}()

	// Open Http server endpoints
	bethttp.ListenAndServe()
}
