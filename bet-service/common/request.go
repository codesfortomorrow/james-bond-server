package common

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"
)

func GetHttpRequest(endpoint string, authorization *string) (int, *[]byte, error) {
	request, err := http.NewRequest("GET", endpoint, nil)
	if err != nil {
		return 500, nil, err
	}

	if authorization != nil {
		request.Header.Add("Authorization", *authorization)
	}

	client := &http.Client{}
	response, err := client.Do(request)
	if err != nil {
		return 500, nil, err
	}
	defer response.Body.Close()

	responseData, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return 500, nil, err
	}

	return response.StatusCode, &responseData, nil
}

func PostHttpRequest(endpoint string, requestBody *map[string]interface{}, authorization *string) (int, *[]byte, error) {
	payload, err := json.Marshal(*requestBody)
	if err != nil {
		return 500, nil, err
	}

	client := &http.Client{}

	request, err := http.NewRequest("POST", endpoint, bytes.NewBuffer(payload))
	if err != nil {
		return 500, nil, err
	}

	request.Header.Add("Content-Type", "application/json")

	if authorization != nil {
		request.Header.Add("Authorization", *authorization)
	}

	response, err := client.Do(request)
	if err != nil {
		return 500, nil, err
	}
	defer response.Body.Close()

	responseData, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return 500, nil, err
	}

	return response.StatusCode, &responseData, nil
}
