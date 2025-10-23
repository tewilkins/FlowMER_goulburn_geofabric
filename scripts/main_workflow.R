#' Main Workflow for Extracting Goulburn River Geofabric Data
#'
#' This script provides a complete workflow for downloading and extracting
#' stream geometry and catchment boundaries from the BoM Geofabric dataset
#' for the Goulburn River region.
#'
#' Usage:
#'   source("scripts/main_workflow.R")
#'
#' Or run individual steps as needed.

# Load required libraries
required_packages <- c("sf", "dplyr", "httr")

# Check and install missing packages
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing package:", pkg, "\n")
    install.packages(pkg, repos = "https://cloud.r-project.org/")
    library(pkg, character.only = TRUE)
  }
}

# Source the extraction scripts
source("R/download_geofabric.R")
source("R/extract_streams.R")
source("R/extract_catchments.R")

cat(paste0(paste(rep("=", 62), collapse = ""), "\n"))
cat("Goulburn River Geofabric Data Extraction Workflow\n")
cat(paste0(paste(rep("=", 62), collapse = ""), "\n\n"))

# Step 1: Check for geofabric data
cat("Step 1: Checking for geofabric data...\n")
cat(paste0(paste(rep("-", 62), collapse = ""), "\n"))

data_exists <- check_geofabric_data(data_dir = "data")

if (!data_exists) {
  cat("\nPlease download the BoM Geofabric data before continuing.\n")
  download_geofabric(data_dir = "data")
  stop("Geofabric data not found. Please download and try again.")
}

cat("\n")

# Step 2: Extract stream geometry
cat("Step 2: Extracting stream geometry...\n")
cat(paste0(paste(rep("-", 62), collapse = ""), "\n"))

streams <- tryCatch({
  extract_stream_geometry(
    data_dir = "data",
    output_dir = "output",
    goulburn_filter = TRUE
  )
}, error = function(e) {
  cat("Error extracting streams:", e$message, "\n")
  cat("You may need to manually specify the stream layer.\n")
  NULL
})

if (!is.null(streams)) {
  stream_stats <- get_stream_stats(streams)
}

cat("\n")

# Step 3: Extract catchment boundaries
cat("Step 3: Extracting catchment boundaries...\n")
cat(paste0(paste(rep("-", 62), collapse = ""), "\n"))

catchments <- tryCatch({
  extract_catchment_boundaries(
    data_dir = "data",
    output_dir = "output",
    goulburn_filter = TRUE
  )
}, error = function(e) {
  cat("Error extracting catchments:", e$message, "\n")
  cat("You may need to manually specify the catchment layer.\n")
  NULL
})

if (!is.null(catchments)) {
  catchment_stats <- get_catchment_stats(catchments)
}

cat("\n")

# Step 4: Summary
cat(paste0(paste(rep("=", 62), collapse = ""), "\n"))
cat("Workflow Complete!\n")
cat(paste0(paste(rep("=", 62), collapse = ""), "\n\n"))

cat("Extracted data saved to the 'output' directory:\n")
cat("- Stream geometry: output/goulburn_streams.shp and .geojson\n")
cat("- Catchment boundaries: output/goulburn_catchments.shp and .geojson\n\n")

cat("Next steps:\n")
cat("1. Load the shapefiles in QGIS or other GIS software for visualization\n")
cat("2. Use the extracted data for ecological analysis\n")
cat("3. Combine with other ecological datasets for the Goulburn River\n")
