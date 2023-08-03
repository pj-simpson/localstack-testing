package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response events.APIGatewayProxyResponse

type PostmanHeaders struct {
	XForwardedProto string `json:"x-forwarded-proto"`
	XForwardedPort  string `json:"x-forwarded-port"`
	Host            string `json:"host"`
	XAmznTraceID    string `json:"x-amzn-trace-id"`
	UserAgent       string `json:"user-agent"`
	Accept          string `json:"accept"`
}

type PostmanEchoResp struct {
	PostmanHeaders `json:"headers"`
	URL            string `json:"url"`
}

func constructQueryParams(eventParams map[string]string) string {
	values := url.Values{}
	for k, v := range eventParams {
		values.Add(k, v)
	}
	return values.Encode()
}

func Handler(ctx context.Context, request events.APIGatewayProxyRequest) (Response, error) {
	params := request.QueryStringParameters
	encodedParams := constructQueryParams(params)
	base := "https://postman-echo.com/"
	url := fmt.Sprintf("%sget?%s", base, encodedParams)

	os.Stdout.Write([]byte("Sending request to " + url))

	var postmanRespObj PostmanEchoResp

	response, err := http.Get(url)
	if err != nil {
		return Response{StatusCode: 404}, err
	}

	responseData, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return Response{StatusCode: 404}, err
	}

	json.Unmarshal(responseData, &postmanRespObj)

	resp := Response{
		StatusCode:      200,
		IsBase64Encoded: false,
		Body:            fmt.Sprintf(`"postmanURL":"%s"`, postmanRespObj.URL),
		Headers: map[string]string{
			"Content-Type":    "application/json",
			"User-Agent":      postmanRespObj.PostmanHeaders.UserAgent,
			"XForwardedProto": postmanRespObj.PostmanHeaders.XForwardedProto,
			"XForwardedPort":  postmanRespObj.PostmanHeaders.XForwardedPort,
			"Host":            postmanRespObj.PostmanHeaders.Host,
			"XAmznTraceID":    postmanRespObj.XAmznTraceID,
			"UserAgent":       postmanRespObj.PostmanHeaders.UserAgent,
		},
	}
	return resp, nil
}

func main() {
	lambda.Start(Handler)
}
