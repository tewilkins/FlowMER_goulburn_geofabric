# Quick Start Guide

This guide will help you quickly get started with extracting Goulburn River geofabric data.

## Prerequisites

1. **Install R**: Download from https://www.r-project.org/
2. **Install RStudio** (optional but recommended): Download from https://posit.co/download/rstudio-desktop/
3. **Install required R packages**:
   ```r
   install.packages(c("sf", "dplyr", "httr"))
   ```

## Quick Start (3 Steps)

### Step 1: Download Geofabric Data

1. Visit: https://www.bom.gov.au/water/geofabric/download.shtml
2. Download the **Surface Hydrology (SH) Network** data for the **Goulburn-Broken basin**
3. Extract the downloaded files to the `data/` directory in this repository

Your directory should look like:
```
data/
├── SH_Network/
│   └── HR_Streams.shp (and related files)
└── SH_Catchment/
    └── HR_Catchments.shp (and related files)
```

### Step 2: Run the Extraction Workflow

Open R or RStudio and run:

```r
# Set working directory to the repository
setwd("/path/to/FlowMER_goulburn_geofabric")

# Run the main workflow
source("scripts/main_workflow.R")
```

This will:
- Check for geofabric data
- Extract stream geometry to `output/goulburn_streams.shp`
- Extract catchment boundaries to `output/goulburn_catchments.shp`
- Create GeoJSON versions of both files

### Step 3: Explore the Data

Run the example analysis:

```r
source("scripts/example_analysis.R")
```

This will:
- Calculate stream network metrics (total length, density, etc.)
- Calculate catchment metrics (area, sub-catchments, etc.)
- Create a visualization at `output/goulburn_overview.png`
- Export statistics to `output/goulburn_statistics.csv`

## What's Next?

Now you can:
- Load the shapefiles in QGIS or ArcGIS for visualization
- Use the data in your ecological analysis workflows
- Combine with other datasets (water quality, biodiversity, etc.)

## Troubleshooting

### "Geofabric data not found" error
- Make sure you've downloaded the data from BoM
- Check that files are in the `data/` directory
- Verify the directory structure matches the expected layout

### "Package not found" error
- Install missing packages: `install.packages("package_name")`
- Common packages needed: `sf`, `dplyr`, `httr`

### Layer name issues
- If the script can't find the correct layer, check what's available:
  ```r
  library(sf)
  st_layers("data/SH_Network.gdb")
  ```
- Manually specify the layer name in the extraction functions

## File Outputs

After running the workflow, you'll have:

| File | Description |
|------|-------------|
| `output/goulburn_streams.shp` | Stream network shapefile |
| `output/goulburn_streams.geojson` | Stream network GeoJSON |
| `output/goulburn_catchments.shp` | Catchment boundaries shapefile |
| `output/goulburn_catchments.geojson` | Catchment boundaries GeoJSON |
| `output/goulburn_overview.png` | Visualization map |
| `output/goulburn_statistics.csv` | Summary statistics |

## Support

For issues or questions:
- Open an issue on GitHub
- Check the main README.md for detailed documentation
- Review the R script comments for function documentation
