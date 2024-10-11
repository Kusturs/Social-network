# Social Network API

This is an API for a social network, developed using Ruby on Rails.

## Requirements

- Docker
- Docker Compose

## Setup

1. Clone the repository:
   ```
   git clone https://gitlab.com/DimaMal/social-network-api.git
   cd social-network-api
   ```

2. Copy the `.env.development` file to `.env` and set the necessary variables:
   ```
   cp .env.development .env
   ```

3. Initialize the project:
   ```
   make init
   ```

## Usage
- Build the image: `make build`
- Start the server: `make up`
- Stop the server: `make down`
- View logs: `make logs`
- Database setup: `make db-setup`
- Full setup: `make init`

The API will be available at `http://localhost:3000`.

## API Documentation

API documentation is available at `http://localhost:3000/api-docs` after starting the server.
