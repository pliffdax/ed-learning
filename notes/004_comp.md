# SH.COMP.L01

## Покрокова демонстрація

\> pwd  
/Users/pliffdax/Projects/university/ED-Mentorship/Work/Backend/Java/ed-learning/practice/paths-lab

**Перетворений шлях у форматі Windows:** C:\Users\pliffdax\Projects\university\ED-Mentorship\Work\Backend\Java\ed-learning\practice\paths-lab

\> ls  
data
docs
README.txt
site

\> ls -a  
.
..
.settings
data
docs
README.txt
site

\> cat docs/plan.txt  
План на тиждень: уроки SH.COMP.L01-L02.

\> cd site

\> cat docs/plan.txt  
cat: docs/plan.txt: No such file or directory

\> cat ../docs/plan.txt  
План на тиждень: уроки SH.COMP.L01-L02.

\> ls ../docs/archive  
old-plan.txt

\> cd ..

\> cp data/report.txt data/report.pdf

\> file data/report.txt data/report.pdf  
data/report.txt: Unicode text, UTF-8 text
data/report.pdf: Unicode text, UTF-8 text

\> cd data

\> echo "перший" > Notes.txt

\> echo "другий" > notes.txt

\> ls
Notes.txt
report.pdf
report.txt

\> cat Notes.txt
другий

## Керована практика

\> cd ../docs/archive

\> cat paths-lab/README.txt  
cat: paths-lab/README.txt: No such file or directory

\> cat ../../README.txt  
Навчальна папка уроку SH.COMP.L01.
Не зберігайте тут нічого цінного.

\> cd ../../site

\> ls ../data  
Notes.txt
report.pdf
report.txt

**Термінал:** /Users/pliffdax/Projects/university/ED-Mentorship/Work/Backend/Java/ed-learning/practice/paths-lab/site/img/logo.svg  
**Провідник:** ~/Projects/university/ED-Mentorship/Work/Backend/Java/ed-learning/practice/paths-lab/site/img/logo.svg

\> cd ../../README.txt - спрацює, якщо виклик буде або в `paths-lab/docs/archive` або в `paths-lab/site/img`.

## Самостійна практика

**Дерево своєї робочої папки на два рівні вглиб:**

```text
paths-lab
├── data
│   ├── Notes.txt
│   ├── report.pdf
│   └── report.txt
├── docs
│   ├── archive
│   │   └── old-plan.txt
│   └── plan.txt
├── README.txt
└── site
    ├── img
    │   └── logo.svg
    └── index.html
```

**Абсолютний шлях:** /Users/pliffdax/Projects/university/ED-Mentorship/Work/Backend/Java/ed-learning/notes/plan.md
**Відносний шлях від ed-learning/practice:** ../../../notes/plan.md
**Відносний шлях від ed-learning/practice/paths-lab/site:** ../../../notes/plan.md

\> cat ../notes/plan.md  
Вивід перевірено успішно, файл вивело

\> cat ../../../notes/plan.md  
Вивід перевірено успішно, файл вивело

**Відповідь на питання:** Лямда `~` повертає на верхній рівень, в моєму випадку автоматично підставляє `/Users/pliffdax/`. Якщо написати без неї, воно буде шукати `ed-learning` безпосередньо в practice, а не на верхньому рівні.

## Домашнє завдання

Q1=C:\Users\pliffdax\Projects\university\ED-Mentorship\Work\Backend\Java\ed-learning\practice\paths-hw\docs\archive\old-plan.txt
Q2=/Users/pliffdax/Projects/university/ED-Mentorship/Work/Backend/Java/ed-learning/practice/paths-hw/docs/archive/old-plan.txt
Q3=../docs/txt
Q4=../../site/img/logo.svg
Q5=.settings
Q6=2
Q7=1
Q8=site

PASS Q1 (абсолютний шлях Windows)
PASS Q2 (абсолютний шлях Linux)
PASS Q3 (відносний шлях на один рівень)
PASS Q4 (відносний шлях на два рівні)
PASS Q5 (прихований файл)
PASS Q6 (регістр у Linux)
PASS Q7 (регістр у Windows)
PASS Q8 (робоча папка для відносного шляху)
PASS HTML (зображення за правильним відносним шляхом)
Результат: PASS
