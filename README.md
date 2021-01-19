# README

## Overview

This is the third version of my personal webiste. The site is not static as it enables:
1. The ability to collect workout statistics via a phone call
1. The ability to display data in a d3 heatmap
1. The ability to send messsages
1. The ability to receive phone calls

The technology stack has moved from Exlir to Rails to provide the dynamic capabilities.

## How to install from github

```bash
git clone git@github.com:jschmitz/rockworm.git
```

```bash
rvm gemset create rockworm
rvm gemset use rockworm
bundle
```

## Environment Variables


| Environment Variable             | Description |
| :-------------------             | :---------- |
| ROCKWORM_DB_HOST | When developing locally use 'localhost'. When building the docker container use 'db', the name used for pg docker in the compose file|
| ROCKWORM_DB_PASSWORD | PG User's password |
| ROCKWORM_DB_USER | PG User |
| ROCKWORM_PHONE_NUMBER | This is the phone number that will send outbound messages and make outbound calls |
| ROCKWORM_WEB_PHONE_NUMBER | This is the number that is displayed on the web page to receive phone calls |
| MY_PHONE_NUMBER | The number that will recieve messages and calls |
| GOOGLE_APPLICATION_CREDENTIALS | Used to transcribe call recordings |
| ROCKWORM_APPLICATION_ID | FreeClimb application id |
| ROCKWORM_PUBLIC_URL | Url helper |
| FC_ACCOUNT_ID | The account id for FreeClimb |
| FC_ACCOUNT_TOKEN | The api key for freeclimb |

## Docker Compose 
The docker compose file can be used to run the application.

```bash
docker-compose up
```

## Local Instance
The config files and environments variables can also be used to run a local instance of the application.
