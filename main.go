package main

import (
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"net/http"
	"strings"
)

const (
	defaultHost = "127.0.0.1"
	defaultPort = "9703"
	version     = "v0.1.0"
)

func main() {
	var showVersion, showHelp bool

	flag.BoolVar(&showVersion, "v", false, "Show version information")
	flag.BoolVar(&showHelp, "h", false, "Show help information")
	flag.Parse()

	if showHelp {
		printMainHelp()
		return
	}

	if showVersion {
		fmt.Println("Version:", version)
		return
	}

	if len(flag.Args()) < 1 {
		fmt.Println("Error: Missing command. Use -h for help.")
		return
	}

	command := flag.Arg(0)
	switch command {
	case "get":
		handleCommand(command, handleGetCommand)
	case "ping":
		handleCommand(command, handlePingCommand)
	default:
		fmt.Printf("Error: Unknown command '%s'. Use -h for help.\n", command)
	}
}

type commandHandler func(args []string)

func handleCommand(command string, handler commandHandler) {
	args := flag.Args()[1:]
	handler(args)
}

func printMainHelp() {
	fmt.Println(`Usage: app [command]

Available commands:
  get     Fetch metrics
  ping    Check agent reachability

Global flags:
  -v      Show version information
  -h      Show this help message`)
}

func makeHTTPRequest(url, method string) (int, string, error) {
	client := &http.Client{}
	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		return 0, "", fmt.Errorf("error creating request: %w", err)
	}

	res, err := client.Do(req)
	if err != nil {
		return 0, "", fmt.Errorf("error performing request: %w", err)
	}
	defer res.Body.Close()

	body, err := io.ReadAll(res.Body)
	if err != nil {
		return res.StatusCode, "", fmt.Errorf("error reading response body: %w", err)
	}

	return res.StatusCode, string(body), nil
}

func parseJSONPath(jsonData, path string) (interface{}, error) {
	var data map[string]interface{}

	if err := json.Unmarshal([]byte(jsonData), &data); err != nil {
		return nil, fmt.Errorf("error parsing JSON: %w", err)
	}

	keys := strings.Split(path, ".")
	current := data

	for _, key := range keys {
		if val, ok := current[key]; ok {
			switch v := val.(type) {
			case map[string]interface{}:
				current = v
			default:
				return v, nil
			}
		} else {
			return nil, errors.New("not found")
		}
	}

	return nil, errors.New("not found")
}

func handleGetCommand(args []string) {
	getCmd := flag.NewFlagSet("get", flag.ExitOnError)
	host := getCmd.String("h", defaultHost, "Host to connect to")
	port := getCmd.String("p", defaultPort, "Port to connect to")
	metric := getCmd.String("m", "", "Specific metric to retrieve (e.g., memory.available)")

	if err := getCmd.Parse(args); err != nil {
		fmt.Println("Error parsing 'get' command flags:", err)
		return
	}

	url := fmt.Sprintf("http://%s:%s/api/metrics", *host, *port)
	fmt.Printf("Fetching metrics from %s\n", url)

	statusCode, body, err := makeHTTPRequest(url, "GET")
	if err != nil {
		fmt.Printf("Failed to fetch metrics: %v\n", err)
		return
	}

	if statusCode != http.StatusOK {
		fmt.Printf("Failed to fetch metrics. Status code: %d\n", statusCode)
		return
	}

	if *metric == "" {
		fmt.Println("Metrics fetched successfully:")
		fmt.Println(body)
		return
	}

	value, err := parseJSONPath(body, *metric)
	if err != nil {
		fmt.Printf("Error retrieving metric '%s': %v\n", *metric, err)
		return
	}

	fmt.Printf("Value for '%s': %v\n", *metric, value)
}

func handlePingCommand(args []string) {
	pingCmd := flag.NewFlagSet("ping", flag.ExitOnError)
	host := pingCmd.String("h", defaultHost, "Host to ping")
	port := pingCmd.String("p", defaultPort, "Port to ping")

	if err := pingCmd.Parse(args); err != nil {
		fmt.Println("Error parsing 'ping' command flags:", err)
		return
	}

	url := fmt.Sprintf("http://%s:%s/api/ping", *host, *port)
	fmt.Printf("Pinging agent at %s\n", url)

	statusCode, _, err := makeHTTPRequest(url, "GET")
	if err != nil {
		fmt.Printf("Ping failed: %v\n", err)
		return
	}

	if statusCode == http.StatusOK {
		fmt.Println("Ping is successful.")
	} else {
		fmt.Printf("Ping failed with status code: %d\n", statusCode)
	}
}
