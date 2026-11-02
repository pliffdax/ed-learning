#!/usr/bin/env bash
# Самоперевірка домашнього завдання ASG.SH.GIT.03. Нічого не змінює в репозиторії.
# Запуск: bash check_history.sh [--easy] [ПАПКА_РЕПОЗИТОРІЮ]   (типово - поточна папка)
#   --easy - спрощений варіант: перевіряються лише кроки 1-2 умови.
# Код виходу 0 - усі перевірки PASS; 1 - є FAIL.
set -u   # без pipefail: «... | grep -q» інакше може хибно провалитися через SIGPIPE
easy=0
if [ "${1:-}" = "--easy" ]; then easy=1; shift; fi
dir="${1:-.}"
cd "$dir" || { echo "FAIL: папку '$dir' не знайдено"; exit 1; }
fails=0
pass() { echo "PASS: $*"; }
fail() { echo "FAIL: $*"; fails=$((fails+1)); }

if [ ! -d .git ]; then
  echo "FAIL: у папці немає репозиторію (.git). Підказка: git init -b main у цій самій папці."
  echo; echo "РЕЗУЛЬТАТ: FAIL (1)"; exit 1
fi
variant="$(cat .task-variant 2>/dev/null || echo main)"
if [ "$variant" = "b" ]; then
  start_date="20 квітня 2026"; date_line="Початок робіт: 21 квітня 2026 (вівторок)."
  extra_plan="Доставка плитки: 18 квітня о 09:00."; extra_budget="Доставка: 1200."; total="Разом: 7500."
else
  start_date="13 березня 2026"; date_line="Дата: 14 березня 2026 (субота)."
  extra_plan="Потяг: Київ - Львів, 14 березня о 07:10."; extra_budget="Квитки: 3 × 650 = 1950."; total="Разом: 7350."
fi

if ! git rev-parse --verify -q HEAD >/dev/null; then
  echo "FAIL: у репозиторії ще немає жодного коміту. Підказка: git add plan.md budget.md, потім git commit -m \"...\""
  echo; echo "РЕЗУЛЬТАТ: FAIL (1)"; exit 1
fi

branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
if [ "$branch" = "main" ]; then pass "поточна гілка main"
else fail "поточна гілка '$branch', очікувалась main. Підказка: git init -b main (або перейменувати: git branch -m main)"; fi

name="$(git log -1 --format=%an)"; email="$(git log -1 --format=%ae)"
if [ -n "$name" ] && [ "$name" != "Your Name" ] && [ -n "$email" ] && [ "$email" != "you@example.com" ]; then
  pass "автор комітів налаштований ($name)"
else
  fail "ім'я або email автора не налаштовані. Підказка: git config --global user.name / user.email"
fi

root="$(git rev-list --max-parents=0 HEAD | tail -1)"
root_files="$(git show --format= --name-only "$root" | sort | tr '\n' ' ')"
if [ "$root_files" = "budget.md plan.md " ]; then pass "перший коміт містить рівно plan.md і budget.md"
else fail "перший коміт містить: ${root_files:-нічого}; очікувались лише budget.md і plan.md. Підказка: git add з іменами файлів, а не git add ."; fi
if git show "$root:plan.md" 2>/dev/null | grep -qF "$start_date"; then
  pass "перший коміт зберігає початковий (ще не виправлений) план"
else
  fail "у першому коміті план уже змінений. Умова: спершу закомітити початковий вигляд, виправлення - окремим комітом"
fi

if git log --all --format= --name-only | grep -qx "scratch.txt"; then
  fail "scratch.txt є в історії комітів. Підказка: не використовуйте git add . ; на цьому рівні найпростіше створити репозиторій заново (видаліть лише папку .git)"
else
  pass "scratch.txt не потрапив у жоден коміт"
fi

# Коміт виправлення дати: вносить рядок дати і змінює лише plan.md.
fix=""
for c in $(git rev-list --reverse HEAD); do
  [ "$c" = "$root" ] && continue
  if git show --format= "$c" -- plan.md | grep -qF "+$date_line"; then fix="$c"; break; fi
done
if [ -z "$fix" ]; then
  fail "не знайдено коміту, що вносить рядок «$date_line». Підказка: перевірте текст рядка (крапка в кінці) і git log -p plan.md"
else
  files="$(git show --format= --name-only "$fix" | tr '\n' ' ')"
  if [ "$files" = "plan.md " ]; then pass "виправлення дати - окремий коміт лише з plan.md"
  else fail "коміт виправлення дати змінює також інші файли: $files. Умова: виправлення дати - окремий коміт"; fi
fi

msgs="$(git log --format=%s)"
bad=0
while IFS= read -r m; do
  low="$(printf '%s' "$m" | tr '[:upper:]' '[:lower:]')"
  if [ "${#m}" -lt 10 ]; then bad=1; echo "  закоротке повідомлення: «$m»"; fi
  case "$low" in
    update|fix|changes|commit|wip|asdf|test|зміни|правки|оновлення|виправлення|коміт) bad=1; echo "  неінформативне повідомлення: «$m»";;
  esac
done <<< "$msgs"
dups="$(printf '%s\n' "$msgs" | sort | uniq -d)"
if [ -n "$dups" ]; then bad=1; echo "  однакові повідомлення: $dups"; fi
if [ "$bad" = 0 ]; then pass "повідомлення комітів осмислені й різні"
else fail "повідомлення комітів не пояснюють зміну (див. вище). Підказка: що змінено і навіщо, від 10 символів"; fi

if [ "$easy" = 0 ]; then
  n="$(git rev-list --count HEAD)"
  if [ "$n" -ge 4 ]; then pass "кількість комітів в історії: $n (потрібно щонайменше 4)"
  else fail "кількість комітів в історії: $n, потрібно щонайменше 4 (початковий, дата, нова інформація, звіт)"; fi
  if git show HEAD:plan.md 2>/dev/null | grep -qF "$date_line" && git show HEAD:plan.md | grep -qF "$extra_plan" \
     && git show HEAD:budget.md 2>/dev/null | grep -qF "$extra_budget" && git show HEAD:budget.md | grep -qF "$total"; then
    pass "останній коміт містить усі вимагані рядки плану й бюджету"
  else
    fail "в останньому коміті бракує рядків з умови (дата, нова інформація, підсумок). Підказка: git show HEAD:plan.md і git show HEAD:budget.md"
  fi
  if git cat-file -e HEAD:report.md 2>/dev/null && [ "$(git show HEAD:report.md | grep -c '[^[:space:]]')" -ge 3 ]; then
    pass "report.md закомічений і містить щонайменше 3 непорожні рядки"
  else
    fail "немає закоміченого report.md з 3-5 реченнями"
  fi
fi

dirty="$(git status --porcelain --untracked-files=all | grep -v -e '^?? scratch.txt$' -e '^?? task.txt$' -e '^?? .task-variant$')"
if [ -z "$dirty" ]; then pass "робоча папка чиста (крім scratch.txt, task.txt, .task-variant)"
else fail "є незакомічені зміни: $(echo "$dirty" | tr '\n' ';'). Підказка: git status"; fi

echo
if [ "$fails" = 0 ]; then echo "РЕЗУЛЬТАТ: PASS"; exit 0; else echo "РЕЗУЛЬТАТ: FAIL ($fails)"; exit 1; fi
