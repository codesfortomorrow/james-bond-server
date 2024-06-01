package bet

import (
	"bet-service/betdb"
	"bet-service/common"
	"database/sql"
	"sort"
	"strconv"
	"strings"
	"time"

	"encoding/json"
	"fmt"
	"os"
)

type Bet struct {
	BetOn       string  `json:"bet_on"`
	Price       float32 `json:"price"`
	Stake       float64 `json:"stake"`
	Percent     float32 `json:"percent"`
	SelectionId string  `json:"selection_id"`
}

type GroupBet struct {
	beton string
	win   float64
	loss  float64
}

type userBet struct {
	UserId uint
	Bets   []struct {
		Id          uint    `json:"id"`
		BetOn       string  `json:"bet_on"`
		Price       float32 `json:"price"`
		Stake       float64 `json:"stake"`
		EventType   string  `json:"event_type"`
		Competition string  `json:"competition"`
		Event       string  `json:"event"`
		Market      string  `json:"market"`
		Percent     float32 `json:"percent"`
		CalcFact    uint8   `json:"calc_fact"`
	}
}

type userCasinoBet struct {
	UserId uint
	Bets   []struct {
		Id          uint    `json:"id"`
		BetOn       string  `json:"bet_on"`
		Nation      string  `json:"nation"`
		Rate        float32 `json:"rate"`
		Stake       float64 `json:"stake"`
		SelectionId string  `json:"selection_id"`
	}
}

func IsSessionProcessable(eventId uint32, marketId float64, selectionId string) (int, *[]byte, error) {
	endpoint := fmt.Sprintf("%s/cricket/validate-session?eventId=%d&marketId=%v&selectionId=%s", os.Getenv("SESSION_SERVICE_HTTP_ENDPOINT"), eventId, marketId, selectionId)
	return common.GetHttpRequest(endpoint, nil)
}

func GetUserLocks(uid interface{}) (int, *[]byte, error) {
	endpoint := fmt.Sprintf("%s/locks?uid=%v", os.Getenv("USER_SERVICE_HTTP_ENDPOINT"), uid)
	return common.GetHttpRequest(endpoint, nil)
}

func ValidateBetStake(stake float64, calcFact uint8,gameId uint32) (bool, string) {
	if stake < 100 {
		return false, "Minimum bet stake should be 100"
	} else if calcFact == 1 && stake > 200000 {
		return false, "Maximum bet stake can be 200000"
	} else if stake > 1000000 {
		return false, "Maximum bet stake can be 1000000"
	} else {
		return true, "Ok"
	}
}

func ValidateBetPlacement(market, gameType, eventType, betOn string, eventId uint32, selectionId string, price, percent float32) (int, *[]byte, error) {
	endpoint := fmt.Sprintf("%s/%s/validate-bet-placement", os.Getenv("CATALOGUE_SERVICE_HTTP_ENDPOINT"), strings.ToLower(eventType))
	payload := map[string]interface{}{
		"eventId":     eventId,
		"market":      market,
		"gameType":    gameType,
		"selectionId": selectionId,
		"betOn":       betOn,
		"price":       price,
		"percent":     percent,
	}

	return common.PostHttpRequest(endpoint, &payload, nil)
}

func UpdateUserExposure(ctx string, uid interface{}, prevChange float64, change float64) (int, *[]byte, error) {
	endpoint := fmt.Sprintf("%s/update-exposure", os.Getenv("USER_SERVICE_HTTP_ENDPOINT"))
	payload := map[string]interface{}{
		"uid":        uid,
		"change":     change,
		"prevChange": prevChange,
		"ctx":        ctx,
	}

	return common.PostHttpRequest(endpoint, &payload, nil)
}

func updateUserBalance(ctx string, uid uint, from int, to uint, change float64,ap float64,betid uint, remark string) (int, *[]byte, error) {
	endpoint := fmt.Sprintf("%s/update-balance", os.Getenv("USER_SERVICE_HTTP_ENDPOINT"))
	payload := map[string]interface{}{
		"uid":    uid,
		"from":   from,
		"to":     to,
		"change": change,
		"remark": remark,
		"ap": ap,
		"betid": betid,
		"ctx":    ctx,
	}

	return common.PostHttpRequest(endpoint, &payload, nil)
}

func GetSelectionExposure(market string, betOn string, stake float64, price float32, percent float32, calcFact uint8) float64 {
	exposure := stake

	if market == "Bookmaker" {
		price /= 100
		price += 1
	}

	if betOn == "LAY" {
		if calcFact == 0 {
			exposure *= float64(price - 1)
		} else {
			exposure = (stake * float64(percent) / 100)
		}
	}

	return exposure
}

