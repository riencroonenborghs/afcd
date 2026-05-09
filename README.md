# AFCD MCP Server

A [Model Context Protocol](https://modelcontextprotocol.io) server that exposes the [Australian Food Composition Database (AFCD)](https://www.foodstandards.gov.au/science-and-research/food-composition-and-safety-research/afcd) as a tool for AI assistants.

Built with Ruby on Rails 7.2, [fast-mcp](https://github.com/yjacket/fast-mcp), and SQLite with FTS5 full-text search.

## Requirements

- Ruby 3.3.9
- SQLite (with FTS5, included in macOS system SQLite)

## Setup

```bash
bundle install
bin/rails db:create db:migrate
bin/rails afcd:import CSV_PATH=db/csv/import.csv
```

## Running

```bash
bin/dev
```

Server starts at `http://localhost:3000`. The MCP endpoint is at `/mcp/sse`.

## Authentication

Set the `MCP_AUTH_TOKEN` environment variable to enable bearer token authentication:

```bash
MCP_AUTH_TOKEN=your-secret-token bin/dev
```

When set, all MCP requests must include the header:

```
Authorization: Bearer your-secret-token
```

If the variable is unset, authentication is disabled.

## Claude Desktop configuration

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "afcd": {
      "command": "/path/to/node",
      "args": [
        "/path/to/mcp-remote/dist/proxy.js",
        "http://localhost:3000/mcp/sse",
        "--header",
        "Authorization: Bearer your-secret-token"
      ]
    }
  }
}
```

Install `mcp-remote` if needed:

```bash
npm install -g mcp-remote
```

## Available tool

### `query_afcd_food_database`

Search the AFCD by food name using FTS5 prefix matching.

| Parameter | Type    | Required | Description                                      |
|-----------|---------|----------|--------------------------------------------------|
| `query`   | string  | yes      | Food name, partial name, or fuzzy search term    |
| `verbose` | boolean | no       | Return all nutrient fields (default: false)      |
| `limit`   | integer | no       | Max results, 1–50 (default: 10)                  |

Default (non-verbose) response fields: `public_food_key`, `food_name`, `classification`, `energy_with_dietary_fibre_equated` (kJ), `energy_with_dietary_fibre_equated_kcal`, `protein`, `fat_total`, `available_carbohydrate_without_sugar_alcohols`, `total_dietary_fibre`.

Verbose mode adds all ~200 nutrient fields including minerals, vitamins, fatty acids, and amino acids, plus kcal conversions for both energy fields.
