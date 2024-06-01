package http

import (
	"bet-service/bet"
	"bet-service/betdb"
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

type betRouter struct {
	router *mux.Router
	prefix string
}

// Registers the HTTP handlers for the "/" prefix
func (b *betRouter) initHandlers() {
	s := b.router.PathPrefix("/").Subrouter()
	s.Use(AuthenticateSession)

	s.HandleFunc("/place", b.PlaceBet).Methods(http.MethodPost, http.MethodOptions)
	// s.HandleFunc("/casino/place", b.PlaceCasinoBet).Methods(http.MethodPost, http.MethodOptions)
	s.HandleFunc("/current-list", b.CurrentBetList).Methods(http.MethodGet, http.MethodOptions)
	s.HandleFunc("/casino/current-list", b.CasinoCurrentBetList).Methods(http.MethodGet, http.MethodOptions)
	s.HandleFunc("/all-userbet",b.AllUserBet).Methods(http.MethodGet, http.MethodOptions)
	s.HandleFunc("/user-particulerselectionbets", b.ParticulerSelectionbet).Methods(http.MethodGet, http.MethodOptions)
	s.HandleFunc("/user-particulerbets", b.Particulerbets).Methods(http.MethodGet, http.MethodOptions)
	s.HandleFunc("/get-past-currentbets", b.PastCurrentBets).Methods(http.MethodGet, http.MethodOptions)
	// Manual testing endpoints
	s.HandleFunc("/settle", b.SettleBet).Methods(http.MethodPost, http.MethodOptions)
}

func (b *betRouter) PlaceBet(w http.ResponseWriter, r *http.Request) {
	var body struct {
		BetOn       string  `json:"betOn"`
		Price       float32 `json:"price"`
		Stake       float64 `json:"stake"`
		EventType   string  `json:"eventType"`
		Competition string  `json:"competition"`
		Event       string  `json:"event"`
		Market      string  `json:"market"`
		Selection   string  `json:"selection"`
		CalcFact    uint8   `json:"calcFact"`
		Percent     float32 `json:"percent"`
		GameId      uint32  `json:"gameId"`
		EventId     uint32  `json:"eventId"`
		MarketId    string `json:"marketId"`
		SelectionId string  `json:"selectionId"`
		GameType    string  `json:"gameType"`
	}
	// http.Error(w, "server under working ", http.StatusBadRequest)
	// return
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	if r.Context().Value(ReqCtxKey("_ut")) != "USER" {
		http.Error(w, "You are not authorized to place bet", http.StatusBadRequest)
		return
	}

	if body.BetOn != "BACK" && body.BetOn != "LAY" {
		http.Error(w, "Bet should be BACK or LAY", http.StatusBadRequest)
		return
	}

	if isOk, err := bet.ValidateBetStake(body.Stake, body.CalcFact,body.GameId); !isOk {
		http.Error(w, err, http.StatusNotAcceptable)
		return
	}

	if true {
		code, response, err := bet.GetUserLocks(r.Context().Value(ReqCtxKey("_uid")))
		if err != nil {
			http.Error(w, err.Error(), code)
			return
		}

		if code != 200 {
			http.Error(w, string(*response), code)
			return
		}

		var locks struct {
			Lock    bool `json:"lock"`
			BetLock bool `json:"betLock"`
		}

		if err := json.Unmarshal(*response, &locks); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		if locks.Lock {
			http.Error(w, "Your account is locked", http.StatusUnprocessableEntity)
			return
		}

		if locks.BetLock {
			http.Error(w, "You can not place bet due to bet lock", http.StatusUnprocessableEntity)
			return
		}
	}

	// if body.CalcFact == 1 && body.GameId == 4 {
	// 	code, response, err := bet.IsSessionProcessable(body.EventId, body.MarketId, body.SelectionId)
	// 	if err != nil {
	// 		http.Error(w, err.Error(), code)
	// 		return
	// 	}

	// 	if code == 204 {
	// 		http.Error(w, "Bet not allowed on this session, Please try after sometime", http.StatusUnprocessableEntity)
	// 		return
	// 	}

	// 	if code != 200 {
	// 		http.Error(w, string(*response), code)
	// 		return
	// 	}
	// }
	fmt.Println("Price1:",body.Price)
	if true {
		code, response, err := bet.ValidateBetPlacement(body.Market, body.GameType, body.EventType, body.BetOn, body.EventId, body.SelectionId, body.Price, body.Percent)
		if err != nil {
			http.Error(w, err.Error(), code)
			return
		}
		if code != 200 {
			http.Error(w, string(*response), code)
			return
		}

		var responseData struct{ Price float32 }

		if err := json.Unmarshal(*response, &responseData); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		fmt.Println("responseData.Price:",responseData.Price)
		body.Price = responseData.Price
	}

	var (
		bets                  *[]bet.Bet
		err                   error
		prevSelectionExposure = 0.00
		selectionExposure     = bet.GetSelectionExposure(body.Market, body.BetOn, body.Stake, body.Price, body.Percent, body.CalcFact)
	)

	if body.CalcFact == 1 {
		bets, err = bet.GetSelectionBets(r.Context().Value(ReqCtxKey("_uid")), body.EventId, body.MarketId, body.SelectionId, body.Market, body.GameType)
	} else {
		bets, err = bet.GetMarketBets(r.Context().Value(ReqCtxKey("_uid")), body.EventId, body.MarketId, body.Market, body.GameType)
	}

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if len(*bets) > 0 {
		currentBet := &bet.Bet{BetOn: body.BetOn, Price: body.Price, Stake: body.Stake, Percent: body.Percent, SelectionId: body.SelectionId}
		prevSelectionExposure, selectionExposure = bet.CurrentBetExposure(bets, currentBet, body.Market, body.CalcFact)
	}

	fmt.Println("prevSelectionExposure", prevSelectionExposure, "selectionExposure", selectionExposure)

	if true {
		code, response, err := bet.UpdateUserExposure("BET", r.Context().Value(ReqCtxKey("_uid")), prevSelectionExposure, selectionExposure)
		if err != nil {
			http.Error(w, err.Error(), code)
			return
		}
		if code != 200 {
			http.Error(w, string(*response), code)
			return
		}

		var user struct {
			Username string `json:"username"`
		}

		if true {
			authorization := r.Header.Get("authorization")

			code, response, err := bet.GetUserDetails(&authorization)
			if err != nil {
				http.Error(w, err.Error(), code)
				return
			}
			if code != 200 {
				http.Error(w, string(*response), code)
				return
			}

			if err := json.Unmarshal(*response, &user); err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
		}

		if err := bet.PlaceBet(r.Context().Value(ReqCtxKey("_uid")), r.Context().Value(ReqCtxKey("_path")), user.Username, body.BetOn, body.EventType, body.Competition, body.Event, body.Market, body.GameType, body.Selection, body.Price, body.Percent, body.Stake, body.CalcFact, body.GameId, body.EventId, body.SelectionId, body.MarketId); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		} else {
			w.Write([]byte("Success"))
		}
	}
}