func GetMarketBets(uid interface{}, evenId uint32, marketId string, market string, gameType string) (*[]Bet, error) {
	var (
		bets []Bet
		rows *sql.Rows
		err  error
	)

	rows, err = betdb.DB.Query("SELECT bet_on, price, stake, percent, selection_id FROM bets WHERE user_id = $1 AND status = 0 AND event_id = $2 AND market_id = $3 AND market = $4 AND game_type = $5 ORDER BY id", uid, evenId, marketId, market, gameType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var bet Bet
		err := rows.Scan(&bet.BetOn, &bet.Price, &bet.Stake, &bet.Percent, &bet.SelectionId)
		if err != nil {
			return nil, err
		}
		bets = append(bets[:], bet)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return &bets, nil
}

func GetSelectionBets(uid interface{}, evenId uint32, marketId string, selectionId string, market string, gameType string) (*[]Bet, error) {
	var (
		bets []Bet
		rows *sql.Rows
		err  error
	)

	rows, err = betdb.DB.Query("SELECT bet_on, price, stake, percent, selection_id FROM bets WHERE user_id = $1 AND status = 0 AND event_id = $2 AND market_id = $3 AND selection_id = $4 AND market = $5 AND game_type = $6 ORDER BY id", uid, evenId, marketId, selectionId, market, gameType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var bet Bet
		err := rows.Scan(&bet.BetOn, &bet.Price, &bet.Stake, &bet.Percent, &bet.SelectionId)
		if err != nil {
			return nil, err
		}
		bets = append(bets[:], bet)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return &bets, nil
}

func CurrentBetExposure(bets *[]Bet, currentBet *Bet, market string, calcFact uint8) (float64, float64) {
	var (
		prevSelectionExposure float64
		selectionExposure     float64

		sessionBetGroups = map[string]map[string][]GroupBet{"BACK": {}, "LAY": {}}
		betGroups        = map[string]map[string]map[string]float64{}
	)

	for i := 0; i < len(*bets); i++ {
		if calcFact == 1 {
			prevSelectionExposure = CalcSessionExposure(&sessionBetGroups, &(*bets)[i])
		} else {
			prevSelectionExposure = CalcExposure(&betGroups, &(*bets)[i], market)
		}
	}

	if calcFact == 1 {
		selectionExposure = CalcSessionExposure(&sessionBetGroups, currentBet)
	} else {
		selectionExposure = CalcExposure(&betGroups, currentBet, market)
	}
	fmt.Println("prevSelectionExposure:",prevSelectionExposure,selectionExposure)
	return prevSelectionExposure, selectionExposure
}

func CalcSessionExposure(betGroups *map[string]map[string][]GroupBet, bet *Bet) float64 {
	if bet.BetOn == "BACK" {
		var (
			win              = (bet.Stake * float64(bet.Percent) / 100)
			loss             = bet.Stake
			isGroupAvailable = false
		)

		keys := make([]float64, 0, len((*betGroups)["BACK"]))
		for key := range (*betGroups)["BACK"] {
			if betPrice, err := strconv.ParseFloat(key, 32); err == nil {
				keys = append(keys, betPrice)
			}
		}

		sort.Float64s(keys)

		for _, value := range keys {
			if bet.Price <= float32(value) {
				isGroupAvailable = true
				key := fmt.Sprintf("%v", value)
				if len((*betGroups)["BACK"][key]) < 2 {
					group := append((*betGroups)["BACK"][key], GroupBet{bet.BetOn, win, loss})
					(*betGroups)["BACK"][key] = group
				} else {
					(*betGroups)["BACK"][key][1].win += win
					(*betGroups)["BACK"][key][1].loss += loss
				}
				break
			}
		}

		if !isGroupAvailable {
			if _, found := (*betGroups)["LAY"][fmt.Sprintf("%v", bet.Price)]; found {
				(*betGroups)["LAY"][fmt.Sprintf("%v", bet.Price)][0].win += win
				(*betGroups)["LAY"][fmt.Sprintf("%v", bet.Price)][0].loss += loss
			} else {
				var group []GroupBet
				group = append(group, GroupBet{bet.BetOn, win, loss})
				(*betGroups)["LAY"][fmt.Sprintf("%v", bet.Price)] = group
			}
		}
	} else if bet.BetOn == "LAY" {
		var (
			win              = bet.Stake
			loss             = (bet.Stake * float64(bet.Percent) / 100)
			isGroupAvailable = false
		)

		keys := make([]float64, 0, len((*betGroups)["LAY"]))
		for key := range (*betGroups)["LAY"] {
			if betPrice, err := strconv.ParseFloat(key, 32); err == nil {
				keys = append(keys, betPrice)
			}
		}

		sort.Sort(sort.Reverse(sort.Float64Slice(keys)))

		for _, value := range keys {
			if bet.Price >= float32(value) {
				isGroupAvailable = true
				key := fmt.Sprintf("%v", value)
				if len((*betGroups)["LAY"][key]) < 2 {
					group := append((*betGroups)["LAY"][key], GroupBet{bet.BetOn, win, loss})
					(*betGroups)["LAY"][key] = group
				} else {
					(*betGroups)["LAY"][key][1].win += win
					(*betGroups)["LAY"][key][1].loss += loss
				}
				break
			}
		}

		if !isGroupAvailable {
			if _, found := (*betGroups)["BACK"][fmt.Sprintf("%v", bet.Price)]; found {
				(*betGroups)["BACK"][fmt.Sprintf("%v", bet.Price)][0].win += win
				(*betGroups)["BACK"][fmt.Sprintf("%v", bet.Price)][0].loss += loss
			} else {
				var group []GroupBet
				group = append(group, GroupBet{bet.BetOn, win, loss})
				(*betGroups)["BACK"][fmt.Sprintf("%v", bet.Price)] = group
			}
		}
	}

	var exposure float64
	var groups = make(map[string]map[string][]GroupBet)
	for wrapperKey, wrapperValue := range *betGroups {
		groups[wrapperKey] = make(map[string][]GroupBet)
		for childKey, childValue := range wrapperValue {
			groups[wrapperKey][childKey] = append(groups[wrapperKey][childKey], childValue...)
		}
	}

	var containers = []string{"BACK", "LAY"}

	for _, container := range containers {
		keys := make([]float64, 0, len(groups[container]))
		for key := range groups[container] {
			if betPrice, err := strconv.ParseFloat(key, 32); err == nil {
				keys = append(keys, betPrice)
			}
		}

		if container == "BACK" {
			sort.Sort(sort.Reverse(sort.Float64Slice(keys)))
		} else {
			sort.Float64s(keys)
		}

		var (
			forwardWin  float64
			forwardLoss float64
		)

		for i, key := range keys {
			group := groups[container][fmt.Sprintf("%v", key)]

			if len(group) == 1 && len(keys) != i+1 {
				forwardWin += group[0].win
				forwardLoss += group[0].loss
				delete(groups[container], fmt.Sprintf("%v", key))
			} else {
				group[0].win += forwardWin
				group[0].loss += forwardLoss

				forwardWin = 0
				forwardLoss = 0
			}
		}
	}

	for container, value := range groups {
		keys := make([]float64, 0, len(value))
		for key := range value {
			if betPrice, err := strconv.ParseFloat(key, 32); err == nil {
				keys = append(keys, betPrice)
			}
		}

		if container == "BACK" {
			sort.Float64s(keys)
		} else {
			sort.Sort(sort.Reverse(sort.Float64Slice(keys)))
		}

		for i, key := range keys {
			group := groups[container][fmt.Sprintf("%v", key)]

			if len(group) > 1 {
				maxLossBetIndex := 0
				minWinBetIndex := 0

				maxLoss := group[maxLossBetIndex].loss
				if group[1].loss > maxLoss {
					maxLossBetIndex = 1
					maxLoss = group[maxLossBetIndex].loss
				}

				minWin := group[minWinBetIndex].win
				if group[1].win < minWin {
					minWinBetIndex := 1
					minWin = group[minWinBetIndex].win
				}

				if maxLossBetIndex == 1 && minWinBetIndex == 0 && maxLoss > minWin {
					var win float64 = 0
					for k := i; k < len(keys); k++ {
						settlementBet := groups[container][fmt.Sprintf("%v", keys[k])]

						ratio := settlementBet[0].loss / settlementBet[0].win

						if (maxLoss - win) > settlementBet[0].win {
							win += settlementBet[0].win
							settlementBet[0].win = 0
							settlementBet[0].loss = settlementBet[0].win * ratio
							continue
						} else {
							settlementBet[0].win -= maxLoss - win
							settlementBet[0].loss -= (maxLoss - win) * ratio
							win += maxLoss - win
							break
						}
					}
					exposure += maxLoss - win
				} else {
					exposure += maxLoss - minWin
				}
			} else {
				exposure += group[0].loss
			}
		}
	}

	return exposure
}

func CalcExposure(betGroups *map[string]map[string]map[string]float64, bet *Bet, market string) float64 {
	fmt.Println("Calculating exposure for bet:", *bet)
    fmt.Println("Market type:", market)
	if _, found := (*betGroups)[fmt.Sprintf("%s", bet.SelectionId)]; !found {
		(*betGroups)[fmt.Sprintf("%s", bet.SelectionId)] = map[string]map[string]float64{
			"BACK": {"win": 0, "loss": 0},
			"LAY":  {"win": 0, "loss": 0},
		}
	}

	if market == "Bookmaker" {
		bet.Price /= 100
		bet.Price += 1
	}

	if bet.BetOn == "BACK" {
		var (
			win  = bet.Stake * float64(bet.Price-1)
			loss = bet.Stake
		)

		(*betGroups)[fmt.Sprintf("%s", bet.SelectionId)]["BACK"]["win"] += win
		(*betGroups)[fmt.Sprintf("%s", bet.SelectionId)]["BACK"]["loss"] += loss
	} else if bet.BetOn == "LAY" {
		var (
			win  = bet.Stake
			loss = bet.Stake * float64(bet.Price-1)
		)
		(*betGroups)[fmt.Sprintf("%s", bet.SelectionId)]["LAY"]["win"] += win
		(*betGroups)[fmt.Sprintf("%s", bet.SelectionId)]["LAY"]["loss"] += loss
	}

	var exposure float64
	var keys []string

	for key := range *betGroups {
		keys = append(keys, key)
	}
	fmt.Println("keyskeys:",keys)
	if len(keys) > 1 {
		var container = map[uint]map[string]float64{
			0: {"win": 0, "loss": 0},
			1: {"win": 0, "loss": 0},
		}

		if len(keys) > 2 {
			container[0]["win"] += (*betGroups)[keys[0]]["BACK"]["win"] + (*betGroups)[keys[1]]["LAY"]["win"] + (*betGroups)[keys[2]]["LAY"]["win"]
			container[0]["loss"] += (*betGroups)[keys[0]]["BACK"]["loss"] + (*betGroups)[keys[1]]["LAY"]["loss"] + (*betGroups)[keys[2]]["LAY"]["loss"]
			container[1]["win"] += (*betGroups)[keys[0]]["LAY"]["win"] + (*betGroups)[keys[1]]["BACK"]["win"] + (*betGroups)[keys[2]]["BACK"]["win"]
			container[1]["loss"] += (*betGroups)[keys[0]]["LAY"]["loss"] + (*betGroups)[keys[1]]["BACK"]["loss"] + (*betGroups)[keys[2]]["BACK"]["loss"]
		} else {
			container[0]["win"] += (*betGroups)[keys[0]]["BACK"]["win"] + (*betGroups)[keys[1]]["LAY"]["win"]
			container[0]["loss"] += (*betGroups)[keys[0]]["BACK"]["loss"] + (*betGroups)[keys[1]]["LAY"]["loss"]
			container[1]["win"] += (*betGroups)[keys[0]]["LAY"]["win"] + (*betGroups)[keys[1]]["BACK"]["win"]
			container[1]["loss"] += (*betGroups)[keys[0]]["LAY"]["loss"] + (*betGroups)[keys[1]]["BACK"]["loss"]
		}

		if container[0]["win"] < container[1]["loss"] && (container[1]["loss"]-container[0]["win"]) > exposure {
			exposure = container[1]["loss"] - container[0]["win"]
		}

		if container[1]["win"] < container[0]["loss"] && (container[0]["loss"]-container[1]["win"]) > exposure {
			exposure = container[0]["loss"] - container[1]["win"]
		}
	} else {
		if (*betGroups)[keys[0]]["BACK"]["win"] < (*betGroups)[keys[0]]["LAY"]["loss"] && ((*betGroups)[keys[0]]["LAY"]["loss"]-(*betGroups)[keys[0]]["BACK"]["win"]) > exposure {
			exposure = (*betGroups)[keys[0]]["LAY"]["loss"] - (*betGroups)[keys[0]]["BACK"]["win"]
		}
		fmt.Println("elseleeslel:",(*betGroups)[keys[0]]["BACK"]["win"],(*betGroups)[keys[0]]["LAY"]["loss"],(*betGroups)[keys[0]]["LAY"]["win"],(*betGroups)[keys[0]]["BACK"]["loss"])

		if (*betGroups)[keys[0]]["LAY"]["win"] < (*betGroups)[keys[0]]["BACK"]["loss"] && ((*betGroups)[keys[0]]["BACK"]["loss"]-(*betGroups)[keys[0]]["LAY"]["win"]) > exposure {
			exposure = (*betGroups)[keys[0]]["BACK"]["loss"] - (*betGroups)[keys[0]]["LAY"]["win"]
		}
		
	}
	fmt.Println("Exposure calculated:", exposure)
	return exposure
}

func PlaceBet(uid interface{}, path interface{}, username, betOn, eventType, competition, event, market, gameType, selection string, price, percent float32, stake float64, calcFact uint8, gameId uint32, eventId uint32, selectionId string, marketId string) error {

	sqlStatement := `INSERT INTO bets (user_id, path, username, bet_on, price, stake, event_type, competition, event, market, game_type, selection, calc_fact, percent, game_id, event_id, market_id, selection_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)`

	if _, err := betdb.DB.Exec(sqlStatement, uid, path, username, betOn, price, stake, eventType, competition, event, market, gameType, selection, calcFact, percent, gameId, eventId, marketId, selectionId); err != nil {
		return err
	} else {
		return nil
	}
}

func PlaceCasinoBet(uid interface{}, casino, betOn, nation, gameType string, rate float32, stake float64, selectionId string, marketId float64) error {
	sqlStatement := `INSERT INTO casino_bets (user_id, casino, bet_on, nation, rate, stake, game_type, market_id, selection_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`

	if _, err := betdb.DB.Exec(sqlStatement, uid, casino, betOn, nation, rate, stake, gameType, marketId, selectionId); err != nil {
		return err
	} else {
		return nil
	}
}

func fetchUserMarketBetsBySelection(gameId uint32, eventId uint32, marketId string, selectionId string, market string, gameType string) (*[]userBet, error) {
	var userBets []userBet
	var rows *sql.Rows
	var err error
	if gameId == 4{
	fmt.Printf("Fetching user market bets by selection: GameId: %d, EventId: %d, MarketId: %s, SelectionId: %s, Market: %s, GameType: %s\n",
		gameId, eventId, marketId, selectionId, market, gameType)
	}
	if gameType == "fancy" || gameType == "session" || gameType == "fancy1" || gameType == "Session" {
		fmt.Printf("SelectionId:2")
		rows, err = betdb.DB.Query("SELECT DISTINCT bets.user_id, (SELECT JSON_AGG(bet) FROM (SELECT b.id, b.bet_on, b.price, b.stake, b.percent, b.event_type, b.competition, b.event, b.market, b.calc_fact FROM bets b WHERE b.user_id = bets.user_id AND b.status = 0 AND b.game_id = $1 AND b.event_id = $2 AND b.selection_id = $3  AND b.game_type = $4 ORDER BY b.id) bet)::TEXT AS bets FROM bets WHERE bets.status = 0 AND bets.game_id = $1 AND bets.event_id = $2 AND  bets.selection_id = $3  AND bets.game_type = $4", gameId, eventId,  selectionId,  gameType)
	}else if gameType == "bookmaker" {
		fmt.Printf("bookmqker")
		
		rows, err = betdb.DB.Query("SELECT DISTINCT bets.user_id, (SELECT JSON_AGG(bet) FROM (SELECT b.id, b.bet_on, b.price, b.stake, b.percent, b.event_type, b.competition, b.event, b.market, b.calc_fact FROM bets b WHERE b.user_id = bets.user_id AND b.status = 0 AND b.game_id = $1 AND b.event_id = $2 AND b.market_id = $3 AND b.selection = $4  AND b.game_type = $5 ORDER BY b.id) bet)::TEXT AS bets FROM bets WHERE bets.status = 0 AND bets.game_id = $1 AND bets.event_id = $2 AND bets.market_id = $3 AND bets.selection = $4 AND bets.game_type = $5", gameId, eventId, marketId, selectionId, gameType)
	
	}else {
		fmt.Printf("555555")
		rows, err = betdb.DB.Query("SELECT DISTINCT bets.user_id, (SELECT JSON_AGG(bet) FROM (SELECT b.id, b.bet_on, b.price, b.stake, b.percent, b.event_type, b.competition, b.event, b.market, b.calc_fact FROM bets b WHERE b.user_id = bets.user_id AND b.status = 0 AND b.game_id = $1 AND b.event_id = $2 AND b.market_id = $3 AND b.selection_id = $4  AND b.game_type = $5 ORDER BY b.id) bet)::TEXT AS bets FROM bets WHERE bets.status = 0 AND bets.game_id = $1 AND bets.event_id = $2 AND bets.market_id = $3 AND bets.selection_id = $4 AND bets.game_type = $5", gameId, eventId, marketId, selectionId, gameType)
	}

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var userBet userBet
		var bets string

		err := rows.Scan(&userBet.UserId, &bets)
		if err != nil {
			return nil, err
		}
		fmt.Println("Fetched bets:", bets)

		if err := json.Unmarshal([]byte(bets), &userBet.Bets); err != nil {
			return nil, err
		}

		userBets = append(userBets[:], userBet)
	}

	err = rows.Err()
	if err != nil {
		return nil, err
	}

	return &userBets, nil
}

func fetchUserCasinoBets(marketId float64, casino string) (*[]userCasinoBet, error) {
	var userBets []userCasinoBet

	rows, err := betdb.DB.Query("SELECT DISTINCT casino_bets.user_id, (SELECT JSON_AGG(bet) FROM (SELECT b.id, b.bet_on, b.nation, b.rate, b.stake, b.selection_id FROM casino_bets b WHERE b.user_id = casino_bets.user_id AND b.status = 0 AND b.market_id = $1 AND b.casino = $2 ORDER BY b.id) bet)::TEXT AS bets FROM casino_bets WHERE status = 0 AND market_id = $1 AND casino = $2", marketId, casino)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var userBet userCasinoBet
		var bets string

		err := rows.Scan(&userBet.UserId, &bets)
		if err != nil {
			return nil, err
		}

		if err := json.Unmarshal([]byte(bets), &userBet.Bets); err != nil {
			return nil, err
		}

		userBets = append(userBets[:], userBet)
	}

	err = rows.Err()
	if err != nil {
		return nil, err
	}

	return &userBets, nil
}

