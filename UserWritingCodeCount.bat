REM This bat need awk command
REM If you using Windows OS, You install gawk
git log --numstat --pretty="%%H" | awk "NF==3 {plus+=$1; minus+=$2} END {printf(\"+%%d, -%%d, %%d\n\", plus, minus, plus - minus)}"
:: If we specify one user
:: git log --numstat --pretty="%%H" --author="yumechi-525" | awk "NF==3 {plus+=$1; minus+=$2} END {printf(\"+%%d, -%%d, %%d\n\", plus, minus, plus - minus)}"

:: show 10 seconds
timeout 10