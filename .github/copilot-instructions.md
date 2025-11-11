# GitHub Copilot Instructions

## Project Overview
This is a Flutter package providing a responsive data table widget. The core architecture consists of two main components: `ResponsiveDatatable` (the main widget) and `DatatableHeader` (column configuration), with adaptive responsive behavior powered by the `adaptivex` package.

## Architecture Patterns

### Core Components
- **`lib/src/responsive_datatable.dart`**: Main stateful widget handling table rendering, sorting, selection, and mobile-responsive list view
- **`lib/src/datatable_header.dart`**: Column configuration class with support for custom builders, sorting, and editing
- **`lib/responsive_table.dart`**: Package entry point exporting main classes and `adaptivex` dependency

### State Management Pattern
The component uses a three-tier data structure:
```dart
List<Map<String, dynamic>> _sourceOriginal = []; // Complete dataset
List<Map<String, dynamic>> _sourceFiltered = []; // After search/filter
List<Map<String, dynamic>> _source = [];         // Current page slice
```

### Responsive Design
- Uses `ScreenSize` enum from `adaptivex` package for breakpoint detection
- Automatically switches between table view (large screens) and list view (small screens)
- Default responsive breakpoints: `[ScreenSize.xs, ScreenSize.sm, ScreenSize.md]`

## Key Conventions

### Data Structure
- All table data must be `List<Map<String, dynamic>>`
- Each row map should have consistent key names matching `DatatableHeader.value`
- Selection uses the entire row object, not just IDs

### Header Configuration
```dart
DatatableHeader(
  text: "Display Name",
  value: "data_key",           // Must match map key
  sortable: true,
  editable: false,             // Enables inline editing
  sourceBuilder: (value, row) => Widget(), // Custom cell rendering
  headerBuilder: (value) => Widget(),      // Custom header rendering
)
```

### Pagination Pattern
- Manual pagination with `_currentPage`, `_currentPerPage`, `_total`
- Use `_resetData(start: int)` for page navigation
- Always update `_expanded` list when page size changes

## Development Workflows

### Running Examples
```bash
cd example
flutter run
```

### Package Testing
The package has minimal test coverage. Tests are located in `test/` but currently only contain setup boilerplate.

### Styling Customization
New in v0.2.0+2: Use decoration and text style properties:
```dart
ResponsiveDatatable(
  headerDecoration: BoxDecoration(), // Style header row
  rowDecoration: BoxDecoration(),    // Style data rows
  selectedDecoration: BoxDecoration(), // Style selected rows
  headerTextStyle: TextStyle(),
  rowTextStyle: TextStyle(),
  selectedTextStyle: TextStyle(),
)
```

## Integration Points

### Dependencies
- **`adaptivex: ^0.0.1+2`**: Provides responsive screen size detection and adaptive utilities
- Standard Flutter SDK (>=2.15.1 <3.0.0)

### Common Usage Patterns
1. **Basic Setup**: Initialize headers array, setup data loading with pagination
2. **Search Implementation**: Filter `_sourceOriginal` → `_sourceFiltered` → update `_source`
3. **Sorting**: Modify `_sourceFiltered` order, reset to first page
4. **Selection**: Use `onSelect` and `onSelectAll` callbacks with `_selecteds` list
5. **Custom Rendering**: Use `sourceBuilder` for complex cell content (progress bars, buttons, etc.)

### Mobile Considerations
- On small screens, table automatically converts to expandable list view
- Use `dropContainer` property to customize expanded row content
- `isExpandRows` and `expanded` list control expansion state

## Common Gotchas
- Always call `setState()` when modifying data arrays
- Reset `_expanded` list when changing page size or filtering
- Use `isLoading` state during async operations
- `sourceBuilder` receives `(value, row)` parameters for full row context