func GetUserDetails(authorization *string) (int, *[]byte, error) {
	endpoint := fmt.Sprintf("%s/get-user-details", os.Getenv("USER_SERVICE_HTTP_ENDPOINT"))
	return common.GetHttpRequest(endpoint, authorization)
}

func GetUserHierarchy(userId uint) (int, *[]byte, error) {
	endpoint := fmt.Sprintf("%s/get-hierarchy?uid=%d", os.Getenv("USER_SERVICE_HTTP_ENDPOINT"), userId)
	return common.GetHttpRequest(endpoint, nil)
}

func isValidBetStatus(status *string) bool {
	if status == nil {
		return false
	}

	switch strings.ToUpper(*status) {
	case "WINNER":
		return true
	case "LOOSER":
		return true
	case "LOSER":
		return true
	case "REMOVED":
		return true
	default:
		return false
	}
}

func Resolver(gameId uint32, eventId uint32, marketId string, selectionId string, market string, gameType string, status *string, result *float32) {
	
	// fmt.Printf("SelectionId:1")

    // Check if result is nil
   
	start := time.Now()
	
	if status == nil && result == nil {
		fmt.Printf("Can't resolve bets, status or result should not be nil pointer\n")
		return
	}
	// fmt.Printf("SelectionId:2")

	if status != nil && !isValidBetStatus(status) {
		fmt.Printf("Error: Unknown status %s\n", strings.ToUpper(*status))
		return
	}
	// fmt.Printf("SelectionId:")
	// Fetch all bets of market by selection to resolve
	userBets, err := fetchUserMarketBetsBySelection(gameId, eventId, marketId, selectionId, market, gameType)
	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		return
	}
	fmt.Printf("Fetched %d user bets for resolution\n", len(*userBets))


	for i := 0; i < len(*userBets); i++ {
		code, response, err := GetUserHierarchy((*userBets)[i].UserId)
		if err != nil {
			fmt.Printf("Error: %s\n", err.Error())
			continue
		}

		if code == 200 {
			var betUsers []struct {
				Id           uint
				Ap           float64
				CreditAmount float64
				UserType     string
			}

			if err := json.Unmarshal(*response, &betUsers); err != nil {
				fmt.Printf("Error: %s\n", err.Error())
				continue
			}
			  fmt.Println("Received bet users:")
    // for _, user := range betUsers {
    //     fmt.Printf("ID: %d, Ap: %.2f, CreditAmount: %.2f, UserType: %s\n", user.Id, user.Ap, user.CreditAmount, user.UserType)
    // }
		isOk := true

		// Resolve all bets of current user
		for _, bet := range (*userBets)[i].Bets {
			if bet.CalcFact == 1 && result != nil {
				if int(*result) == -1{
					betStatus := "REMOVED"
					status = &betStatus
					fmt.Println("Bet status set to REMOVED")
				} else if bet.Price <= *result {
					betStatus := "WINNER"
					status = &betStatus
					fmt.Println("Fetched user bets for resolution")
				} else {
					betStatus := "LOSER"
					status = &betStatus
					fmt.Println("Fetched user bets for resolution")
				}
			
				bet.Price = (bet.Percent / 100) + 1
			}
			

			// By pass calculation if status have value "REMOVED"
			if strings.ToUpper(*status) == "REMOVED" {
				continue
			}

			if market == "Bookmaker" {
				bet.Price /= 100
				bet.Price += 1
			}

			var (
				profit           float64
				loss             float64
				settlementAmount float64
				forwardUpAmount  float64
				betStatus        string
			)
			fmt.Printf("settelment testing: %v,.\n",betUsers )
			if bet.BetOn == "BACK" {
				profit = bet.Stake * float64(bet.Price-1)
				loss = bet.Stake
				fmt.Printf(" resolution\n",)
				if strings.ToUpper(*status) == "WINNER" {
					settlementAmount = profit
					betStatus = "WINNER"
				} else {
					fmt.Printf("heeeee\n",)
					settlementAmount = loss * -1
					betStatus = "LOOSER"
				}
			} else {
				profit = bet.Stake
				loss = bet.Stake * float64(bet.Price-1)
				fmt.Printf("Fetched  suiiii bets for resolution\n",)
				if strings.ToUpper(*status) != "WINNER" {
					settlementAmount = profit
					betStatus = "WINNER"
				} else {
					settlementAmount = loss * -1
					betStatus = "LOOSER"
				}
			}
			var addAp float64=0; 
for _, user := range betUsers {
    var apAmount float64
    if user.Id == (*userBets)[i].UserId {
        if bet.BetOn == "BACK" {
            apAmount = settlementAmount
        } else {
            apAmount = settlementAmount
        }
        forwardUpAmount = settlementAmount * -1
    } else {
        fmt.Printf("User Type: %s\n", user.UserType)

        
            apAmount = forwardUpAmount * float64(user.Ap-addAp) / 100 
            fmt.Printf("Regular user apAmount: %v\n", apAmount)
            addAp = float64(user.Ap) 
            fmt.Printf("Updated addAp: %v\n", addAp)
        
    }
    fmt.Printf("Settlement amount: %v\n", apAmount)
			code, response, err := updateUserBalance("BET", user.Id, -1,user.Id, apAmount,user.Ap,bet.Id,fmt.Sprintf("%s / %s / %s / %s", bet.EventType, bet.Competition, bet.Event, bet.Market))
			if err != nil {
				fmt.Printf("Error: %s\n", err.Error())
				isOk = false
				break
			}
			if code != 200 {
				fmt.Printf("User service HTTP response with status code %d %s\n", code, string(*response))
				isOk = false
				break
			}
		}

			if isOk {
				var sqlStatement string

				if betStatus == "WINNER" {
					sqlStatement = fmt.Sprintf("UPDATE bets SET status = %d WHERE id = %d", 1, bet.Id)
				} else {
					sqlStatement = fmt.Sprintf("UPDATE bets SET status = %d WHERE id = %d", 10, bet.Id)
				}

				if _, err := betdb.DB.Exec(sqlStatement); err != nil {
					fmt.Printf("Error: %s\n", err.Error())
					isOk = false
				}
			}
		}

		// Resolve all bets of current user if status have value "REMOVED" without affecting credit balance
		if strings.ToUpper(*status) == "REMOVED" {
			if gameType == "fancy" || gameType == "session" || gameType == "fancy1" || gameType == "Session" {
				sqlStatement := "UPDATE bets SET status = -2 WHERE status = 0 AND game_id = $1 AND event_id = $2  AND selection_id = $3  AND game_type = $4"
				if _, err := betdb.DB.Exec(sqlStatement, gameId, eventId, selectionId, gameType); err != nil {
					isOk = false
					fmt.Printf("Error: %s\n", err.Error())
					continue
				}
			} else if market == "bookmaker" {
				sqlStatement := "UPDATE bets SET status = -2 WHERE status = 0 AND game_id = $1 AND event_id = $2 AND market_id = $3 AND selection = $4 AND market = $5 AND game_type = $6"
				if _, err := betdb.DB.Exec(sqlStatement, gameId, eventId, marketId, selectionId, market, gameType); err != nil {
					isOk = false
					fmt.Printf("Error: %s\n", err.Error())
					continue
				}
				
			} else {
				sqlStatement := "UPDATE bets SET status = -2 WHERE status = 0 AND game_id = $1 AND event_id = $2 AND market_id = $3 AND selection_id = $4 AND market = $5 AND game_type = $6"
				if _, err := betdb.DB.Exec(sqlStatement, gameId, eventId, marketId, selectionId, market, gameType); err != nil {
					isOk = false
					fmt.Printf("Error: %s\n", err.Error())
					continue
				}
			}
		}
		
		

		// Reset exposure if user placed bet resolved successfully
		if isOk {
			var sessionBetGroups = map[string]map[string][]GroupBet{"BACK": {}, "LAY": {}}
			var betGroups = map[string]map[string]map[string]float64{}
			var exposure float64

			for _, _bet := range (*userBets)[i].Bets {
				bet := &Bet{BetOn: _bet.BetOn, Price: _bet.Price, Stake: _bet.Stake, Percent: _bet.Percent, SelectionId: selectionId}
				if _bet.CalcFact == 1 {
					exposure = CalcSessionExposure(&sessionBetGroups, bet)
					fmt.Printf("Settlement exposure inner one :", exposure)
				} else {
					exposure = CalcExposure(&betGroups, bet, market)
				}
			}
			fmt.Printf("Settlement exposure:", exposure)

			code, response, err := UpdateUserExposure("BET_RESOLVE", (*userBets)[i].UserId, 0,exposure)
			
			
			if err != nil {
				fmt.Printf("Error: %s\n", err.Error())
				continue
			}
			if code != 200 {
				fmt.Printf("Error: %s\n", string(*response))
				continue
			}
		}
		} else {
			fmt.Printf("User service HTTP response with status code %d %s\n", code, string(*response))
			continue
		}
	}
	
	end := time.Now()

	fmt.Printf("Event ID: %v, Market ID: %v, Selection ID: %s - The call took %v to run.\n", eventId, marketId, selectionId, end.Sub(start))
}

