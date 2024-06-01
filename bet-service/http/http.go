package http

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

func ListenAndServe() {
	r := mux.NewRouter()

	r.Use(EnableCors)

	// Register HTTP subrouters
	bet := &betRouter{router: r, prefix: "/"}
	bet.initHandlers()

	// Listen & Serve HTTP requests
	fmt.Printf("🚀️ Starting bet service on port %s\n", os.Getenv("HTTP_PORT"))
	err := http.ListenAndServe(fmt.Sprintf(":%s", os.Getenv("HTTP_PORT")), r)
	if err != nil {
		log.Fatal(err)
	}
}
