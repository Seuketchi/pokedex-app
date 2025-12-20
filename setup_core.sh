#!/bin/bash

echo "🚀 Setting up core structure..."

mkdir -p lib/core/{constants,error,network,usecases,utils}
mkdir -p test/core/{constants,error,network,usecases,utils}
mkdir -p test/{fixtures,helpers}

touch lib/core/constants/.gitkeep
touch lib/core/error/.gitkeep
touch lib/core/network/.gitkeep
touch lib/core/usecases/.gitkeep
touch lib/core/utils/.gitkeep

echo "✅ Core structure created!"
echo ""
echo "📁 Structure:"
echo "   lib/core/"
echo "   ├── constants/"
echo "   ├── error/"
echo "   ├── network/"
echo "   ├── usecases/"
echo "   └── utils/"