// func CasinoResolver(casino string, marketId float64, result uint32) {
// 	start := time.Now()

// 	// Fetch all bets of market to resolve
// 	userBets, err := fetchUserCasinoBets(marketId, casino)
// 	if err != nil {
// 		fmt.Printf("Error: %s\n", err.Error())
// 		return
// 	}

// 	for i := 0; i < len(*userBets); i++ {
// 		isOk := true

// 		// Resolve all bets of current user
// 		for _, bet := range (*userBets)[i].Bets {
// 			var (
// 				profit           float64
// 				loss             float64
// 				settlementAmount float64
// 				betStatus        string
// 			)

// 			if bet.BetOn == "BACK" {
// 				profit = bet.Stake * float64(bet.Rate-1)
// 				loss = bet.Stake

// 				if result == bet.SelectionId {
// 					settlementAmount = profit
// 					betStatus = "WINNER"
// 				} else {
// 					settlementAmount = loss * -1
// 					betStatus = "LOOSER"
// 				}
// 			} else {
// 				profit = bet.Stake
// 				loss = bet.Stake * float64(bet.Rate-1)

// 				if result != bet.SelectionId {
// 					settlementAmount = profit
// 					betStatus = "WINNER"
// 				} else {
// 					settlementAmount = loss * -1
// 					betStatus = "LOOSER"
// 				}
// 			}
			

