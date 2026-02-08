# Google Maps Scraper

> Source: https://github.com/gosom/google-maps-scraper

A powerful, free, and open-source Google Maps scraper. MIT licensed.

- **2.8k GitHub stars**, 382 forks
- **~120 places/minute** performance
- **34 data points** extracted per business

## Core Features

| Feature | Details |
|---------|---------|
| Free & Open Source | MIT licensed, no hidden costs |
| Multiple Interfaces | CLI, Web UI, REST API |
| High Performance | ~120 places/minute with optimized concurrency |
| Data Points | Business details, reviews, emails, coordinates, images |
| Production Ready | Scales from single machine to Kubernetes clusters |
| Flexible Output | CSV, JSON, PostgreSQL, S3, LeadsDB, custom plugins |
| Proxy Support | Built-in SOCKS5/HTTP/HTTPS proxy rotation |

---

## Installation

### Docker (Recommended)

Two variants:

| Image | Tag | Engine | Best For |
|-------|-----|--------|----------|
| Playwright (default) | `latest`, `vX.X.X` | Playwright | Most users, better stability |
| Rod | `latest-rod`, `vX.X.X-rod` | Rod/Chromium | Lightweight, faster startup |

```bash
# Playwright version
docker pull gosom/google-maps-scraper

# Rod version
docker pull gosom/google-maps-scraper:latest-rod
```

### Build from Source

Requirements: Go 1.25.6+

```bash
git clone https://github.com/gosom/google-maps-scraper.git
cd google-maps-scraper
go mod download

# Playwright version (default)
go build
./google-maps-scraper -input example-queries.txt -results results.csv -exit-on-inactivity 3m

# Rod version (alternative)
go build -tags rod
./google-maps-scraper -input example-queries.txt -results results.csv -exit-on-inactivity 3m
```

---

## Quick Start

### Web UI

```bash
mkdir -p gmapsdata && docker run -v $PWD/gmapsdata:/gmapsdata -p 8080:8080 gosom/google-maps-scraper -data-folder /gmapsdata
```

Then access `http://localhost:8080`

### Command Line

```bash
touch results.csv && docker run \
  -v $PWD/example-queries.txt:/example-queries \
  -v $PWD/results.csv:/results.csv \
  gosom/google-maps-scraper \
  -depth 1 \
  -input /example-queries \
  -results /results.csv \
  -exit-on-inactivity 3m
```

### REST API

Available in web server mode. Full OpenAPI 3.0.3 docs at `http://localhost:8080/api/docs`

Key Endpoints:
- `POST /api/v1/jobs` — Create scraping job
- `GET /api/v1/jobs` — List all jobs
- `GET /api/v1/jobs/{id}` — Get job details
- `DELETE /api/v1/jobs/{id}` — Delete job
- `GET /api/v1/jobs/{id}/download` — Download CSV results

---

## Complete Command-Line Options

```
Usage: google-maps-scraper [options]

Core Options:
  -input string       Path to input file with queries (one per line)
  -results string     Output file path (default: stdout)
  -json               Output JSON instead of CSV
  -depth int          Max scroll depth in results (default: 10)
  -c int              Concurrency level (default: half of CPU cores)

Email & Reviews:
  -email              Extract emails from business websites
  -extra-reviews      Collect extended reviews (up to ~300)

Location Settings:
  -lang string        Language code, e.g., 'de' for German (default: "en")
  -geo string         Coordinates for search, e.g., '37.7749,-122.4194'
  -zoom int           Zoom level 0-21 (default: 15)
  -radius float       Search radius in meters (default: 10000)

Web Server:
  -web                Run web server mode
  -addr string        Server address (default: ":8080")
  -data-folder        Data folder for web runner (default: "webdata")

Database:
  -dsn string         PostgreSQL connection string
  -produce            Produce seed jobs only (requires -dsn)

Proxy:
  -proxies string     Comma-separated proxy list
                      Format: protocol://user:pass@host:port

Export:
  -leadsdb-api-key    Export directly to LeadsDB

Advanced:
  -exit-on-inactivity duration   Exit after inactivity (e.g., '5m')
  -fast-mode                     Quick mode with reduced data
  -debug                         Show browser window
  -writer string                 Custom writer plugin (format: 'dir:pluginName')
```

---

## Extracted Data Points (34 Total)

