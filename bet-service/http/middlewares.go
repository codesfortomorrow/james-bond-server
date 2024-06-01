package http

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"strings"

	"github.com/golang-jwt/jwt/v4"
)

type ReqCtxKey string

func AuthenticateSession(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		bearerHeader := r.Header.Get("authorization")
		if bearerHeader != "" {
			if headerSlices := strings.Split(bearerHeader, " "); len(headerSlices) > 1 {
				token, err := jwt.Parse(headerSlices[1], func(token *jwt.Token) (interface{}, error) {
					if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
						return nil, fmt.Errorf("UNEXPECTED SIGNING METHOD: %v", token.Header["alg"])
					}
					return []byte(os.Getenv("JWT_TOKEN_SECRET")), nil
				})

				if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
					// Extend http request pointer with jwt payload
					ctx := context.WithValue(r.Context(), ReqCtxKey("_uid"), claims["_uid"])
					ctx = context.WithValue(ctx, ReqCtxKey("_level"), claims["_level"])
					ctx = context.WithValue(ctx, ReqCtxKey("_path"), claims["_path"])
					ctx = context.WithValue(ctx, ReqCtxKey("_status"), claims["_status"])
					ctx = context.WithValue(ctx, ReqCtxKey("_privileges"), claims["_privileges"])
					ctx = context.WithValue(ctx, ReqCtxKey("_ut"), claims["_ut"])
					ctx = context.WithValue(ctx, ReqCtxKey("_transactionCode"), claims["_transactionCode"])

					next.ServeHTTP(w, r.WithContext(ctx))
				} else {
					http.Error(w, err.Error(), http.StatusForbidden)
				}
			} else {
				http.Error(w, "Forbidden", http.StatusForbidden)
			}
		} else {
			http.Error(w, "Forbidden", http.StatusForbidden)
		}
	})
}

func EnableCors(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")

		if r.Method == "OPTIONS" {
			return
		}
		next.ServeHTTP(w, r)
	})
}
