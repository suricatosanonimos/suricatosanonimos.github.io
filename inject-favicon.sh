#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "🍃 Injetando Favicon em todos os HTML"
echo "========================================="

# Favicon code to inject
FAVICON_CODE='    <!-- Favicon / Ícone da Aba -->
    <link rel="icon" type="image/png" sizes="32x32" href="assets/icons/logo.png">
    <link rel="icon" type="image/png" sizes="16x16" href="assets/icons/logo.png">
    <link rel="apple-touch-icon" href="assets/icons/logo.png">
    <link rel="shortcut icon" href="assets/icons/logo.png">'

# Contador
count=0
skipped=0

# Procurar todos os arquivos .html
for file in $(find . -name "*.html" -type f); do
    # Verificar se já tem favicon
    if grep -q "favicon" "$file" || grep -q "apple-touch-icon" "$file"; then
        echo -e "${YELLOW}⏩ Já possui favicon:${NC} $file"
        ((skipped++))
    else
        # Injetar após a tag <title> ou antes de </head>
        if grep -q "<title>" "$file"; then
            # Inserir após a tag <title>
            sed -i "s|</title>|</title>\n${FAVICON_CODE}|" "$file"
            echo -e "${GREEN}✅ Injetado em:${NC} $file"
            ((count++))
        elif grep -q "</head>" "$file"; then
            # Inserir antes de </head> se não encontrar <title>
            sed -i "s|</head>|${FAVICON_CODE}\n</head>|" "$file"
            echo -e "${GREEN}✅ Injetado em (via </head>):${NC} $file"
            ((count++))
        else
            echo -e "${RED}❌ Falhou (sem </head>):${NC} $file"
        fi
    fi
done

echo "========================================="
echo -e "${GREEN}✅ Concluído!${NC}"
echo "   📄 Arquivos modificados: $count"
echo "   ⏩ Já tinham favicon: $skipped"
echo "========================================="