// func (b *betRouter) PlaceCasinoBet(w http.ResponseWriter, r *http.Request) {
// 	var body struct {
// 		Casino      string  `json:"casino"`
// 		BetOn       string  `json:"betOn"`
// 		Rate        float32 `json:"rate"`
// 		Stake       float64 `json:"stake"`
// 		Nation      string  `json:"nation"`
// 		MarketId    float64 `json:"marketId"`
// 		SelectionId string  `json:"selectionId"`
// 		GameType    string  `json:"gameType"`
// 	}

// 	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
// 		http.Error(w, err.Error(), http.StatusBadRequest)
// 		return
// 	}

// 	if r.Context().Value(ReqCtxKey("_ut")) != "USER" {
// 		http.Error(w, "You are not authorized to place bet", http.StatusBadRequest)
// 		return
// 	}

// 	if body.BetOn != "BACK" && body.BetOn != "LAY" {
// 		http.Error(w, "Bet should be BACK or LAY", http.StatusBadRequest)
// 		return
// 	}

// 	if isOk, err := bet.ValidateBetStake(body.Stake, 0); !isOk {
// 		http.Error(w, err, http.StatusNotAcceptable)
// 		return
// 	}

// 	if true {
// 		code, response, err := bet.GetUserLocks(r.Context().Value(ReqCtxKey("_uid")))
// 		if err != nil {
// 			http.Error(w, err.Error(), code)
// 			return
// 		}