| # | Field | Description |
|---|-------|-------------|
| 1 | `input_id` | Internal identifier for input query |
| 2 | `link` | Direct URL to Google Maps listing |
| 3 | `title` | Business name |
| 4 | `category` | Business type (Restaurant, Hotel, etc.) |
| 5 | `address` | Street address |
| 6 | `open_hours` | Operating hours |
| 7 | `popular_times` | Visitor traffic patterns |
| 8 | `website` | Official business website |
| 9 | `phone` | Contact phone number |
| 10 | `plus_code` | Location shortcode |
| 11 | `review_count` | Total number of reviews |
| 12 | `review_rating` | Average star rating |
| 13 | `reviews_per_rating` | Breakdown by star rating |
| 14 | `latitude` | GPS latitude |
| 15 | `longitude` | GPS longitude |
| 16 | `cid` | Google's unique Customer ID |
| 17 | `status` | Business status (open/closed/temporary) |
| 18 | `descriptions` | Business description |
| 19 | `reviews_link` | Direct link to reviews |
| 20 | `thumbnail` | Thumbnail image URL |
| 21 | `timezone` | Business timezone |
| 22 | `price_range` | Price level ($, $$, $$$) |
| 23 | `data_id` | Internal Google Maps identifier |
| 24 | `images` | Associated image URLs |
| 25 | `reservations` | Reservation booking link |
| 26 | `order_online` | Online ordering link |
| 27 | `menu` | Menu link |
| 28 | `owner` | Owner-claimed status |
| 29 | `complete_address` | Full formatted address |
| 30 | `about` | Additional business info |
| 31 | `user_reviews` | Customer reviews (text, rating, timestamp) |
| 32 | `emails` | Extracted email addresses (requires `-email` flag) |
| 33 | `user_reviews_extended` | Extended reviews up to ~300 (requires `-extra-reviews`) |
| 34 | `place_id` | Google's unique place id |

Custom Input IDs:
```
Matsuhisa Athens #!#MyCustomID
```

---

## Proxy Configuration

### Basic Usage

```bash
./google-maps-scraper \
  -input queries.txt \
  -results results.csv \
  -proxies 'socks5://user:pass@host:port,http://host2:port2' \
  -depth 1 -c 2
```

Supported protocols: `socks5`, `socks5h`, `http`, `https`

---

## Email Extraction

Disabled by default. When enabled, visits each business website to find emails.

```bash
./google-maps-scraper -input queries.txt -results results.csv -email
```

**Note:** Significantly increases processing time.

---

## Fast Mode (Beta)

Returns up to 21 results per query, ordered by distance.

```bash
./google-maps-scraper \
  -input queries.txt \
  -results results.csv \
  -fast-mode \
  -zoom 15 \
  -radius 5000 \
  -geo '37.7749,-122.4194'
```

**Warning:** Beta — you may experience blocking.

---

## LeadsDB Integration

Send leads directly to managed database for deduplication and filtering.

### Docker
```bash
docker run \
  -v $PWD/example-queries.txt:/example-queries \
  gosom/google-maps-scraper \
  -depth 1 \
  -input /example-queries \
  -leadsdb-api-key "your-api-key" \
  -exit-on-inactivity 3m
```

### Environment Variable
```bash
export LEADSDB_API_KEY="your-api-key"
./google-maps-scraper -input queries.txt -exit-on-inactivity 3m
```

### Field Mapping (Google Maps → LeadsDB)

| Google Maps | LeadsDB |
|-------------|---------|
| Title | Name |
| Category | Category |
| Categories | Tags |
| Phone | Phone |
| Website | Website |
| Address | Address, City, State, Country, PostalCode |
| Latitude/Longitude | Coordinates |
| Review Rating | Rating |
| Review Count | ReviewCount |
| Emails | Email |
| Thumbnail | LogoURL |
| CID | SourceID |

---

## Advanced Usage

### PostgreSQL Database Provider

Use `-dsn` flag with PostgreSQL connection string for database-backed storage and distributed scraping.

### Kubernetes Deployment

Scale from single machine to Kubernetes clusters for production.

### Custom Writer Plugins

Create Go-based writer plugins for specialized output:
```
-writer 'dir:pluginName'
```

---

## License

MIT License — Free for personal and commercial use.

## Legal Notice

This tool is provided for lawful purposes only. Users must comply with applicable laws and website terms of service when scraping data.
