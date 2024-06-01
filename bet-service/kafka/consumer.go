package kafka

import (
	"bet-service/bet"
	"encoding/json"
	"fmt"
	"log"
	"os"
	// "strings"

	"github.com/confluentinc/confluent-kafka-go/kafka"
)

func Connect() {
	c, err := kafka.NewConsumer(&kafka.ConfigMap{
		"bootstrap.servers":               "kafka:9092",
		"group.id":                        os.Getenv("KAFKA_GROUP_ID"),
		"go.application.rebalance.enable": true,
	})

	if err != nil {
		log.Fatal(err)
	}

	subscribeTopics := []string{
		"cricket-market-result",
		"soccer-market-result",
		"tennis-market-result",
		// "casino-aaa-result",
		// "casino-lucky7b-result",
		// "casino-teenpatti20-result",
	}

	err = c.SubscribeTopics(subscribeTopics, nil)
	if err != nil {
		log.Fatal(err)
	}

	for {
		msg, err := c.ReadMessage(-1)
		if err != nil {
			// The client will automatically try to recover from all errors.
			fmt.Printf("Consumer error: %v\n", err)
			continue
		}

		// fmt.Printf("Message on %s: %s\n", msg.TopicPartition, string(msg.Value))

		// if strings.Contains(*msg.TopicPartition.Topic, "casino") {
		// 	var payload struct {
		// 		MarketId float64 `json:"marketId"`
		// 		Result   uint32  `json:"result"`
		// 		Casino   string  `json:"casino"`
		// 	}

		// 	if err := json.Unmarshal(msg.Value, &payload); err != nil {
		// 		fmt.Printf("Error: %s\n", err.Error())
		// 		continue
		// 	}

		// 	bet.CasinoResolver(payload.Casino, payload.MarketId, payload.Result)
		// 	continue
		// }

		var payload struct {
			GameId      uint32   `json:"gameId"`
			EventId     uint32   `json:"eventId"`
			MarketId    string  `json:"marketId"`
			SelectionId string   `json:"selectionId"`
			Market      string   `json:"market"`
			GameType    string   `json:"gameType"`
			Status      *string  `json:"status,omitempty"`
			Result      *float32 `json:"result,omitempty"`
		}

		if err := json.Unmarshal(msg.Value, &payload); err != nil {
			fmt.Printf("Error: %s\n", err.Error())
			continue
		}
		
// 		fmt.Printf("GameId: %d\n", payload.GameId) 
// fmt.Printf("EventId: %d\n", payload.EventId)
// fmt.Printf("MarketId: %s\n", payload.MarketId)
// fmt.Printf("SelectionId: %s\n", payload.SelectionId)
// fmt.Printf("Market: %s\n", payload.Market)
// fmt.Printf("GameType: %s\n", payload.GameType)
if payload.Status != nil {
    fmt.Printf("Status: %s\n", *payload.Status)
} else {
    fmt.Println("Status is nil")
}

		bet.Resolver(payload.GameId, payload.EventId, payload.MarketId, payload.SelectionId, payload.Market, payload.GameType, payload.Status, payload.Result)
	}
}
