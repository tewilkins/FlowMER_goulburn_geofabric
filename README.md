# FlowMER_goulburn_geofabric

Analysis and wrangling of BoM geofabric data for the Goulburn River and related territories.

## Overview

This repository provides tools to extract and process spatial data from the Australian Bureau of Meteorology (BoM) Geofabric dataset, specifically for the Goulburn River region. The Geofabric provides a nationally consistent set of spatial features for Australia's surface water, including streams, rivers, and catchment boundaries.

## Purpose

The extracted data supports analysis of ecological data in the Goulburn River by providing:
- **Stream geometry**: High-resolution river and stream network lines
- **Catchment boundaries**: Watershed/catchment polygon boundaries

## Data Source

Data is sourced from the Australian Bureau of Meteorology Geofabric:
- **Website**: https://www.bom.gov.au/water/geofabric/download.shtml
- **Dataset**: Surface Hydrology (SH) Network and Catchment data
- **Region**: Goulburn-Broken basin (Basin ID: 4040)

## Installation

### Prerequisites

This project uses R for spatial data processing. You'll need:
- R (version 4.0 or later recommended)
- The following R packages:
  - `sf` - Simple Features for R (spatial data)
  - `dplyr` - Data manipulation
  - `httr` - HTTP tools (optional, for downloading)

### Installing R Packages

```r
install.packages(c("sf", "dplyr", "httr"))
```

## Usage

### Step 1: Download Geofabric Data

1. Visit https://www.bom.gov.au/water/geofabric/download.shtml
2. Download the Surface Hydrology (SH) data for the Goulburn-Broken basin
3. Extract the downloaded data to the `data/` directory in this repository

Expected directory structure:
```
data/
├── SH_Network/
│   └── HR_Streams.shp (or HR_Stream.shp)
└── SH_Catchment/
    └── HR_Catchments.shp (or HR_Catchment.shp)
```

### Step 2: Run the Extraction Workflow

Run the main workflow script to extract stream geometry and catchment boundaries:

```r
source("scripts/main_workflow.R")
```

Or run individual extraction scripts:

```r
# Extract stream geometry only
source("R/extract_streams.R")
streams <- extract_stream_geometry(data_dir = "data", output_dir = "output")

# Extract catchment boundaries only
source("R/extract_catchments.R")
catchments <- extract_catchment_boundaries(data_dir = "data", output_dir = "output")
```

### Step 3: Use the Extracted Data

The extracted data will be saved in the `output/` directory as:
- `goulburn_streams.shp` - Stream network shapefile
- `goulburn_streams.geojson` - Stream network GeoJSON
- `goulburn_catchments.shp` - Catchment boundaries shapefile
- `goulburn_catchments.geojson` - Catchment boundaries GeoJSON

You can now use these files in:
- GIS software (QGIS, ArcGIS)
- R spatial analysis
- Web mapping applications
- Ecological data analysis workflows

## Repository Structure

```
FlowMER_goulburn_geofabric/
├── R/
│   ├── download_geofabric.R    # Functions to check/download geofabric data
│   ├── extract_streams.R       # Extract stream geometry
│   └── extract_catchments.R    # Extract catchment boundaries
├── scripts/
│   └── main_workflow.R         # Main workflow script
├── data/                       # Place downloaded geofabric data here
├── output/                     # Extracted shapefiles and GeoJSON
├── .gitignore
├── LICENSE
└── README.md
```

## Functions

### Download and Check Functions

- `download_geofabric()` - Provides instructions for downloading geofabric data
- `check_geofabric_data()` - Checks if geofabric data exists in the data directory

### Extraction Functions

- `extract_stream_geometry()` - Extracts stream network lines from geofabric data
- `extract_catchment_boundaries()` - Extracts catchment polygon boundaries
- `get_stream_stats()` - Calculates statistics for extracted streams
- `get_catchment_stats()` - Calculates statistics for extracted catchments

## Example Analysis

```r
# Load the required libraries
library(sf)
library(dplyr)

# Load extracted data
streams <- st_read("output/goulburn_streams.shp")
catchments <- st_read("output/goulburn_catchments.shp")

# Calculate total stream length
total_length <- sum(st_length(streams))
cat("Total stream length:", round(total_length / 1000, 2), "km\n")

# Calculate total catchment area
total_area <- sum(st_area(catchments))
cat("Total catchment area:", round(total_area / 1e6, 2), "km²\n")

# Plot the data
plot(st_geometry(catchments), col = "lightblue", border = "blue")
plot(st_geometry(streams), col = "darkblue", add = TRUE)
title("Goulburn River Catchment and Stream Network")
```

## Data Format

The geofabric data uses the following coordinate reference systems:
- **Common CRS**: GDA94 (EPSG:4283) or GDA2020 (EPSG:7844)
- Data can be transformed to other CRS as needed using `st_transform()`

## Contributing

This is a research/analysis repository. If you have improvements or find issues:
1. Open an issue describing the problem or enhancement
2. Submit a pull request with your changes

## License

MIT License - see LICENSE file for details

## Citation

If you use this repository in your research, please cite:
- The BoM Geofabric data source: http://www.bom.gov.au/water/geofabric/
- This repository: tewilkins/FlowMER_goulburn_geofabric

## Contact

For questions or issues, please open an issue on GitHub.

## Acknowledgments

- Australian Bureau of Meteorology for providing the Geofabric dataset
- The R spatial community for the excellent `sf` package
