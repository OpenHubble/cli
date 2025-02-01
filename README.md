# OpenHubble CLI

**Command-line interface** (CLI) tool built with **Python** for interacting with the **Agent**, enabling quick testing and data retrieval. Features include querying metrics, testing configurations, and debugging.. Includes installation, update, and uninstallation guides.

## Installing the CLI

To install the **OpenHubble CLI**, follow these steps:

### 1. Download and Run the Installation Script

Use `curl` to fetch the installation script and run it with **root** privileges:

```bash
curl -s https://get.openhubble.com/cli | sudo bash
```

This script will:

- Update your system's packages.
- Install required dependencies (`git`, `python3`, `python3-venv`, and `python3-pip`).
- Clone the **OpenHubble CLI** repository.
- Set up the required directories and configurations.
- Create a Python virtual environment and install the necessary Python modules.

### 2. Verify Installation

To confirm the cli is installed, use:

```bash
openhubble-cli
```

Now the tool must be appire!

---

## Available Commands

You can use commands to **ping** the agent, **get** a specific metric from the agent, **update**, or **uninstall**. Let's begin.

### Ping Agent

To check if the agent is running, use:

```bash
openhubble-cli ping --host <host> --port <port>
```

Example:

```bash
openhubble-cli ping --host llm.example.com --port 9703
```

If the agent is running, the response will be:

```bash
Agent is running.
```

If there is an issue, an error message will be displayed.

> **Default values:**
> - `host`: `127.0.0.1`
> - `port`: `9703`

### Get Metric

To retrieve a specific metric from the agent, use:

```bash
openhubble-cli get --host <host> --port <port> --metric <metric>
```

Example:

```bash
openhubble-cli get --host llm.example.com --port 7788 --metric hostname
```

This might return:

```bash
SRV_LLM_PROD
```

Another example:

```bash
openhubble-cli get --metric agent.version
```

This could return:

```bash
1.2.0
```

> **Default values:**
> - `host`: `127.0.0.1`
> - `port`: `9703`
> - `metric`: `hostname`

### Show Version

To check the version of the OpenHubble CLI:

```bash
openhubble-cli version
```

This will display the current version of the OpenHubble CLI.

### Show Help

To view the help documentation and available commands:

```bash
openhubble-cli help
```

This will show the usage information for the tool, including all available subcommands.

---

## Updating the CLI

The OpenHubble CLI can be updated using the built-in commands. Run the following command with **root** privileges:

```bash
sudo openhubble-cli update
```

This will:

- Pull the latest updates from the repository.
- Update Python dependencies.

---

## Uninstalling the CLI

To uninstall the OpenHubble CLI, use the built-in CLI commands:

```bash
sudo openhubble-cli uninstall
```

This will:

- Remove directories, and configuration files.

---

## Attribution

If you modify or redistribute the **OpenHubble CLI**, you must include a reference to **"OpenHubble"** as the original creator of the project. This ensures that our startup is credited for the work and contributions made to the software.

Example attribution:

```bash
This software was modified from the original **OpenHubble CLI** (https://github.com/OpenHubble/cli).
```

---

[OpenHubble](https://openhubble.com) by [Amirhossein Mohammadi](https://amirhossein.info) - 2025