// 		if code != 200 {
// 			http.Error(w, string(*response), code)
// 			return
// 		}

// 		var locks struct {
// 			Lock    bool `json:"lock"`
// 			BetLock bool `json:"betLock"`
// 		}

// 		if err := json.Unmarshal(*response, &locks); err != nil {
// 			http.Error(w, err.Error(), http.StatusInternalServerError)
// 			return
// 		}

// 		if locks.Lock {
// 			http.Error(w, "Your account is locked", http.StatusUnprocessableEntity)
// 			return
// 		}

// 		if locks.BetLock {
// 			http.Error(w, "You can not place bet due to bet lock", http.StatusUnprocessableEntity)
// 			return
// 		}
// 	}

// 	var selectionExposure = bet.GetSelectionExposure(body.Casino, body.BetOn, body.Stake, body.Rate, 100, 0)

// 	if true {
// 		code, response, err := bet.UpdateUserExposure("BET", r.Context().Value(ReqCtxKey("_uid")), 0, selectionExposure)
// 		if err != nil {
// 			http.Error(w, err.Error(), code)
// 			return
// 		}
// 		if code != 200 {
// 			http.Error(w, string(*response), code)
// 			return
// 		}

// 		if err := bet.PlaceCasinoBet(r.Context().Value(ReqCtxKey("_uid")), body.Casino, body.BetOn, body.Nation, body.GameType, body.Rate, body.Stake, body.SelectionId, body.MarketId); err != nil {
// 			http.Error(w, err.Error(), http.StatusInternalServerError)
// 			return
// 		} else {
// 			w.Write([]byte("Success"))
// 		}
// 	}
// }
func (b *betRouter) AllUserBet(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()

	offset := query.Get("offset")
	limit := query.Get("limit")
	
	sports := query.Get("sports")
	startDateStr := query.Get("startdate")
	endDateStr := query.Get("enddate")
	status := query.Get("status")

	startDate, err := time.Parse("2006-01-02", startDateStr)
	if err != nil {
		http.Error(w, "Invalid start date format", http.StatusBadRequest)
		return
	}

	endDate, err := time.Parse("2006-01-02", endDateStr)
	if err != nil {
		http.Error(w, "Invalid end date format", http.StatusBadRequest)
		return
	}

	
	uid := r.Context().Value(ReqCtxKey("_uid")).(float64)
    

	if len(offset) == 0 {
		offset = "0"
	}

	if len(limit) == 0 {
		limit = "10"
	}

	type bet struct {
		Id          uint      `json:"id"`
		Username    *string   `json:"username,omitempty"`
		BetOn       string    `json:"bet_on"`
		Price       float32   `json:"price"`
		Stake       float64   `json:"stake"`
		EventType   string    `json:"event_type"`
		Competition string    `json:"competition"`
		Event       string    `json:"event"`
		Market      string    `json:"market"`
		GameType    string    `json:"game_type"`
		Selection   string    `json:"selection"`
		CalcFact    uint8     `json:"calc_fact"`
		GameId      uint32    `json:"game_id"`
		EventId     uint32    `json:"event_id"`
		MarketId    float64   `json:"market_id"`
		SelectionId string    `json:"selection_id"`
		Percent     float32   `json:"percent"`
		CreatedAt   time.Time `json:"created_at"`
		Path        string    `json:"path"`
		userid      uint       `json:"user_id"`
		Status      int64       `json:"status"`
		UpdatedAt   time.Time `json:"updated_at"`
		
		
	
	}

	var (
		bets        []bet
		totalBets   uint
	
	)

	// fetch all placed bets of user with filter and pagination
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		var sqlStatement string
		if status != "0"{
			sqlStatement = "SELECT id, username, bet_on, price, stake, event_type, competition, event, market, game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, percent, created_at, path, user_id, status, updated_at FROM bets WHERE game_id = $1 AND user_id != $2 AND path ~ $3 AND created_at >= $4 AND updated_at <= $5 AND status != 0 ORDER BY id DESC OFFSET $6 ROWS FETCH NEXT $7 ROWS ONLY"
			rows, err = betdb.DB.Query(sqlStatement, sports, uid, (fmt.Sprintf("%v", r.Context().Value(ReqCtxKey("_path")))+".*"), startDate, endDate, offset, limit)
		} else {
			sqlStatement = "SELECT id, username, bet_on, price, stake, event_type, competition, event, market, game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, percent, created_at, path, user_id, status, updated_at FROM bets WHERE user_id != $1 AND path ~ $2 AND created_at >= $3 AND updated_at <= $4 AND status = 0 AND game_id = $5  ORDER BY id DESC OFFSET $6 ROWS FETCH NEXT $7 ROWS ONLY"
	
			rows, err = betdb.DB.Query(sqlStatement, uid, (fmt.Sprintf("%v", r.Context().Value(ReqCtxKey("_path")))+".*"), startDate, endDate,sports, offset, limit)
		}

		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			var bet bet
			err := rows.Scan(
				&bet.Id,
				&bet.Username,
				&bet.BetOn,
				&bet.Price,
				&bet.Stake,
				&bet.EventType,
				&bet.Competition,
				&bet.Event,
				&bet.Market,
				&bet.GameType,
				&bet.Selection,
				&bet.CalcFact,
				&bet.GameId,
				&bet.EventId,
				&bet.MarketId,
				&bet.SelectionId,
				&bet.Percent,
				&bet.CreatedAt,
				&bet.Path,
				&bet.userid,
				&bet.Status,
				&bet.UpdatedAt,
			)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			bets = append(bets[:], bet)
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	// fetch placed bets count & amount
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		if status != "0" {
			sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets FROM bets WHERE game_id = $1 AND user_id != $2 AND path ~ $3 AND created_at >= $4 AND created_at <= $5 AND status !=0"
			rows, err = betdb.DB.Query(sqlStatement, sports, uid, (fmt.Sprintf("%v", r.Context().Value(ReqCtxKey("_path")))+".*"), startDate, endDate)
		} else {
			sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets FROM bets WHERE user_id != $1 AND path ~ $2 AND created_at >= $3 AND created_at <= $4 AND status = 0 AND game_id = $5"
			rows, err = betdb.DB.Query(sqlStatement, uid, (fmt.Sprintf("%v", r.Context().Value(ReqCtxKey("_path")))+".*"), startDate, endDate,sports)
		}
	
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			err := rows.Scan(&totalBets)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"bets": bets, "total_bets": totalBets})
}

