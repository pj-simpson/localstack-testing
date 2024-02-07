package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/http"

	"github.com/aws/aws-lambda-go/lambda"
)

type Artist struct {
	Name        string `json:"name"`
	ID          int    `json:"id"`
	ResourceURL string `json:"resource_url"`
	URI         string `json:"uri"`
	ReleasesURL string `json:"releases_url"`
}

func RandomDiscogsArtist() (Artist, error) {
	base := "https://api.discogs.com/"
	randArtistId := rand.Intn(8689405)
	url := fmt.Sprintf("%sartists/%d", base, randArtistId)

	var responseObject Artist

	response, err := http.Get(url)
	if err != nil {
		return responseObject, err
	}

	responseData, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return responseObject, err
	}

	json.Unmarshal(responseData, &responseObject)

	return responseObject, nil
}

func main() {
	lambda.Start(RandomDiscogsArtist)
}
