#!/bin/bash
# Fix imports in all test files

find test/features -name "*_test.dart" -type f | while read file; do
  sed -i '' -E "s|import '../../../../../lib/src/|import 'package:flutter_template/src/|g" "$file"
  sed -i '' -E "s|import '../../../../lib/src/|import 'package:flutter_template/src/|g" "$file"
  sed -i '' -E "s|import '../../../lib/src/|import 'package:flutter_template/src/|g" "$file"
  sed -i '' -E "s|import '../../lib/src/|import 'package:flutter_template/src/|g" "$file"
  echo "Fixed: $file"
done

echo "All imports fixed!"