// 			code, response, err := updateUserBalance("BET", (*userBets)[i].UserId, -1, (*userBets)[i].UserId, settlementAmount,2.12,bet.Id, fmt.Sprintf("%s / %s", casino, bet.Nation))
// 			if err != nil {
// 				fmt.Printf("Error: %s\n", err.Error())
// 				isOk = false
// 				break
// 			}
// 			if code != 200 {
// 				fmt.Printf("User service HTTP response with status code %d %s\n", code, string(*response))
// 				isOk = false
// 				break
// 			}

// 			if isOk {
// 				var sqlStatement string

// 				if betStatus == "WINNER" {
// 					sqlStatement = fmt.Sprintf("UPDATE casino_bets SET status = %d WHERE id = %d", 1, bet.Id)
// 				} else {
// 					sqlStatement = fmt.Sprintf("UPDATE casino_bets SET status = %d WHERE id = %d", 10, bet.Id)
// 				}

// 				if _, err := betdb.DB.Exec(sqlStatement); err != nil {
// 					fmt.Printf("Error: %s\n", err.Error())
// 					isOk = false
// 				}
// 			}
// 		}

// 		// Reset exposure if user placed bet resolved successfully
// 		if isOk {
// 			var exposure float64

// 			for _, _bet := range (*userBets)[i].Bets {
// 				exposure += GetSelectionExposure(casino, _bet.BetOn, _bet.Stake, _bet.Rate, 100, 0)
// 			}

// 			code, response, err := UpdateUserExposure("BET_RESOLVE", (*userBets)[i].UserId, 0, exposure)
// 			if err != nil {
// 				fmt.Printf("Error: %s\n", err.Error())
// 				continue
// 			}
// 			if code != 200 {
// 				fmt.Printf("Error: %s\n", string(*response))
// 				continue
// 			}
// 		}
// 	}

// 	end := time.Now()

// 	fmt.Printf("Casino: %v, Market ID: %v - The call took %v to run.\n", casino, marketId, end.Sub(start))
// }
