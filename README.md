<p align="center">
  <img src="https://raw.githubusercontent.com/go-olive/brand-kit/main/banner/banner-01.png" />
</p>

[![GoDoc](https://img.shields.io/badge/GoDoc-Reference-blue?style=for-the-badge&logo=go)](https://pkg.go.dev/github.com/go-olive/olive?tab=doc)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/go-olive/olive/release.yml?branch=v0.6.0&style=for-the-badge)](https://github.com/go-olive/olive/actions/workflows/release.yml)
[![Sourcegraph](https://img.shields.io/badge/view%20on-SG-brightgreen.svg?style=for-the-badge&logo=sourcegraph)](https://sourcegraph.com/github.com/go-olive/olive)
[![Github All Releases](https://img.shields.io/github/downloads/go-olive/olive/total.svg?style=for-the-badge)](https://github.com/go-olive/olive/releases)
[![License](https://img.shields.io/github/license/go-olive/olive?style=for-the-badge)](https://github.com/go-olive/olive/blob/main/LICENSE)

[简体中文](https://go-olive.github.io/) | English

## Sponsor

<a href="https://olived.app" target="_blank">
  <img src="https://raw.githubusercontent.com/go-olive/brand-kit/main/icon/appicon.png" width=142 height=142 />
</a>

[Olived | A modern live stream recorder](https://olived.app)

## Installation

- build from source

  `go install github.com/go-olive/olive@latest`

- download from [**releases**](https://github.com/go-olive/olive/releases)

- docker image
  `docker pull luxcgo/olive`

## Quickstart

Get **olive** to work simply by passing the live url.

```sh
$ olive run -u https://www.huya.com/518512
```

## Usage

```sh
$ olive help

olive is a live stream recorder, underneath there is a powerful engine
which monitors streamers status and automatically records when they're
online. It helps you catch every live stream you want to see.

Usage:
  olive [command]

Available Commands:
  admin       Admin is a cli utility for database.
  biliup      Biliup is a cli utility which generates bilibli cookies.
  completion  Generate the autocompletion script for the specified shell
  help        Help about any command
  run         Start the olive engine.
  server      Server provides olive-api support.
  tv          TV is a cli utility which gets stream url.
  version     Print the version number of olive

Flags:
  -h, --help   help for olive

Use "olive [command] --help" for more information about a command.
```

## License

This project is under the Apache-2.0. See the [LICENSE](https://github.com/go-olive/olive/blob/main/LICENSE) file for the full license text.
