#!/bin/bash

# Check if feature name is provided
if [ -z "$1" ]; then
    echo "❌ Usage: ./create_feature.sh <feature_name>"
    echo "   Example: ./create_feature.sh pokemon_list"
    exit 1
fi

FEATURE_NAME=$1

echo "🚀 Creating feature: $FEATURE_NAME"

# Create lib structure
mkdir -p lib/features/$FEATURE_NAME/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}

# Create test structure
mkdir -p test/features/$FEATURE_NAME/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}

# Create placeholder files (optional but helpful)
touch lib/features/$FEATURE_NAME/data/datasources/.gitkeep
touch lib/features/$FEATURE_NAME/data/models/.gitkeep
touch lib/features/$FEATURE_NAME/data/repositories/.gitkeep
touch lib/features/$FEATURE_NAME/domain/entities/.gitkeep
touch lib/features/$FEATURE_NAME/domain/repositories/.gitkeep
touch lib/features/$FEATURE_NAME/domain/usecases/.gitkeep
touch lib/features/$FEATURE_NAME/presentation/bloc/.gitkeep
touch lib/features/$FEATURE_NAME/presentation/pages/.gitkeep
touch lib/features/$FEATURE_NAME/presentation/widgets/.gitkeep

echo "✅ Feature '$FEATURE_NAME' created!"
echo ""
echo "📁 Structure:"
echo "   lib/features/$FEATURE_NAME/"
echo "   ├── data/"
echo "   │   ├── datasources/"
echo "   │   ├── models/"
echo "   │   └── repositories/"
echo "   ├── domain/"
echo "   │   ├── entities/"
echo "   │   ├── repositories/"
echo "   │   └── usecases/"
echo "   └── presentation/"
echo "       ├── bloc/"
echo "       ├── pages/"
echo "       └── widgets/"