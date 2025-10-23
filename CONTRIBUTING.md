# Contributing to FlowMER Goulburn Geofabric

Thank you for your interest in contributing to this project! This repository helps extract and analyze BoM geofabric data for the Goulburn River region.

## How to Contribute

### Reporting Issues

If you encounter problems or have suggestions:
1. Check existing issues to avoid duplicates
2. Open a new issue with a clear description
3. Include relevant information:
   - R version
   - Package versions
   - Error messages
   - Expected vs. actual behavior

### Suggesting Enhancements

We welcome ideas for improvements:
- New extraction features
- Additional analysis scripts
- Better documentation
- Performance improvements
- Support for additional data sources

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**:
   - Follow the existing code style
   - Add comments for complex logic
   - Update documentation if needed
4. **Test your changes**:
   - Ensure scripts run without errors
   - Test with actual geofabric data if possible
5. **Commit your changes**:
   ```bash
   git commit -m "Add feature: description"
   ```
6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request**

## Code Style Guidelines

### R Code Style

- Use 2 spaces for indentation (not tabs)
- Use `<-` for assignment (not `=`)
- Use descriptive variable names
- Add roxygen-style comments for functions:
  ```r
  #' Function description
  #'
  #' @param param_name Description
  #' @return Return value description
  ```
- Keep lines under 80 characters when possible

### File Organization

- Place reusable functions in `R/` directory
- Place workflow scripts in `scripts/` directory
- Keep data files in `data/` (gitignored)
- Save outputs to `output/` (gitignored)

### Documentation

- Update README.md for major changes
- Add examples for new features
- Document any new dependencies

## Development Setup

1. Clone the repository
2. Install R and required packages
3. Download sample geofabric data for testing
4. Test existing scripts before making changes

## Testing

While we don't have automated tests yet, please:
- Test your changes with real geofabric data
- Verify outputs are correct
- Check for error handling
- Document any assumptions or limitations

## Questions?

Feel free to open an issue with the label "question" if you need help or clarification.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
