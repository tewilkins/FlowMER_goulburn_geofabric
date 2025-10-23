#' Extract Stream Geometry from BoM Geofabric Data
#'
#' This script extracts stream geometry (river and stream network lines) from
#' the BoM Geofabric Surface Hydrology dataset for the Goulburn River region.
#'
#' The script:
#' 1. Loads the stream network data
#' 2. Filters for streams in the Goulburn River catchment
#' 3. Exports the stream geometry as shapefiles and GeoJSON

library(sf)
library(dplyr)

#' Extract stream geometry from geofabric data
#'
#' @param data_dir Directory containing the geofabric data
#' @param output_dir Directory to save extracted stream geometry
#' @param stream_layer Name of the stream layer (default: "HR_Streams")
#' @param goulburn_filter Apply filter for Goulburn River? (default: TRUE)
#'
#' @return sf object containing stream geometry
extract_stream_geometry <- function(data_dir = "data",
                                    output_dir = "output",
                                    stream_layer = "HR_Streams",
                                    goulburn_filter = TRUE) {
  
  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Potential locations for stream data in geofabric
  stream_paths <- c(
    file.path(data_dir, "SH_Network", "HR_Streams.shp"),
    file.path(data_dir, "SH_Network", "HR_Stream.shp"),
    file.path(data_dir, "SH_Network.gdb"),
    file.path(data_dir, "SH_Cartography", "HR_Streams.shp")
  )
  
  # Find the first existing path
  stream_path <- NULL
  for (path in stream_paths) {
    if (file.exists(path) || dir.exists(path)) {
      stream_path <- path
      break
    }
  }
  
  if (is.null(stream_path)) {
    stop("Stream data not found. Please ensure geofabric data is downloaded.\n",
         "Expected locations:\n",
         paste(stream_paths, collapse = "\n"))
  }
  
  cat("Loading stream data from:", stream_path, "\n")
  
  # Read stream data
  # If it's a geodatabase, we need to specify the layer
  if (grepl("\\.gdb$", stream_path)) {
    # List layers in geodatabase
    layers <- st_layers(stream_path)
    cat("Available layers:\n")
    print(layers$name)
    
    # Try to find stream layer
    stream_layer_name <- grep("Stream", layers$name, value = TRUE, ignore.case = TRUE)[1]
    if (is.na(stream_layer_name)) {
      stream_layer_name <- layers$name[1]
      cat("Using first layer:", stream_layer_name, "\n")
    }
    
    streams <- st_read(stream_path, layer = stream_layer_name, quiet = FALSE)
  } else {
    streams <- st_read(stream_path, quiet = FALSE)
  }
  
  cat("\nOriginal stream data:\n")
  cat("- Features:", nrow(streams), "\n")
  cat("- CRS:", st_crs(streams)$input, "\n")
  
  # Filter for Goulburn River if requested
  if (goulburn_filter) {
    cat("\nFiltering for Goulburn River catchment...\n")
    
    # Try different column names that might contain river/stream names
    name_cols <- c("Name", "STREAM_NAM", "StreamName", "RIVERNAME", 
                   "river_name", "stream_name", "HYDROID", "AUSRIVNAME")
    
    existing_cols <- intersect(names(streams), name_cols)
    
    if (length(existing_cols) > 0) {
      cat("Available name columns:", paste(existing_cols, collapse = ", "), "\n")
      
      # Filter for features containing "Goulburn" in any name column
      goulburn_streams <- streams %>%
        filter(if_any(all_of(existing_cols), ~ grepl("Goulburn", ., ignore.case = TRUE)))
      
      if (nrow(goulburn_streams) > 0) {
        streams <- goulburn_streams
        cat("Filtered to", nrow(streams), "Goulburn River features\n")
      } else {
        cat("Note: No features found with 'Goulburn' in name fields.\n")
        cat("Proceeding with all stream features.\n")
      }
    } else {
      cat("Note: No standard name columns found.\n")
      cat("Available columns:", paste(names(streams), collapse = ", "), "\n")
      cat("Proceeding with all stream features.\n")
    }
  }
  
  # Export to shapefile
  shapefile_path <- file.path(output_dir, "goulburn_streams.shp")
  cat("\nExporting to shapefile:", shapefile_path, "\n")
  st_write(streams, shapefile_path, delete_dsn = TRUE, quiet = FALSE)
  
  # Export to GeoJSON
  geojson_path <- file.path(output_dir, "goulburn_streams.geojson")
  cat("Exporting to GeoJSON:", geojson_path, "\n")
  st_write(streams, geojson_path, delete_dsn = TRUE, quiet = FALSE)
  
  cat("\nStream geometry extraction complete!\n")
  cat("Output files:\n")
  cat("- Shapefile:", shapefile_path, "\n")
  cat("- GeoJSON:", geojson_path, "\n")
  
  return(streams)
}

#' Get stream statistics
#'
#' @param streams sf object containing stream geometry
#'
#' @return List of statistics
get_stream_stats <- function(streams) {
  
  stats <- list(
    n_features = nrow(streams),
    total_length_m = sum(st_length(streams)),
    crs = st_crs(streams)$input,
    bbox = st_bbox(streams)
  )
  
  cat("\nStream Statistics:\n")
  cat("- Number of features:", stats$n_features, "\n")
  cat("- Total length:", round(stats$total_length_m / 1000, 2), "km\n")
  cat("- CRS:", stats$crs, "\n")
  cat("- Bounding box:\n")
  print(stats$bbox)
  
  return(stats)
}

# Main execution
if (!interactive()) {
  streams <- extract_stream_geometry()
  get_stream_stats(streams)
}