func (b *betRouter) PastCurrentBets(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()

	offset := query.Get("offset")
	limit := query.Get("limit")
	
	startDateStr := query.Get("startdate")
	endDateStr := query.Get("enddate")
	status := query.Get("status")
	// fmt.Println("Parsed Start Date:",startDateStr)

	startDate, err := time.Parse("2006-01-02", startDateStr)
	if err != nil {
		http.Error(w, "Invalid start date format", http.StatusBadRequest)
		return
	}

	endDate, err := time.Parse("2006-01-02", endDateStr)
	if err != nil {
		http.Error(w, "Invalid end date format", http.StatusBadRequest)
		return
	}

	
	uid := r.Context().Value(ReqCtxKey("_uid")).(float64)
    

	if len(offset) == 0 {
		offset = "0"
	}

	if len(limit) == 0 {
		limit = "10"
	}

	type bet struct {
		Id          uint      `json:"id"`
		Username    *string   `json:"username,omitempty"`
		BetOn       string    `json:"bet_on"`
		Price       float32   `json:"price"`
		Stake       float64   `json:"stake"`
		EventType   string    `json:"event_type"`
		Competition string    `json:"competition"`
		Event       string    `json:"event"`
		Market      string    `json:"market"`
		GameType    string    `json:"game_type"`
		Selection   string    `json:"selection"`
		CalcFact    uint8     `json:"calc_fact"`
		GameId      uint32    `json:"game_id"`
		EventId     uint32    `json:"event_id"`
		MarketId    float64   `json:"market_id"`
		SelectionId string    `json:"selection_id"`
		Percent     float32   `json:"percent"`
		CreatedAt   time.Time `json:"created_at"`
		Path        string    `json:"path"`
		userid      uint       `json:"user_id"`
		Status      int64      `json:"status"`
		UpdatedAt   time.Time `json:"updated_at"`
		
		
	
	}

	var (
		bets        []bet
		totalBets   uint
	
	)

	// fetch all placed bets of user with filter and pagination
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		var sqlStatement string
		if status == "past" {
			sqlStatement = `
				SELECT 
					id, username, bet_on, price, stake, event_type, competition, event, market, 
					game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, 
					percent, created_at, path, user_id, status, updated_at 
				FROM 
					bets 
				WHERE 
					status != 0 
					AND user_id = $1 
					AND created_at >= $2 
					AND updated_at <= $3 
					ORDER BY id DESC 
				OFFSET $4 ROWS 
				FETCH NEXT $5 ROWS ONLY
			`
			rows, err = betdb.DB.Query(sqlStatement, uid, startDate, endDate, offset, limit)
		} else {
			sqlStatement = `
				SELECT 
					id, username, bet_on, price, stake, event_type, competition, event, market, 
					game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, 
					percent, created_at, path, user_id, status, updated_at 
				FROM 
					bets 
				WHERE 
					status = 0
					AND user_id = $1 
					ORDER BY id DESC 
				OFFSET $2 ROWS 
				FETCH NEXT $3 ROWS ONLY
			`
			rows, err = betdb.DB.Query(sqlStatement, uid, offset, limit)
		}
		
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			var bet bet
			err := rows.Scan(
				&bet.Id,
				&bet.Username,
				&bet.BetOn,
				&bet.Price,
				&bet.Stake,
				&bet.EventType,
				&bet.Competition,
				&bet.Event,
				&bet.Market,
				&bet.GameType,
				&bet.Selection,
				&bet.CalcFact,
				&bet.GameId,
				&bet.EventId,
				&bet.MarketId,
				&bet.SelectionId,
				&bet.Percent,
				&bet.CreatedAt,
				&bet.Path,
				&bet.userid,
				&bet.Status,
				&bet.UpdatedAt,
			)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			bets = append(bets[:], bet)
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	// fetch placed bets count & amount
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		if  status == "past" {
			sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets FROM bets WHERE user_id = $1  AND created_at >= $2 AND created_at <= $3 AND status !=0"
			rows, err = betdb.DB.Query(sqlStatement,uid,startDate, endDate)
		} else {
			sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets FROM bets WHERE user_id = $1 AND  status =0 "
			rows, err = betdb.DB.Query(sqlStatement, uid, )
		}
	
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			err := rows.Scan(&totalBets)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"bets": bets, "total_bets": totalBets})
}




