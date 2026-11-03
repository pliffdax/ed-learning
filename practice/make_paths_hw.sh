#!/usr/bin/env bash
# Створює папку домашнього завдання ASG.SH.COMP.02 «Карта шляхів».
# Запуск: bash make_paths_hw.sh            - основний варіант (папка paths-hw)
#         bash make_paths_hw.sh --variant-b - еквівалентний варіант B (папка journal-hw)
set -e
if [ "${1:-}" = "--variant-b" ]; then
  N=journal-hw
  [ -e "$N" ] && { echo "Папка «$N» вже існує - скрипт нічого не змінив."; exit 1; }
  mkdir -p "$N/notes/2026" "$N/web/media" "$N/backup"
  echo "Жовтень: завершено SH.START." > "$N/notes/2026/october.md"
  echo "Ідеї: щоденник читання." > "$N/notes/ideas.md"
  echo "Старі нотатки." > "$N/backup/notes-old.md"
  echo "editor=code" > "$N/.journalrc"
  echo '<svg xmlns="http://www.w3.org/2000/svg" width="80" height="40"><circle cx="20" cy="20" r="15" fill="#888"/><text x="40" y="26" font-size="14">cat</text></svg>' > "$N/web/media/cat.svg"
  cat > "$N/web/page.html" <<'HTML'
<!doctype html>
<html lang="uk"><head><meta charset="utf-8"><title>Щоденник</title></head>
<body><h1>Щоденник</h1>
<img src="pictures/cat.svg" alt="Кіт (навчальне зображення)">
</body></html>
HTML
else
  N=paths-hw
  [ -e "$N" ] && { echo "Папка «$N» вже існує - скрипт нічого не змінив."; exit 1; }
  mkdir -p "$N/docs/archive" "$N/site/img" "$N/data"
  echo "План на тиждень." > "$N/docs/plan.txt"
  echo "Старий план." > "$N/docs/archive/old-plan.txt"
  echo "Звіт: 3 уроки завершено." > "$N/data/report.txt"
  echo "theme=dark" > "$N/.settings"
  echo '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="40"><rect width="120" height="40" fill="#2a6"/><text x="10" y="26" fill="#fff" font-size="16">ED logo</text></svg>' > "$N/site/img/logo.svg"
  cat > "$N/site/index.html" <<'HTML'
<!doctype html>
<html lang="uk"><head><meta charset="utf-8"><title>Сторінка проєкту</title></head>
<body><h1>Сторінка проєкту</h1>
<img src="images/logo.svg" alt="Логотип ED (навчальний)">
</body></html>
HTML
fi
cp "$(dirname "$0")/answers_template.txt" "$N/answers.txt"
cp "$(dirname "$0")/check_paths.sh" "$N/check_paths.sh"
echo "Готово: створено папку «$N» з файлом answers.txt для відповідей."
