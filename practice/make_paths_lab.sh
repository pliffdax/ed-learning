#!/usr/bin/env bash
# Створює навчальну папку для уроку SH.COMP.L01 «Файли, папки й шляхи».
# Запуск у Git Bash / Terminal із папки, де ви хочете її створити:  bash make_paths_lab.sh [назва-папки]
# Типова назва - paths-lab. Наявну папку скрипт не перезаписує.
set -e
NAME="${1:-paths-lab}"
if [ -e "$NAME" ]; then
  echo "Папка «$NAME» вже існує - скрипт нічого не змінив. Вкажіть іншу назву: bash make_paths_lab.sh інша-назва"
  exit 1
fi
mkdir -p "$NAME/docs/archive" "$NAME/site/img" "$NAME/data"
printf '%s\n' "Навчальна папка уроку SH.COMP.L01." "Не зберігайте тут нічого цінного." > "$NAME/README.txt"
printf '%s\n' "План на тиждень: уроки SH.COMP.L01-L02." > "$NAME/docs/plan.txt"
printf '%s\n' "Старий план: SH.START." > "$NAME/docs/archive/old-plan.txt"
printf '%s\n' "Звіт: 3 уроки завершено." > "$NAME/data/report.txt"
printf '%s\n' "theme=dark" > "$NAME/.settings"
printf '%s\n' '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="40"><rect width="120" height="40" fill="#2a6"/><text x="10" y="26" fill="#fff" font-size="16">ED logo</text></svg>' > "$NAME/site/img/logo.svg"
cat > "$NAME/site/index.html" <<'HTML'
<!doctype html>
<html lang="uk"><head><meta charset="utf-8"><title>Сторінка з відносними шляхами</title></head>
<body>
<h1>Відносні шляхи</h1>
<p>Логотип нижче завантажується за відносним шляхом <code>img/logo.svg</code> - відносно папки, де лежить ця сторінка.</p>
<img src="img/logo.svg" alt="Логотип ED (навчальний)">
<p><a href="../docs/plan.txt">План (відносне посилання ../docs/plan.txt)</a></p>
</body></html>
HTML
echo "Готово: створено папку «$NAME»."