func (b *betRouter) CurrentBetList(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()
    
	offset := query.Get("offset")
	limit := query.Get("limit")
	betType := query.Get("type")
	eventId := query.Get("eventId")
	 

	if len(offset) == 0 {
		offset = "0"
	}

	if len(limit) == 0 {
		limit = "10"
	}

	type bet struct {
		Id          uint      `json:"id"`
		Username    *string   `json:"username,omitempty"`
		
		BetOn       string    `json:"bet_on"`
		Price       float32   `json:"price"`
		Stake       float64   `json:"stake"`
		EventType   string    `json:"event_type"`
		Competition string    `json:"competition"`
		Event       string    `json:"event"`
		Market      string    `json:"market"`
		
		GameType    string    `json:"game_type"`
		Selection   string    `json:"selection"`
		CalcFact    uint8     `json:"calc_fact"`
		
		GameId      uint32    `json:"game_id"`
		EventId     uint32    `json:"event_id"`
		MarketId    float64   `json:"market_id"`
		SelectionId string    `json:"selection_id"`
		Percent     float32   `json:"percent"`
		CreatedAt   time.Time `json:"created_at"`
	}

	var (
		bets        []bet
		totalBets   uint
		totalAmount float64
	)

	// fetch all placed bets of user with filter and pagination
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		if len(eventId) == 0 {
			sqlStatement := "SELECT id, username, bet_on, price, stake, event_type, competition, event, market, game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, percent, created_at FROM bets WHERE status = 0 AND (user_id = $1 OR path ~ $2) AND bet_on iLIKE $3 ORDER BY id DESC OFFSET $4 ROWS FETCH NEXT $5 ROWS ONLY"
			rows, err = betdb.DB.Query(sqlStatement, r.Context().Value(ReqCtxKey("_uid")), (fmt.Sprintf("%v", r.Context().Value(ReqCtxKey("_path"))) + ".*{1}"), ("%" + betType + "%"), offset, limit)
		} else {
			sqlStatement := "SELECT id, username, bet_on, price, stake, event_type, competition, event, market, game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, percent, created_at FROM bets WHERE status = 0 AND event_id = $1 AND (user_id = $2 OR path ~ $3) AND bet_on iLIKE $4 ORDER BY id DESC OFFSET $5 ROWS FETCH NEXT $6 ROWS ONLY"
			rows, err = betdb.DB.Query(sqlStatement, eventId, r.Context().Value(ReqCtxKey("_uid")), (fmt.Sprintf("%v", r.Context().Value(ReqCtxKey("_path"))) + ".*{1}"), ("%" + betType + "%"), offset, limit)
		}

		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			var bet bet
			err := rows.Scan(
				&bet.Id,
				&bet.Username,
				&bet.BetOn,
				&bet.Price,
				&bet.Stake,
				&bet.EventType,
				&bet.Competition,
				&bet.Event,
				&bet.Market,
				&bet.GameType,
				&bet.Selection,
				&bet.CalcFact,
				&bet.GameId,
				&bet.EventId,
				&bet.MarketId,
				&bet.SelectionId,
				&bet.Percent,
				&bet.CreatedAt,
				
			
			)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			bets = append(bets[:], bet)
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	// fetch placed bets count & amount
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		if len(eventId) == 0 {
			sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets, COALESCE(SUM(stake)::REAL, 0) AS total_amount FROM bets WHERE status = 0 AND (user_id = $1 OR path ~ $2) AND bet_on iLIKE $3"
			rows, err = betdb.DB.Query(sqlStatement, r.Context().Value(ReqCtxKey("_uid")), (fmt.Sprintf("%v", r.Context().Value(ReqCtxKey("_path"))) + ".*{1}"), ("%" + betType + "%"))
		} else {
			sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets, COALESCE(SUM(stake)::REAL, 0) AS total_amount FROM bets WHERE status = 0 AND event_id = $1 AND (user_id = $2 OR path ~ $3) AND bet_on iLIKE $4"
			rows, err = betdb.DB.Query(sqlStatement, eventId, r.Context().Value(ReqCtxKey("_uid")), (fmt.Sprintf("%v", r.Context().Value(ReqCtxKey("_path"))) + ".*{1}"), ("%" + betType + "%"))
		}

		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			err := rows.Scan(&totalBets, &totalAmount)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"bets": bets, "total_bets": totalBets, "total_amount": totalAmount})
}




