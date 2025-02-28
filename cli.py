#!/usr/bin/env python3

# Import necessary libraries

import argparse  # Argument parsing
import subprocess  # Executing system commands like systemctl
import requests # Making HTTP requests

from art import text2art  # To generate ASCII art
from termcolor import cprint  # Colored terminal printing
from rich.console import Console  # Enhanced terminal output
from rich_gradient import Gradient  # Gradient effects in text output

import config.config as config  # Configuration of cli

# Initialize the rich console for pretty output
console = Console()

# Function to print ASCII art
def print_art():
    openhubble_art = text2art("OpenHubble")
    cli_art = text2art("CommandLine")
    pallete1 = [
        "#3674B5",
        "#578FCA",
        "#A1E3F9",
        "#D1F8EF"
    ]
    
    print("\n")

    console.print(
        Gradient(
            openhubble_art,
            colors=pallete1,
            justify="center"
        )
    )
    console.print(
        Gradient(
            cli_art,
            colors=pallete1[::-1],
            justify="center"
        )
    )


# Function to update the tool by running the update.sh script
def update():
    cprint("Updating the tool...", "blue")
    
    # Confirmation prompt
    confirmation = input("Are you sure you want to update the tool? (yes/no): ").strip().lower()
    
    if confirmation in ["yes", "y"]:
        update_script = "/opt/openhubble-cli/scripts/update.sh"
        
        subprocess.run(["sudo", update_script])  # Run the update script
        cprint("Tool updated successfully.", "green")
    else:
        cprint("Updating aborted.", "yellow")

# Function to uninstall the tool with a user confirmation prompt
def uninstall():
    cprint("Uninstalling the tool...", "red")
    
    # Confirmation prompt
    confirmation = input("Are you sure you want to uninstall the tool? (yes/no): ").strip().lower()
    
    if confirmation in ["yes", "y"]:
        uninstall_script = "/opt/openhubble-cli/scripts/uninstall.sh"
        
        subprocess.run(["sudo", uninstall_script])  # Run the uninstall script
        cprint("Tool uninstalled successfully.", "green")
    else:
        cprint("Uninstallation aborted.", "yellow")

# Function to display the version of the tool
def version():
    cprint(f"OpenHubble CLI {config.CLI_VERSION}", "cyan", attrs=["bold"])

# Function to get ping of Agent
def ping_agent(host="127.0.0.1", port="9703", protocol="http"):
    url = f"{protocol}://{host}:{port}/api/ping"
    
    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        if data.get("message") == "pong":
            cprint("Agent is running.", "green")
        else:
            cprint("Unexpected response from agent.", "yellow")
    except requests.RequestException as e:
        cprint(f"Error contacting agent: {e}", "red")

# Function to get a metric from Agent
def get_metric(host="127.0.0.1", port="9703", metric="hostname", protocol="http"):
    url = f"{protocol}://{host}:{port}/api/get?metric={metric}"

    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        if "metric" in data:
            cprint(f"Metric value: {data['metric']}", "green")
        else:
            cprint("Unexpected response from agent.", "yellow")
    except requests.RequestException as e:
        cprint(f"Error contacting agent: {e}", "red")

# Custom argument parser to enhance the help output
class CustomArgumentParser(argparse.ArgumentParser):
    def print_help(self):
        print_art()
        super().print_help()

# Main function to handle command-line arguments and trigger the corresponding actions
def main():
    # Initialize the argument parser with a description
    parser = CustomArgumentParser(description="OpenHubble CLI.")
    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Define subcommands and their corresponding help descriptions
    subparsers.add_parser("update", help="Update the tool")
    subparsers.add_parser("uninstall", help="Uninstall the tool")
    subparsers.add_parser("help", help="Show help information")
    subparsers.add_parser("version", help="Show the version of the tool")
    
    # Define subcommand for ping
    ping_parser = subparsers.add_parser("ping", help="Get ping of Agent")
    ping_parser.add_argument("--host", type=str, default="127.0.0.1", help="Host of Agent")
    ping_parser.add_argument("--port", type=str, default="9703", help="Port of Agent")
    ping_parser.add_argument("--http", action="store_true", help="Use http as protocol")
    ping_parser.add_argument("--https", action="store_true", help="Use https as protocol")

    # Define subcommand for get
    get_parser = subparsers.add_parser("get", help="Get a metric from Agent")
    get_parser.add_argument("--host", type=str, default="127.0.0.1", help="Host of Agent")
    get_parser.add_argument("--port", type=str, default="9703", help="Port of Agent")
    get_parser.add_argument("--metric", type=str, default="hostname", help="Metric from Agent")
    get_parser.add_argument("--http", action="store_true", help="Use http as protocol")
    get_parser.add_argument("--https", action="store_true", help="Use https as protocol")
    
    # Parse the arguments passed to the script
    args = parser.parse_args()

    # Handle the execution of different commands based on the user's input
    if args.command == "help":
        parser.print_help()
    elif args.command == "version":
        version()
    elif args.command == "update":
        update()
    elif args.command == "uninstall":
        uninstall()
    elif args.command == "ping":
        if args.http == True and args.https == True:
            print("You can not use both 2 protocols. Use --http or --https")
            return

        protocol = "http" if args.http == True else "https"        
        ping_agent(args.host, args.port, protocol)
    elif args.command == "get":
        if args.http == True and args.https == True:
            print("You can not use both 2 protocols. Use --http or --https")
            return

        protocol = "http" if args.http == True else "https"        
        get_metric(args.host, args.port, args.metric, protocol)
    else:
        parser.print_help()

# Entry point to execute the script
if __name__ == "__main__":
    main()
