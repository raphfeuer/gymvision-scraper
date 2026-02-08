# GymVision Scraper

Scrape gyms from Google Maps and export to CSV. Built on top of [gosom/google-maps-scraper](https://github.com/gosom/google-maps-scraper).

56 cities pre-configured across 7 countries.

## Install (from scratch)

### 1. Prerequisites (clean Mac)

```bash
# Install Xcode Command Line Tools (git, etc.)
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Go
brew install go
```

Python 3 comes pre-installed on macOS. Verify with `python3 --version`.

### 2. Setup

```bash
git clone git@github.com:raphfeuer/gymvision-scraper.git
cd gymvision-scraper
./gymvision-scraper install          # builds binary, adds to PATH
source ~/.zshrc                      # reload shell (one time)
gymvision-scraper install queries    # install all 56 city packs
```

### 3. Scrape

```bash
gymvision-scraper scrape paris
```

## Commands

```bash
gymvision-scraper install                       # Build the scraper binary
gymvision-scraper install queries               # Install all 56 city packs
gymvision-scraper install queries france canada  # Install specific countries
gymvision-scraper list                           # Show installed cities
gymvision-scraper scrape paris                   # Deep scrape (uses query pack)
gymvision-scraper scrape Tokyo                   # Quick scrape (no pack needed)
gymvision-scraper status                         # Show progress & totals
```

## Available query packs

| Country | Cities |
|---------|--------|
| Australia | adelaide, brisbane, melbourne, perth, sydney |
| Belgium | brussels |
| Canada | calgary, edmonton, halifax, montreal, ottawa, quebec_city, toronto, vancouver, winnipeg |
| France | bordeaux, lille, lyon, marseille, montpellier, nantes, nice, paris, rennes, strasbourg, toulouse |
| Germany | berlin, cologne, dusseldorf, frankfurt, hamburg, munich, stuttgart |
| Spain | barcelona, bilbao, madrid, malaga, seville, valencia |
| UK | birmingham, bristol, edinburgh, glasgow, leeds, liverpool, london, manchester |
| USA | atlanta, austin, boston, chicago, dallas, denver, houston, los_angeles, miami, minneapolis, nashville, new_york, philadelphia, phoenix, portland, san_diego, san_francisco, seattle, washington_dc |

## Adding a new city

Create `data/queries/<country>/<city>.txt` with one query per line:

```
gym in Downtown Toronto
gym in Yorkville Toronto
gym in Liberty Village Toronto
```

Then install it: `gymvision-scraper install queries canada`

## Output

CSV with 34 fields per gym. Key fields:

| Field | Description |
|-------|-------------|
| `title` | Gym name |
| `latitude` | GPS latitude |
| `longitude` | GPS longitude |
| `address` | Street address |
| `thumbnail` | Main image URL |
| `phone` | Contact number |
| `website` | Website URL |
| `review_rating` | Average rating |
| `review_count` | Number of reviews |
| `place_id` | Google's unique ID (used for dedup) |

Full field list in [docs/README.md](docs/README.md).