func (b *betRouter) ParticulerSelectionbet(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()
    id:= query.Get("id")
	selectionid:= query.Get("selectionid")
	eventid:= query.Get("eventid")
    market:= query.Get("market")
	
	if market == "matchodds" {
        market = "Match Odds"
    }
	

	type bet struct {
		Id          uint      `json:"id"`
		Username    *string   `json:"username,omitempty"`
		BetOn       string    `json:"bet_on"`
		Price       float32   `json:"price"`
		Stake       float64   `json:"stake"`
		EventType   string    `json:"event_type"`
		Competition string    `json:"competition"`
		Event       string    `json:"event"`
		Market      string    `json:"market"`
		GameType    string    `json:"game_type"`
		Selection   string    `json:"selection"`
		CalcFact    uint8     `json:"calc_fact"`
		GameId      uint32    `json:"game_id"`
		EventId     uint32    `json:"event_id"`
		MarketId    float64   `json:"market_id"`
		SelectionId string   `json:"selection_id"`
		Percent     float32   `json:"percent"`
		CreatedAt   time.Time `json:"created_at"`
		Path        string    `json:"path"`
		userid      uint       `json:"user_id"`
		Status      int64     `json:"status"`
		UpdatedAt   time.Time `json:"updated_at"`
		
		
	
	}

	var (
		bets        []bet
		totalBets   uint
	
	)

	// fetch all placed bets of user with filter and pagination
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		var sqlStatement string

			sqlStatement = "SELECT id, username, bet_on, price, stake, event_type, competition, event, market, game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, percent, created_at, path, user_id, status, updated_at FROM bets WHERE user_id = $1 AND event_id = $2 AND selection_id = $3 AND market = $4"
	
			rows, err = betdb.DB.Query(sqlStatement, id,eventid,selectionid,market)
		

		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			var bet bet
			err := rows.Scan(
				&bet.Id,
				&bet.Username,
				&bet.BetOn,
				&bet.Price,
				&bet.Stake,
				&bet.EventType,
				&bet.Competition,
				&bet.Event,
				&bet.Market,
				&bet.GameType,
				&bet.Selection,
				&bet.CalcFact,
				&bet.GameId,
				&bet.EventId,
				&bet.MarketId,
				&bet.SelectionId,
				&bet.Percent,
				&bet.CreatedAt,
				&bet.Path,
				&bet.userid,
				&bet.Status,
				&bet.UpdatedAt,
			)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			bets = append(bets[:], bet)
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	// fetch placed bets count & amount
	

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"bets": bets, "total_bets": totalBets})
}


