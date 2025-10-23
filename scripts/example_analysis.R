#' Example Analysis: Goulburn River Stream Network and Catchment
#'
#' This script demonstrates how to use the extracted geofabric data
#' for ecological analysis of the Goulburn River.
#'
#' Prerequisites: Run scripts/main_workflow.R first to extract the data

library(sf)
library(dplyr)

# Load the extracted data
cat("Loading extracted geofabric data...\n")

streams_file <- "output/goulburn_streams.shp"
catchments_file <- "output/goulburn_catchments.shp"

# Check if files exist
if (!file.exists(streams_file)) {
  stop("Stream data not found. Please run scripts/main_workflow.R first.")
}

if (!file.exists(catchments_file)) {
  stop("Catchment data not found. Please run scripts/main_workflow.R first.")
}

# Read the data
streams <- st_read(streams_file, quiet = TRUE)
catchments <- st_read(catchments_file, quiet = TRUE)

cat("\n=== Data Summary ===\n")
cat("Streams:\n")
cat("  - Features:", nrow(streams), "\n")
cat("  - CRS:", st_crs(streams)$input, "\n")

cat("\nCatchments:\n")
cat("  - Features:", nrow(catchments), "\n")
cat("  - CRS:", st_crs(catchments)$input, "\n")

# Calculate stream metrics
cat("\n=== Stream Network Metrics ===\n")

# Total stream length
stream_lengths <- st_length(streams)
total_length_km <- sum(stream_lengths) / 1000

cat("Total stream length:", round(total_length_km, 2), "km\n")
cat("Mean segment length:", round(mean(stream_lengths), 2), "m\n")
cat("Max segment length:", round(max(stream_lengths), 2), "m\n")

# Calculate catchment metrics
cat("\n=== Catchment Metrics ===\n")

# Total catchment area
catchment_areas <- st_area(catchments)
total_area_km2 <- sum(catchment_areas) / 1e6

cat("Total catchment area:", round(total_area_km2, 2), "km²\n")
cat("Number of sub-catchments:", nrow(catchments), "\n")
cat("Mean sub-catchment area:", round(mean(catchment_areas) / 1e6, 2), "km²\n")

# Calculate stream density
cat("\n=== Stream Density ===\n")
stream_density <- total_length_km / total_area_km2
cat("Stream density:", round(stream_density, 2), "km/km²\n")

# Create a simple visualization
cat("\n=== Creating visualization ===\n")

# Set up plot
png("output/goulburn_overview.png", width = 1200, height = 800, res = 150)

# Plot catchment boundaries
plot(st_geometry(catchments), 
     col = "lightblue", 
     border = "blue", 
     main = "Goulburn River Catchment and Stream Network",
     lwd = 1.5)

# Add stream network
plot(st_geometry(streams), 
     col = "darkblue", 
     add = TRUE, 
     lwd = 0.8)

# Add legend
legend("topright", 
       legend = c("Catchment Boundary", "Stream Network"),
       col = c("blue", "darkblue"),
       lty = c(1, 1),
       lwd = c(1.5, 0.8),
       bg = "white")

# Add scale bar and north arrow (simplified)
# Note: For production use, consider using packages like 'ggspatial'

dev.off()

cat("Visualization saved to: output/goulburn_overview.png\n")

# Calculate bounding box
cat("\n=== Spatial Extent ===\n")
bbox <- st_bbox(catchments)
cat("Bounding box:\n")
cat("  - West:", round(bbox["xmin"], 4), "\n")
cat("  - East:", round(bbox["xmax"], 4), "\n")
cat("  - South:", round(bbox["ymin"], 4), "\n")
cat("  - North:", round(bbox["ymax"], 4), "\n")

# Example: Export statistics to CSV
cat("\n=== Exporting Statistics ===\n")

# Create a summary data frame
summary_stats <- data.frame(
  Metric = c(
    "Total Stream Length (km)",
    "Total Catchment Area (km²)",
    "Number of Stream Segments",
    "Number of Sub-catchments",
    "Stream Density (km/km²)",
    "Mean Segment Length (m)",
    "Mean Sub-catchment Area (km²)"
  ),
  Value = c(
    round(total_length_km, 2),
    round(total_area_km2, 2),
    nrow(streams),
    nrow(catchments),
    round(stream_density, 2),
    round(mean(stream_lengths), 2),
    round(mean(catchment_areas) / 1e6, 2)
  )
)

# Save to CSV
write.csv(summary_stats, "output/goulburn_statistics.csv", row.names = FALSE)
cat("Statistics saved to: output/goulburn_statistics.csv\n")

cat("\n=== Analysis Complete ===\n")
cat("The extracted geofabric data is ready for ecological analysis!\n")
cat("\nSuggested next steps:\n")
cat("1. Overlay with ecological monitoring sites\n")
cat("2. Analyze stream connectivity and network topology\n")
cat("3. Calculate catchment characteristics (slope, aspect, etc.)\n")
cat("4. Integrate with water quality or biodiversity data\n")
