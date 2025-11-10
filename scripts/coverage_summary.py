#!/usr/bin/env python3
"""
Parse LCOV coverage file and generate human-readable summary.
"""

import sys
from pathlib import Path
from collections import defaultdict


def parse_lcov(lcov_path):
    """Parse LCOV file and extract coverage data."""
    current_file = None
    files_data = {}

    with open(lcov_path, 'r') as f:
        for line in f:
            line = line.strip()

            if line.startswith('SF:'):
                # Source file
                current_file = line[3:]
                files_data[current_file] = {
                    'lines_found': 0,
                    'lines_hit': 0,
                }
            elif line.startswith('LF:'):
                # Lines found
                files_data[current_file]['lines_found'] = int(line[3:])
            elif line.startswith('LH:'):
                # Lines hit
                files_data[current_file]['lines_hit'] = int(line[3:])

    return files_data


def calculate_coverage(files_data):
    """Calculate overall and per-directory coverage."""
    # Overall totals
    total_lines = sum(data['lines_found'] for data in files_data.values())
    total_hit = sum(data['lines_hit'] for data in files_data.values())
    overall_coverage = (total_hit / total_lines * 100) if total_lines > 0 else 0

    # Per-directory totals
    dir_data = defaultdict(lambda: {'lines_found': 0, 'lines_hit': 0})

    for filepath, data in files_data.items():
        # Extract directory path
        if '/lib/src/' in filepath:
            # Get the part after lib/src/
            parts = filepath.split('/lib/src/')[1].split('/')
            if len(parts) > 1:
                # Group by first directory after src/ (core, features, etc.)
                dir_name = parts[0]
                dir_data[dir_name]['lines_found'] += data['lines_found']
                dir_data[dir_name]['lines_hit'] += data['lines_hit']

    return overall_coverage, total_lines, total_hit, dir_data


def print_summary(overall_coverage, total_lines, total_hit, dir_data):
    """Print coverage summary."""
    print("=" * 80)
    print("FLUTTER TEST COVERAGE SUMMARY")
    print("=" * 80)
    print()
    print(f"Overall Coverage: {overall_coverage:.2f}%")
    print(f"Total Lines: {total_lines}")
    print(f"Lines Hit: {total_hit}")
    print(f"Lines Missed: {total_lines - total_hit}")
    print()
    print("=" * 80)
    print("COVERAGE BY DIRECTORY")
    print("=" * 80)
    print(f"{'Directory':<30} {'Coverage':<12} {'Lines Hit/Total'}")
    print("-" * 80)

    # Sort directories by name
    for dir_name in sorted(dir_data.keys()):
        data = dir_data[dir_name]
        coverage = (data['lines_hit'] / data['lines_found'] * 100) if data['lines_found'] > 0 else 0
        print(f"{dir_name:<30} {coverage:>6.2f}%      {data['lines_hit']:>5}/{data['lines_found']:<5}")

    print("=" * 80)


def main():
    """Main entry point."""
    lcov_path = Path('coverage/lcov.info')

    if not lcov_path.exists():
        print(f"Error: Coverage file not found at {lcov_path}", file=sys.stderr)
        sys.exit(1)

    # Parse coverage data
    files_data = parse_lcov(lcov_path)

    # Calculate coverage
    overall_coverage, total_lines, total_hit, dir_data = calculate_coverage(files_data)

    # Print summary
    print_summary(overall_coverage, total_lines, total_hit, dir_data)


if __name__ == '__main__':
    main()
