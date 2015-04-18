REM This bat need awk command
REM If you using Windows OS, You install gawk
echo off
git log --numstat --pretty="%%H" | awk "NF==3 {plus+=$1; minus+=$2} END {printf(\"+%%d, -%%d, %%d\n\", plus, minus, plus - minus)}"
:: If we specify one user
:: git log --numstat --pretty="%%H" --author="yumechi-525" | awk "NF==3 {plus+=$1; minus+=$2} END {printf(\"+%%d, -%%d, %%d\n\", plus, minus, plus - minus)}"

echo.
:: showing result until input enter key
set /P STR="If you input enter key, this bat will close."