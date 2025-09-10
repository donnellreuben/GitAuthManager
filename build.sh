#!/bin/bash

# GitAuthManager Build Script
# This script builds the GitAuthManager macOS application

set -e

echo "🔨 Building GitAuthManager..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf .build
rm -rf GitAuthManager.app

# Build the application
echo "⚙️  Building application..."
swift build -c release

# Create app bundle structure
echo "📦 Creating app bundle..."
mkdir -p GitAuthManager.app/Contents/MacOS
mkdir -p GitAuthManager.app/Contents/Resources

# Copy executable
cp .build/release/GitAuthManager GitAuthManager.app/Contents/MacOS/

# Copy Info.plist
cp Info.plist GitAuthManager.app/Contents/

# Create a simple app icon (placeholder)
echo "🎨 Creating app icon..."
# In a real app, you would copy a proper .icns file here
# For now, we'll just create a placeholder

echo "✅ Build complete!"
echo "📱 App bundle created: GitAuthManager.app"
echo "🚀 You can now run the app by double-clicking GitAuthManager.app"

# Optional: Run the app
if [ "$1" = "--run" ]; then
    echo "🏃 Running the app..."
    open GitAuthManager.app
fi
