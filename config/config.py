# Import TOML
import toml

# Import OS lib
import os

APP_MODE = os.getenv("CLI_APP_MODE", "PRODUCTION")

IS_PRODUCTION = True if str(APP_MODE) == "PRODUCTION" else False

# Project Directory
PROJECT_DIRECTORY = ""

# Project config file path
PROJECT_CONFIG_FILE = "pyproject.toml"

# Check path
if IS_PRODUCTION:
    PROJECT_DIRECTORY = "/opt/openhubble-cli"
else:
    PROJECT_DIRECTORY = "./test"

# Read the TOML project config file
project_config = toml.load(f"{PROJECT_DIRECTORY}/{PROJECT_CONFIG_FILE}")

# ----- Read Project Configs (TOML) ----- #
PROJECT_NAME = project_config.get("tool", {}).get("openhubble", {}).get("name", "N/A")
PROJECT_VERSION = project_config.get("tool", {}).get("openhubble", {}).get("version", "N/A")

CLI_VERSION = PROJECT_VERSION
