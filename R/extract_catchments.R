#' Extract Catchment Boundaries from BoM Geofabric Data
#'
#' This script extracts catchment boundary polygons from the BoM Geofabric
#' Surface Hydrology dataset for the Goulburn River region.
#'
#' The script:
#' 1. Loads the catchment boundary data
#' 2. Filters for catchments in the Goulburn River region
#' 3. Exports the catchment geometry as shapefiles and GeoJSON

library(sf)
library(dplyr)

#' Extract catchment boundaries from geofabric data
#'
#' @param data_dir Directory containing the geofabric data
#' @param output_dir Directory to save extracted catchment boundaries
#' @param catchment_layer Name of the catchment layer
#' @param goulburn_filter Apply filter for Goulburn River? (default: TRUE)
#'
#' @return sf object containing catchment geometry
extract_catchment_boundaries <- function(data_dir = "data",
                                         output_dir = "output",
                                         catchment_layer = "HR_Catchments",
                                         goulburn_filter = TRUE) {
  
  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Potential locations for catchment data in geofabric
  catchment_paths <- c(
    file.path(data_dir, "SH_Catchment", "HR_Catchments.shp"),
    file.path(data_dir, "SH_Catchment", "HR_Catchment.shp"),
    file.path(data_dir, "SH_Network.gdb"),
    file.path(data_dir, "SH_Catchments.gdb"),
    file.path(data_dir, "Catchments", "HR_Catchments.shp")
  )
  
  # Find the first existing path
  catchment_path <- NULL
  for (path in catchment_paths) {
    if (file.exists(path) || dir.exists(path)) {
      catchment_path <- path
      break
    }
  }
  
  if (is.null(catchment_path)) {
    stop("Catchment data not found. Please ensure geofabric data is downloaded.\n",
         "Expected locations:\n",
         paste(catchment_paths, collapse = "\n"))
  }
  
  cat("Loading catchment data from:", catchment_path, "\n")
  
  # Read catchment data
  # If it's a geodatabase, we need to specify the layer
  if (grepl("\\.gdb$", catchment_path)) {
    # List layers in geodatabase
    layers <- st_layers(catchment_path)
    cat("Available layers:\n")
    print(layers$name)
    
    # Try to find catchment layer
    catchment_layer_name <- grep("Catchment", layers$name, value = TRUE, ignore.case = TRUE)[1]
    if (is.na(catchment_layer_name)) {
      catchment_layer_name <- layers$name[1]
      cat("Using first layer:", catchment_layer_name, "\n")
    }
    
    catchments <- st_read(catchment_path, layer = catchment_layer_name, quiet = FALSE)
  } else {
    catchments <- st_read(catchment_path, quiet = FALSE)
  }
  
  cat("\nOriginal catchment data:\n")
  cat("- Features:", nrow(catchments), "\n")
  cat("- CRS:", st_crs(catchments)$input, "\n")
  
  # Filter for Goulburn River catchment if requested
  if (goulburn_filter) {
    cat("\nFiltering for Goulburn River catchment...\n")
    
    # Try different column names that might contain catchment names or IDs
    name_cols <- c("Name", "CATCHNAME", "CatchmentName", "BASINNAME",
                   "basin_name", "catchment_name", "DIVNAME", "AHGFCATCHM")
    
    existing_cols <- intersect(names(catchments), name_cols)
    
    if (length(existing_cols) > 0) {
      cat("Available name columns:", paste(existing_cols, collapse = ", "), "\n")
      
      # Filter for features containing "Goulburn" in any name column
      goulburn_catchments <- catchments %>%
        filter(if_any(all_of(existing_cols), ~ grepl("Goulburn", ., ignore.case = TRUE)))
      
      if (nrow(goulburn_catchments) > 0) {
        catchments <- goulburn_catchments
        cat("Filtered to", nrow(catchments), "Goulburn River catchment features\n")
      } else {
        cat("Note: No features found with 'Goulburn' in name fields.\n")
        cat("Proceeding with all catchment features.\n")
      }
    } else {
      cat("Note: No standard name columns found.\n")
      cat("Available columns:", paste(names(catchments), collapse = ", "), "\n")
      cat("Proceeding with all catchment features.\n")
    }
  }
  
  # Export to shapefile
  shapefile_path <- file.path(output_dir, "goulburn_catchments.shp")
  cat("\nExporting to shapefile:", shapefile_path, "\n")
  st_write(catchments, shapefile_path, delete_dsn = TRUE, quiet = FALSE)
  
  # Export to GeoJSON
  geojson_path <- file.path(output_dir, "goulburn_catchments.geojson")
  cat("Exporting to GeoJSON:", geojson_path, "\n")
  st_write(catchments, geojson_path, delete_dsn = TRUE, quiet = FALSE)
  
  cat("\nCatchment boundary extraction complete!\n")
  cat("Output files:\n")
  cat("- Shapefile:", shapefile_path, "\n")
  cat("- GeoJSON:", geojson_path, "\n")
  
  return(catchments)
}

#' Get catchment statistics
#'
#' @param catchments sf object containing catchment geometry
#'
#' @return List of statistics
get_catchment_stats <- function(catchments) {
  
  stats <- list(
    n_features = nrow(catchments),
    total_area_m2 = sum(st_area(catchments)),
    crs = st_crs(catchments)$input,
    bbox = st_bbox(catchments)
  )
  
  cat("\nCatchment Statistics:\n")
  cat("- Number of features:", stats$n_features, "\n")
  cat("- Total area:", round(stats$total_area_m2 / 1e6, 2), "km²\n")
  cat("- CRS:", stats$crs, "\n")
  cat("- Bounding box:\n")
  print(stats$bbox)
  
  return(stats)
}

# Main execution
if (!interactive()) {
  catchments <- extract_catchment_boundaries()
  get_catchment_stats(catchments)
}
