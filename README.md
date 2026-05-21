# ATRAC Encode/Decode Server

This is a basic [FastAPI](https://fastapi.tiangolo.com/) python application for running a windows executable atrac encoder as an API-driven service. It was originally designed for integration with [Web MiniDisc Pro](https://github.com/asivery/webminidisc).

## Installation

No executables are provided in this repository. The current syntax of the script is designed to work with the ATRAC3 tool included with the Sony PSP SDK. Other executables such as [atracdenc](https://github.com/dcherednik/atracdenc) can be easily substituted

You'll need these executables:
- `at3tool`: the Linux version, not windows version
- `libatrac.so.1.2.0`

To build atracapi as a docker container, provide aforementioned binaries and run `docker build -t szclsya/atrac-api .`. Then you can run the server via the provided `compose.yml` with docker compose.
