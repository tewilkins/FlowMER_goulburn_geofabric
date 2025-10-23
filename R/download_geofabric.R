#' Download BoM Geofabric Data for Goulburn Region
#'
#' This script downloads the Australian Bureau of Meteorology (BoM) Geofabric 
#' data for the Goulburn River region. The Geofabric provides a nationally 
#' consistent set of spatial features for Australia's surface water, including
#' streams, rivers, and catchments.
#'
#' Data source: https://www.bom.gov.au/water/geofabric/download.shtml
#'
#' The script downloads the Surface Hydrology (SH) dataset which includes:
#' - Stream network lines
#' - Catchment boundaries
#' - Water bodies

library(httr)
library(sf)

#' Download Geofabric data for a specific region
#'
#' @param region_name Name of the region (e.g., "GoulburnBroken")
#' @param data_dir Directory to store downloaded data
#' @param base_url Base URL for BoM Geofabric downloads
#'
#' @return Path to the downloaded and extracted data directory
download_geofabric <- function(region_name = "GoulburnBroken",
                               data_dir = "data",
                               base_url = "http://www.bom.gov.au/water/geofabric/data") {
  
  # Create data directory if it doesn't exist
  if (!dir.exists(data_dir)) {
    dir.create(data_dir, recursive = TRUE)
  }
  
  # Construct download URL for Surface Hydrology (SH) dataset
  # The Goulburn River is in the Goulburn-Broken basin (basin ID: 4040)
  zip_file <- file.path(data_dir, paste0("SH_Network_", region_name, ".zip"))
  
  # Note: This is a placeholder URL structure. 
  # Actual BoM geofabric data may need to be downloaded manually from:
  # https://www.bom.gov.au/water/geofabric/download.shtml
  # or accessed via their FTP or other distribution methods
  
  cat("Note: BoM Geofabric data should be downloaded from:\n")
  cat("https://www.bom.gov.au/water/geofabric/download.shtml\n\n")
  cat("Please download the Surface Hydrology (SH) network data for the\n")
  cat("Goulburn-Broken basin and place it in the '", data_dir, "' directory.\n\n", sep = "")
  cat("Expected file structure:\n")
  cat("- Stream network (lines): SH_Network/HR_Stream/\n")
  cat("- Catchments (polygons): SH_Catchment/\n")
  cat("- Water bodies (polygons): SH_Waterbody/\n\n")
  
  return(data_dir)
}

#' Check if geofabric data exists in the data directory
#'
#' @param data_dir Directory where geofabric data should be located
#'
#' @return Logical indicating if data exists
check_geofabric_data <- function(data_dir = "data") {
  
  # Check for common geofabric directory structures
  required_dirs <- c(
    file.path(data_dir, "SH_Network"),
    file.path(data_dir, "SH_Catchment")
  )
  
  exists <- sapply(required_dirs, dir.exists)
  
  if (all(exists)) {
    cat("Geofabric data found in:", data_dir, "\n")
    return(TRUE)
  } else {
    cat("Geofabric data not found. Please download from BoM.\n")
    return(FALSE)
  }
}

# Main execution
if (!interactive()) {
  download_geofabric()
}
