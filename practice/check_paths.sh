#!/usr/bin/env bash
# Самоперевірка ASG.SH.COMP.02. Запуск із папки завдання (paths-hw або journal-hw):
#   bash check_paths.sh             - основний варіант
#   bash check_paths.sh --variant-b - варіант B
# Скрипт лише читає answers.txt і сторінку HTML; нічого не змінює.
VB=0; [ "${1:-}" = "--variant-b" ] && VB=1
F=answers.txt
[ -f "$F" ] || { echo "Немає answers.txt у поточній папці. Перейдіть у папку завдання (cd paths-hw) і запустіть знову."; exit 2; }
FAILS=0
get() { grep -E "^$1=" "$F" | head -n 1 | cut -d= -f2- | tr -d '\r' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }
ok() { echo "PASS $1"; }
no() { echo "FAIL $1: $2"; FAILS=$((FAILS + 1)); }
if [ $VB = 0 ]; then
  WIN='c:\users\anna\paths-hw\docs\archive\old-plan.txt'; LIN=/home/anna/paths-hw/docs/archive/old-plan.txt
  R3=../docs/plan.txt; R4=../../site/img/logo.svg; HID=.settings; Q8OK="docs site data"; HTML=site/index.html; GOOD=img/logo.svg
else
  WIN='c:\users\oleh\journal-hw\notes\2026\october.md'; LIN=/home/oleh/journal-hw/notes/2026/october.md
  R3=../notes/ideas.md; R4=../../web/media/cat.svg; HID=.journalrc; Q8OK="notes web backup"; HTML=web/page.html; GOOD=media/cat.svg
fi
A1="$(get Q1 | tr '/' '\\' | tr '[:upper:]' '[:lower:]')"
[ "$A1" = "$WIN" ] && ok "Q1 (абсолютний шлях Windows)" || no Q1 "абсолютний шлях Windows має починатися з літери диска і містити всі папки до файла. Регістр і вид скісної риски (\ чи /) неважливі."
[ "$(get Q2)" = "$LIN" ] && ok "Q2 (абсолютний шлях Linux)" || no Q2 "на Linux шлях починається з / і без літери диска; регістр важливий."
A3="$(get Q3)"; [ "$A3" = "$R3" ] || [ "$A3" = "./$R3" ] && ok "Q3 (відносний шлях на один рівень)" || no Q3 "з робочої папки треба спершу піднятися до батьківської (..), потім спуститися."
A4="$(get Q4)"; [ "$A4" = "$R4" ] || [ "$A4" = "./$R4" ] && ok "Q4 (відносний шлях на два рівні)" || no Q4 "порахуйте, скільки разів треба піднятися (..), щоб дійти до спільної папки."
[ "$(get Q5)" = "$HID" ] && ok "Q5 (прихований файл)" || no Q5 "використайте ls -a у кореневій папці завдання."
[ "$(get Q6)" = "2" ] && ok "Q6 (регістр у Linux)" || no Q6 "у Linux назви, що відрізняються регістром, - різні файли."
[ "$(get Q7)" = "1" ] && ok "Q7 (регістр у Windows)" || no Q7 "у Windows (типово) назви, що відрізняються лише регістром, - той самий файл."
A8="$(get Q8 | sed 's#/$##')"; case " $Q8OK " in *" $A8 "*) [ -n "$A8" ] && ok "Q8 (робоча папка для відносного шляху)" || no Q8 "вкажіть назву папки";; *) no Q8 "шлях ../... працює з будь-якої папки першого рівня всередині папки завдання - назвіть одну з них";; esac
if [ -f "$HTML" ] && grep -Eq "src=\"(\./)?$GOOD\"" "$HTML" && ! grep -q 'src="images/\|src="pictures/' "$HTML"; then ok "HTML (зображення за правильним відносним шляхом)"; else no HTML "у $HTML атрибут src має вести до наявного файла відносно папки сторінки; відкрийте сторінку в браузері - зображення має з'явитися."; fi
[ $FAILS = 0 ] && { echo "Результат: PASS"; exit 0; } || { echo "Результат: FAIL ($FAILS)"; exit 1; }
