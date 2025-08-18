#!/bin/bash

# Script para preparar el proyecto para despliegue en Vercel

echo "🚀 Preparando proyecto Flutter para Vercel..."

# Verificar que Flutter esté instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado. Por favor instala Flutter primero."
    exit 1
fi

# Obtener dependencias
echo "📦 Obteniendo dependencias..."
flutter pub get

# Construir para web
echo "🔨 Construyendo proyecto..."
flutter build web --release

echo "✅ ¡Proyecto listo para despliegue!"
echo "📁 Los archivos están en build/web/"
echo "🌐 Ahora puedes hacer deploy a Vercel usando 'vercel' command"