func (b *betRouter) Particulerbets(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()
    id:= query.Get("id")
	offset := query.Get("offset")
	status:= query.Get("status")
	
	limit := query.Get("limit")
	sports := query.Get("sports")
	startDateStr := query.Get("startdate")
	endDateStr := query.Get("enddate")
	

	startDate, err := time.Parse("2006-01-02", startDateStr)
	if err != nil {
		http.Error(w, "Invalid start date format", http.StatusBadRequest)
		return
	}

	endDate, err := time.Parse("2006-01-02", endDateStr)
	if err != nil {
		http.Error(w, "Invalid end date format", http.StatusBadRequest)
		return
	}


	if len(offset) == 0 {
		offset = "0"
	}

	if len(limit) == 0 {
		limit = "10"
	}

	type bet struct {
		Id          uint      `json:"id"`
		Username    *string   `json:"username,omitempty"`
		BetOn       string    `json:"bet_on"`
		Price       float32   `json:"price"`
		Stake       float64   `json:"stake"`
		EventType   string    `json:"event_type"`
		Competition string    `json:"competition"`
		Event       string    `json:"event"`
		Market      string    `json:"market"`
		GameType    string    `json:"game_type"`
		Selection   string    `json:"selection"`
		CalcFact    uint8     `json:"calc_fact"`
		GameId      uint32    `json:"game_id"`
		EventId     uint32    `json:"event_id"`
		MarketId    float64   `json:"market_id"`
		SelectionId string   `json:"selection_id"`
		Percent     float32   `json:"percent"`
		CreatedAt   time.Time `json:"created_at"`
		Path        string    `json:"path"`
		userid      uint       `json:"user_id"`
		Status       int64       `json:"status"`
		UpdatedAt   time.Time `json:"updated_at"`
		
		
	
	}

	var (
		bets        []bet
		totalBets   uint
	
	)

	// fetch all placed bets of user with filter and pagination
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		var sqlStatement string
		if status != "0" {
			sqlStatement = "SELECT id, username, bet_on, price, stake, event_type, competition, event, market, game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, percent, created_at, path, user_id, status, updated_at FROM bets WHERE game_id = $1 AND user_id = $2  AND created_at >= $3 AND updated_at <= $4 AND status != 0 ORDER BY id DESC OFFSET $5  ROWS FETCH NEXT $6 ROWS ONLY"
			rows, err = betdb.DB.Query(sqlStatement, sports, id, startDate, endDate, offset, limit)
		} else {
			sqlStatement = "SELECT id, username, bet_on, price, stake, event_type, competition, event, market, game_type, selection, calc_fact, game_id, event_id, market_id, selection_id, percent, created_at, path, user_id, status, updated_at FROM bets WHERE user_id = $1 AND  created_at >= $2 AND updated_at <= $3 AND status = 0 AND game_id = $4 ORDER BY id DESC OFFSET $5 ROWS FETCH NEXT $6 ROWS ONLY"
	
			rows, err = betdb.DB.Query(sqlStatement, id,  startDate, endDate,sports, offset, limit)
		}

		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			var bet bet
			err := rows.Scan(
				&bet.Id,
				&bet.Username,
				&bet.BetOn,
				&bet.Price,
				&bet.Stake,
				&bet.EventType,
				&bet.Competition,
				&bet.Event,
				&bet.Market,
				&bet.GameType,
				&bet.Selection,
				&bet.CalcFact,
				&bet.GameId,
				&bet.EventId,
				&bet.MarketId,
				&bet.SelectionId,
				&bet.Percent,
				&bet.CreatedAt,
				&bet.Path,
				&bet.userid,
				&bet.Status,
				&bet.UpdatedAt,
			)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			bets = append(bets[:], bet)
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	// fetch placed bets count & amount
	if true {
		var (
			rows *sql.Rows
			err  error
		)

		if status != "0" {
			sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets FROM bets WHERE game_id = $1 AND user_id = $2 AND created_at >= $3 AND created_at <= $4 AND status != 0"
			rows, err = betdb.DB.Query(sqlStatement, sports, id, startDate, endDate)
		} else {
			sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets FROM bets WHERE user_id = $1 AND created_at >= $2 AND created_at <= $3 AND status = 0 AND game_id = $4 "
			rows, err = betdb.DB.Query(sqlStatement, id,  startDate, endDate,sports)
		}
	
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			err := rows.Scan(&totalBets)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"bets": bets, "total_bets": totalBets})
}
func (b *betRouter) CasinoCurrentBetList(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query()

	offset := query.Get("offset")
	limit := query.Get("limit")
	betType := query.Get("type")

	if len(offset) == 0 {
		offset = "0"
	}

	if len(limit) == 0 {
		limit = "10"
	}

	type bet struct {
		Id          uint      `json:"id"`
		Casino      string    `json:"casino"`
		BetOn       string    `json:"bet_on"`
		Nation      string    `json:"nation"`
		Rate        float32   `json:"rate"`
		Stake       float64   `json:"stake"`
		GameType    string    `json:"game_type"`
		MarketId    float64   `json:"market_id"`
		SelectionId string    `json:"selection_id"`
		CreatedAt   time.Time `json:"created_at"`
	}

	var (
		bets        []bet
		totalBets   uint
		totalAmount float64
	)

	// fetch all placed casino bets of user with filter and pagination
	if true {
		sqlStatement := "SELECT id, casino, bet_on, nation, rate, stake, game_type, market_id, selection_id, created_at FROM casino_bets WHERE status = 0 AND user_id = $1 AND bet_on iLIKE $2 ORDER BY id DESC OFFSET $3 ROWS FETCH NEXT $4 ROWS ONLY"

		rows, err := betdb.DB.Query(sqlStatement, r.Context().Value(ReqCtxKey("_uid")), ("%" + betType + "%"), offset, limit)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			var bet bet
			err := rows.Scan(
				&bet.Id,
				&bet.Casino,
				&bet.BetOn,
				&bet.Nation,
				&bet.Rate,
				&bet.Stake,
				&bet.GameType,
				&bet.MarketId,
				&bet.SelectionId,
				&bet.CreatedAt,
			)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			bets = append(bets[:], bet)
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	// fetch placed bets count & amount
	if true {
		sqlStatement := "SELECT COUNT(id)::INTEGER AS total_bets, COALESCE(SUM(stake)::REAL, 0) AS total_amount FROM casino_bets WHERE status = 0 AND user_id = $1 AND bet_on iLIKE $2"

		rows, err := betdb.DB.Query(sqlStatement, r.Context().Value(ReqCtxKey("_uid")), ("%" + betType + "%"))
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		for rows.Next() {
			err := rows.Scan(&totalBets, &totalAmount)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
		}

		err = rows.Err()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"bets": bets, "total_bets": totalBets, "total_amount": totalAmount})
}

func (b *betRouter) SettleBet(w http.ResponseWriter, r *http.Request) {
	var body struct {
		GameId      uint32   `json:"gameId"`
		EventId     uint32   `json:"eventId"`
		MarketId    string  `json:"marketId"`
		SelectionId string   `json:"selectionId"`
		Market      string   `json:"market"`
		GameType    string   `json:"gameType"`
		Status      *string  `json:"status,omitempty"`
		Result      *float32 `json:"result,omitempty"`
	}

	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	bet.Resolver(body.GameId, body.EventId, body.MarketId, body.SelectionId, body.Market, body.GameType, body.Status, body.Result)

	w.Write([]byte("Done"))
}
