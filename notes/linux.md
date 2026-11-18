# Linux Notes

Built from *The Linux Command Line* by William Shotts (TLCL, 25.12 edition, [linuxcommand.org](https://linuxcommand.org/tlcl.php)). Everything here also works in **Git Bash** on Windows unless it says otherwise.

**How to read these notes:**
- ⭐ **Focus:** the commands used every day, learn these first.
- **Gotcha:** behaviour that is easy to get wrong (or that deletes things).
- **Tip:** shortcuts and habits that save time.
- **Note:** extra info, good to know but not urgent.

## Index

### Contents

- ⭐ [Survival kit](#survival-kit) · [pipeline kit](#pipeline-kit) · [permissions and processes kit](#permissions-and-processes-kit)
- [The shell](#the-shell) · [command anatomy](#anatomy-of-a-command) · [getting help](#getting-help)
- [Navigation](#navigation) · [paths](#absolute-vs-relative-paths) · [the file system](#the-file-system-tree)
- [Looking at files](#looking-at-files) · [ls](#ls) · [less](#less) · [file](#file)
- [Manipulating files](#manipulating-files-and-directories) · [wildcards](#wildcards-globbing) · [cp / mv / rm](#cp-mv-rm) · [links](#links)
- [Redirection](#redirection) · [pipes](#pipes) · [filters](#filters-in-a-pipeline)
- [Expansion and quoting](#expansion-and-quoting)
- [Keyboard tricks and history](#keyboard-tricks-and-history)
- [Permissions](#permissions) · [chmod](#chmod) · [sudo](#sudo-and-su)
- [Processes](#processes) · [jobs](#jobs-background-and-foreground) · [kill](#kill-and-signals)
- [The environment](#the-environment) · [PATH](#path) · [startup files](#startup-files-and-bashrc) · [aliases](#aliases)
- [vi / vim survival](#vi--vim-survival)
- [Packages](#package-management) · [Storage](#storage-and-disk-space) · [Networking](#networking)
- [Searching for files](#searching-for-files) · [find](#find) · [locate](#locate)
- [Archiving](#archiving-and-compression) · [tar](#tar) · [rsync](#rsync)
- [Regular expressions](#regular-expressions) · [grep](#grep)
- [Text processing](#text-processing) · [sort / uniq](#sort-and-uniq) · [cut / paste / join](#cut-paste-join) · [tr](#tr) · [sed](#sed) · [awk](#awk-just-enough) · [diff](#diff)
- [Shell scripting](#shell-scripting) · [variables](#variables) · [if](#if-and-test) · [loops](#loops) · [functions](#functions) · [read](#reading-input) · [debugging](#debugging-scripts)
- [Gotchas](#gotchas)
- [Linux ↔ SQL ↔ Excel](#linux--sql--excel)
- [Practice: OverTheWire Bandit](#practice-overthewire-bandit)

### Quick lookup

| I want to… | Go to |
|---|---|
| know where I am / move around | [pwd, cd](#navigation) |
| see what's in a folder (incl. hidden files) | [ls](#ls) |
| read a big file without opening an editor | [less](#less), [head / tail](#filters-in-a-pipeline) |
| copy / move / rename / delete | [cp / mv / rm](#cp-mv-rm) |
| act on many files at once | [wildcards](#wildcards-globbing) |
| save a command's output to a file | [Redirection](#redirection) |
| hide error messages | [`2> /dev/null`](#redirection) |
| chain commands together | [pipes](#pipes) |
| count lines / rows in a CSV | [`wc -l`](#filters-in-a-pipeline) |
| search inside files | [grep](#grep) |
| find a file by name / size / date | [find](#find) |
| pull out one column of a CSV | [cut](#cut-paste-join), [awk](#awk-just-enough) |
| sort, dedupe, count occurrences | [sort / uniq](#sort-and-uniq) |
| find and replace in a file | [sed](#sed) |
| compare 2 files | [diff](#diff) |
| make a script executable / fix "Permission denied" | [chmod](#chmod) |
| stop a stuck program | [Ctrl+C, kill](#kill-and-signals) |
| run a command in the background | [jobs](#jobs-background-and-foreground) |
| make a shortcut for a long command | [aliases](#aliases) |
| exit vim | [vi / vim survival](#vi--vim-survival) |
| zip up / back up a folder | [tar](#tar), [rsync](#rsync) |
| automate a sequence of commands | [Shell scripting](#shell-scripting) |

## Survival kit

⭐ The commands needed every day, on one screen. Details are in the sections linked above.

```
pwd                       where am I?
ls / ls -la               list files (-la: hidden ones too, with details)
cd PATH / cd ~ / cd -     go to PATH / home / back to the previous folder
mkdir -p a/b              make folders (-p: make missing parents too)
cp SRC DEST               copy (. = here)
mv OLD NEW                move or rename
rm FILE                   delete (no Recycle Bin!)
find WHERE -name "*.csv"  search by name, in WHERE and everything below
```

- Paths with spaces need "quotes": `cd "/d/VS Codes"`.
- CAPITALS in docs = placeholders: swap `PATH`, `SRC`, `FILE` for real names.

### Pipeline kit

⭐ Counting and summarising a file (e.g. a CSV) from the terminal. Details in [pipes](#pipes), [sort / uniq](#sort-and-uniq), [cut](#cut-paste-join), [grep](#grep).

```
wc -l FILE                  count lines
tail -n +2 FILE             print from line 2 (skip the header)
head -n 5 FILE              first 5 lines
cut -d, -f2                 split on commas, keep field 2
sort | uniq -c | sort -rn   count each value, biggest first (= GROUP BY + COUNT + ORDER BY DESC)
grep -c WORD FILE           count lines containing WORD
CMD > FILE                  save output to a file (overwrites)   >> appends
A | B                       pipe: A's output becomes B's input
```

- Put together: `tail -n +2 data/raw.csv | cut -d, -f2 | sort | uniq -c | sort -rn` = transactions per category, most first.

### Permissions and processes kit

⭐ Running files, background jobs and environment variables. Details in [Permissions](#permissions), [chmod](#chmod), [jobs](#jobs-background-and-foreground), [kill](#kill-and-signals), [The environment](#the-environment).

```
ls -l               long listing; first 10 chars = type + permissions
-rwxr-xr-x          [type][you rwx][group r-x][others r-x]   r=read w=write x=run
chmod +x FILE       make it runnable        ./FILE  run a file in this folder
CMD &               run in the background → prints [job] PID
ps                  list my running processes        kill PID / kill %JOB  stop one
export NAME=value   set an environment variable       echo $NAME  read it
```

## The shell

The **shell** is a program that takes the commands we type and gives them to the operating system to run. On most Linux systems (and Git Bash) the shell is **bash** ("Bourne Again SHell").

- a **terminal** (terminal emulator) is just the window; the shell is the program running inside it.
- the **prompt** `user@host:~$` means "ready for a command". `$` = normal user, `#` = root (superuser, be careful).

```bash
date            # current date and time
cal             # calendar for this month
df -h           # free disk space
free -h         # free memory (not in Git Bash)
exit            # close the shell
```

### Anatomy of a command

```
command  -options  arguments
ls       -lh       /etc
```

- **short options** are 1 dash + 1 letter and can be stacked: `ls -l -a -h` = `ls -lah`
- **long options** are 2 dashes + a word: `ls --all`
- **arguments** are what the command acts on (files, folders, text)

There are 4 kinds of command. `type` tells you which one a name is:

| Kind | Example | What it is |
|---|---|---|
| executable program | `/usr/bin/ls` | a file on disk |
| shell builtin | `cd`, `echo` | built into bash itself |
| shell function | (your own) | mini script loaded into the environment |
| alias | `ll` | a nickname for another command |

```bash
type cd          # cd is a shell builtin
type ls          # ls is aliased to `ls --color=auto`
which python     # full path of the program that runs (programs only, not builtins)
```

### Getting help

| Command | Use it for |
|---|---|
| `cmd --help` | quick usage summary (most programs) |
| `help cd` | help for **builtins** (`cd`, `for`, `if`, …) |
| `man ls` | the full manual page (`q` to quit, `/word` to search) |
| `man -k keyword` / `apropos keyword` | "which command does X?" |
| `whatis ls` | one-line description |
| `info coreutils` | GNU info pages (longer than man) |

- ⭐ **Focus:** `--help` first, `man` when you need the detail.
- **Tip:** man pages have a SYNOPSIS: `[ ]` = optional, `...` = can repeat, `|` = pick one.
- **Tip:** words in CAPITALS (or `<angle brackets>`) in docs and `--help` are placeholders: `cp SRC DEST` means type your own file names there.
- **Note:** Git Bash has no `man`. Use `--help` or search "man ls" online.

## Navigation

```bash
pwd             # print working directory: where am I?
ls              # list what's here
cd /usr/bin     # go to an absolute path
cd ..           # up one level (parent)
cd              # go home (~)
cd ~            # same
cd -            # go back to the previous directory (toggle)
cd ~/projects   # ~ = home, so /home/arsh/projects
```

### Absolute vs relative paths

- **absolute** starts with `/` (from the root): `/home/arsh/notes/linux.md`
- **relative** starts from where you are: `notes/linux.md`, `../sql`
- `.` = this directory, `..` = parent directory
- `/` = root of the whole system, `~` = my home

**Tip:** lost? `pwd` prints the full path, and an absolute path works from anywhere.

**Gotcha:** a lone `-` means **stdin** to most commands, so `cat -` waits for keyboard input instead of opening a file named `-`. Give it a path so it's no longer "alone": `cat ./-` or `cat /home/bandit1/-`.

**Gotcha:** a name with **spaces** splits into separate arguments. Quote it (`cat "spaces in this name"`) or escape each space (`cat spaces\ in\ this\ name`). A full path alone doesn't fix this; the path needs quotes too. `Tab` completion adds the escapes for you.

**Tip:** `--` means "end of options": everything after it is treated as a name, even if it starts with `-`. `cat -- --weird-name--`. (`cat ./--weird-name--` also works.)

**Tip:** `./` is usually optional (`ls ./notes` = `ls notes`), except when running a script in the current folder: `./script.sh`. Bash doesn't look in `.` for programs, for security.

**Gotcha:** file names are **case sensitive**: `File.txt` and `file.txt` are 2 different files. Avoid spaces in names (use `_` or `-`); if you must, quote them: `cd "My Folder"`.

**Note:** files starting with `.` are **hidden** (`.bashrc`, `.gitignore`). `ls -a` shows them.

### The file system tree

Linux has **one tree** starting at `/` (no `C:\` / `D:\` drive letters). Drives get "mounted" somewhere inside it.

| Directory | What's there |
|---|---|
| `/` | root of everything |
| `/bin`, `/usr/bin` | programs (`ls`, `cp`, `python3`) |
| `/sbin`, `/usr/sbin` | system admin programs |
| `/etc` | system-wide config files (plain text) |
| `/home/user` (`~`) | your files, the only place you can write by default |
| `/root` | root user's home |
| `/tmp` | temporary files, often wiped on reboot |
| `/var` | files that change: `/var/log` for logs |
| `/dev` | devices as files (`/dev/null`, `/dev/sda`) |
| `/proc` | live info about the kernel and processes (not real files) |
| `/mnt`, `/media` | where USB drives / other disks get mounted |
| `/opt` | optional / third-party software |

**Note:** in Git Bash your Windows drives are at `/c/`, `/d/` e.g. `cd "/d/VS Codes/Personal-Finance"`. In WSL they're at `/mnt/c/`, `/mnt/d/`.

## Looking at files

### ls

| Command | Shows |
|---|---|
| `ls -l` | long format: permissions, owner, size, date |
| `ls -a` | include hidden (`.`) files |
| `ls -h` | human sizes (`4.2K`, `1.1M`), use with `-l` |
| `ls -t` | sort by modified time, newest first |
| `ls -S` | sort by size, biggest first |
| `ls -r` | reverse the sort |
| `ls -d dir` | the folder itself, not its contents |
| `ls -R` | recursive (every subfolder) |

⭐ `ls -lah` is the one to remember. `ls -ltr` = newest file at the bottom (handy for logs).

Reading `ls -l`:
```
-rw-r--r-- 1 arsh arsh 1234 Nov 16 09:58 linux.md
│└──┬────┘   │    │    │    │            └ name
│   │        │    │    │    └ last modified
│   │        │    │    └ size in bytes
│   │        │    └ group
│   │        └ owner
│   └ permissions (owner, group, others), see Permissions
└ type: - file, d directory, l symlink
```

### less

`less file` opens a file page by page without loading it all (fine for huge CSVs and logs).

| Key | Does |
|---|---|
| `Space` / `b` | page down / page up |
| `g` / `G` | top / bottom of file |
| `/word` | search forward; `n` = next match, `N` = previous |
| `q` | quit |

**Tip:** "less is more": it replaced the older `more` and can scroll backwards. `less -S` stops long lines wrapping (great for wide CSVs).

### file

`file name` says what a file *actually* is, regardless of extension: `file data/raw.csv` → `CSV text`. Linux doesn't care about extensions; `file` looks at the contents.

```bash
file NAME        # directory, ASCII text, data, …
file ./*         # check every file here at once
```

- **Tip:** `file ./*` is the quick way to find the one human-readable file (`ASCII text`) among many binary ones (`data`).
- **Gotcha:** use `./*`, not plain `*`. If a name starts with `-`, plain `*` expands to something like `-file00` and `file` reads it as an option. `./` makes every name a path.
- **Note:** `*` skips hidden (`.`) files; `ls -a` / `ls -la` to see them.

## Manipulating files and directories

```bash
mkdir notes                 # make a directory
mkdir -p a/b/c              # make the whole path, no error if it exists
touch empty.txt             # create an empty file (or update its timestamp)
cp src dest                 # copy
mv src dest                 # move OR rename
rm file                     # delete (no recycle bin!)
rmdir dir                   # delete an EMPTY directory
rm -r dir                   # delete a directory and everything in it
```

### Wildcards (globbing)

The **shell** expands these into matching file names *before* the command runs.

| Pattern | Matches |
|---|---|
| `*` | any characters (including none) |
| `?` | exactly one character |
| `[abc]` | one of a, b, c |
| `[!abc]` | any one character that is NOT a, b, c |
| `[0-9]`, `[[:digit:]]` | one digit |
| `[[:upper:]]`, `[[:lower:]]`, `[[:alpha:]]`, `[[:alnum:]]` | upper / lower / letter / letter or digit |

```bash
ls *.sql                 # every .sql file
ls data/*.csv            # every CSV in data/
ls w?d?.md               # w1d1.md, w6d2.md …
ls [A-Z]*                # names starting with a capital (see Gotcha)
rm backup_2025*          # careful: check with ls first
```

- ⭐ **Focus:** before running `rm` or `mv` with a wildcard, run `ls` with the same pattern to see exactly what will be hit.
- **Gotcha:** `[A-Z]` can match lowercase too depending on the locale. Use `[[:upper:]]` to be safe.
- **Note:** `*` doesn't match hidden files (starting with `.`).

### cp, mv, rm

| Option | Meaning |
|---|---|
| `-r` | recursive: needed to copy / delete a directory |
| `-i` | interactive: ask before overwriting / deleting |
| `-v` | verbose: print what it did |
| `-u` | (cp/mv) only if the source is newer than the dest |
| `-n` | (cp/mv) never overwrite |
| `-a` | (cp) archive: copy everything keeping permissions and dates |

```bash
cp file1 file2              # file1 → file2 (overwrites file2 silently!)
cp file1 file2 dir/         # several files into a directory
cp -r project project_bak   # copy a whole folder
cp ../sql/q1.sql .          # copy into the current folder (. = here)
mv old.md new.md            # rename
mv *.csv data/              # move all CSVs into data/
rm -i *.tmp                 # ask for each one
```

**Gotcha:** `rm` is permanent, there is no undo and no recycle bin. `cp` and `mv` overwrite existing files without asking. Use `-i` when unsure.

**Gotcha:** `rm -rf` = recursive + force (no questions). A stray space can be a disaster: `rm -rf * .tmp` (with a space) deletes **everything** in the folder, then looks for `.tmp`. Always `ls` the pattern first.

### Links

```bash
ln -s target linkname       # symbolic (soft) link: a shortcut
ln target linkname          # hard link
```

| | Symbolic link | Hard link |
|---|---|---|
| what it is | a pointer to a path (like a Windows shortcut) | a second name for the same data |
| works for directories | yes | no |
| across disks | yes | no |
| if target deleted | link breaks ("dangling") | data stays until every name is gone |

⭐ You'll almost always want `ln -s`. In `ls -l` it shows as `link -> target`.

## Redirection

Every command has 3 streams:

| Stream | Number | Default |
|---|---|---|
| standard input (stdin) | 0 | keyboard |
| standard output (stdout) | 1 | screen |
| standard error (stderr) | 2 | screen |

| Syntax | Does |
|---|---|
| `cmd > file` | stdout to file (**overwrites**) |
| `cmd >> file` | stdout to file (**appends**) |
| `cmd 2> file` | stderr to file |
| `cmd > file 2>&1` | both stdout and stderr to file |
| `cmd &> file` | same, bash shortcut |
| `cmd 2> /dev/null` | throw errors away |
| `cmd < file` | file as stdin |
| `> file` | empty a file (truncate) |

```bash
ls -l > files.txt                 # save the listing
echo "new line" >> log.txt        # add to the end
find / -name "*.conf" 2> /dev/null   # hide "Permission denied" spam
python generate_data.py > out.log 2>&1   # log everything a script prints
```

- **Gotcha:** `> file` overwrites without asking. A typo of `>` for `>>` wipes the file.
- **Gotcha:** order matters: `cmd > file 2>&1` ✅ (both go to file); `cmd 2>&1 > file` ❌ (errors still go to the screen).
- **Note:** `/dev/null` is the "bit bucket": anything written there disappears.
- **Tip:** `set -o noclobber` makes `>` refuse to overwrite existing files (`>|` forces it).

### Pipes

`cmd1 | cmd2` sends the **stdout** of cmd1 into the **stdin** of cmd2. This is the big idea of Linux: lots of small tools that each do one thing, chained together.

```bash
ls -l /usr/bin | less                  # page through a long listing
history | grep psql                    # find that psql command from yesterday
cat data/raw.csv | wc -l               # count lines (wc -l data/raw.csv also works)
cut -d, -f2 data/raw.csv | sort | uniq -c | sort -rn | head   # most common categories
```

**Gotcha:** `>` sends output to a **file**, `|` sends it to a **command**. `ls > less` creates a file called `less`.

**Tip:** `tee` lets you save AND keep piping: `ls | tee files.txt | wc -l`.

### Filters in a pipeline

| Command | Does |
|---|---|
| `cat f1 f2` | print / join files together |
| `head -n 5 file` | first 5 lines (default 10) |
| `tail -n 5 file` | last 5 lines |
| `tail -f log` | follow: keep printing new lines as they're added (Ctrl+C to stop) |
| `wc file` | lines, words, bytes; `wc -l` = lines only |
| `sort` | sort lines |
| `uniq` | remove *adjacent* duplicate lines |
| `grep pattern` | keep only lines matching |
| `tee file` | write to file and pass through |

⭐ `head -n 5 data/raw.csv` is the quickest look at a CSV's header and first rows. `wc -l` gives rows + 1 (the header).

## Expansion and quoting

Before a command runs, the shell **expands** some characters. `echo` is the easiest way to see what the shell will actually pass on.

| Type | Example | Becomes |
|---|---|---|
| pathname (wildcards) | `echo *.md` | `big-o.md excel.md linux.md …` |
| tilde | `echo ~` | `/home/arsh` |
| arithmetic | `echo $((5 * 12))` | `60` |
| brace | `echo w{1..3}d{1,2}` | `w1d1 w1d2 w2d1 w2d2 w3d1 w3d2` |
| parameter (variable) | `echo $HOME` | `/home/arsh` |
| command substitution | `echo "Today is $(date +%F)"` | `Today is 2026-11-16` |

```bash
mkdir -p 2026-{01..12}          # 12 month folders in one go
cp file.txt{,.bak}              # = cp file.txt file.txt.bak
```

### Quoting

| Quote | Effect | Example |
|---|---|---|
| none | everything expands, spaces split words | `echo $HOME *` |
| `"double"` | `$var`, `$(cmd)`, `$((maths))` still work; wildcards, `~`, braces and word splitting don't | `echo "Total: $TOTAL"` |
| `'single'` | nothing expands, 100% literal | `echo '$HOME is literal'` |
| `\` | escape one character | `echo \$5.00` |

- ⭐ **Focus:** wrap variables in double quotes: `"$file"`. Without them a file name with a space becomes 2 arguments.
- **Tip:** use single quotes around `grep`, `sed` and `awk` patterns so the shell doesn't touch them.

## Keyboard tricks and history

| Keys | Does |
|---|---|
| `Tab` | autocomplete command / file name (press twice to see options) |
| `↑` / `↓` | previous / next command |
| `Ctrl+R` | reverse search history (type part of a command, Ctrl+R again for older) |
| `Ctrl+A` / `Ctrl+E` | jump to start / end of line |
| `Alt+B` / `Alt+F` | back / forward one word |
| `Ctrl+U` / `Ctrl+K` | delete to start / end of line |
| `Ctrl+W` | delete the word before the cursor |
| `Ctrl+L` | clear screen (same as `clear`) |
| `Ctrl+C` | cancel / kill the running command |
| `Ctrl+D` | end of input; on an empty line it exits the shell |

| History | Does |
|---|---|
| `history` | numbered list of past commands |
| `!!` | rerun the last command (`sudo !!` = last command as root) |
| `!42` | rerun command number 42 |
| `!psql` | rerun the last command starting with "psql" |
| `!$` | last argument of the previous command: `mkdir newdir && cd !$` |

- ⭐ **Focus:** `Tab` and `Ctrl+R` save more time than everything else here combined.
- **Gotcha:** `!` commands run straight away. `!psql:p` prints it without running, to check first.
- **Tip:** in terminals, copy/paste is `Ctrl+Shift+C` / `Ctrl+Shift+V` (`Ctrl+C` means "kill").

## Permissions

Linux is multi-user, so every file has an **owner**, a **group**, and permissions for 3 classes of user:

```
-rwxr-xr--
 └┬┘└┬┘└┬┘
  │  │  └ others (everyone else): r--  read only
  │  └ group: r-x  read + execute
  └ owner (u): rwx  read + write + execute
```

| Letter | On a file | On a directory |
|---|---|---|
| `r` | read the contents | list the files (`ls`) |
| `w` | change the contents | create / delete / rename files inside |
| `x` | run it as a program | enter it (`cd`) |

```bash
id              # who am I, which groups am I in
whoami          # just my user name
```

### chmod

Two ways to write it:

**Octal (numbers):** r = 4, w = 2, x = 1. Add them up per class.

| Number | Permissions | Typical use |
|---|---|---|
| `755` | `rwxr-xr-x` | scripts, programs, directories |
| `644` | `rw-r--r--` | normal files |
| `700` | `rwx------` | private directory |
| `600` | `rw-------` | private file: SSH keys, `.env` with API keys |

**Symbolic (letters):** who (`u` owner, `g` group, `o` others, `a` all) + `+`/`-`/`=` + what.

```bash
chmod +x script.sh        # make executable for everyone ⭐
chmod u+x script.sh       # only the owner
chmod go-w file           # remove write from group and others
chmod 600 .env            # only I can read/write my secrets
chmod -R 755 dir          # recursive
```

- ⭐ **Focus:** "Permission denied" when running `./script.sh` → `chmod +x script.sh`.
- **Note:** `umask` sets the default permissions for new files (usually `0022` → files 644, dirs 755).
- **Note:** `chown user:group file` changes the owner (needs sudo).

### sudo and su

- **root** is the superuser who can do anything, including breaking the system.
- `sudo cmd` runs one command as root (asks for *your* password). This is the normal way.
- `su -` starts a whole shell as root (asks for *root's* password). Avoid unless needed.

**Gotcha:** don't `sudo` things out of habit, especially `rm`, `pip install` or scripts you haven't read. If something needs root, ask why first.

## Processes

A **process** is a running program. Each has a **PID** (process ID).

| Command | Shows |
|---|---|
| `ps` | processes in this terminal |
| `ps aux` | every process on the system |
| `ps aux \| grep python` | find a specific one |
| `top` | live view sorted by CPU (`q` to quit); `htop` is the nicer version if installed |
| `pstree` | processes as a parent/child tree |

### Jobs: background and foreground

| Syntax | Does |
|---|---|
| `cmd &` | start in the background, get the prompt back |
| `Ctrl+Z` | pause (stop) the foreground program |
| `jobs` | list jobs in this shell |
| `bg %1` | resume job 1 in the background |
| `fg %1` | bring job 1 back to the foreground |

```bash
python long_script.py > out.log 2>&1 &    # run it, keep working
jobs                                        # [1]+ Running …
fg %1                                       # bring it back
```

**Tip:** `nohup cmd &` keeps it running after you close the terminal.

### kill and signals

`kill` sends a **signal** to a process. Despite the name it doesn't always kill.

| Signal | Number | Meaning |
|---|---|---|
| `SIGINT` | 2 | interrupt, what `Ctrl+C` sends |
| `SIGTERM` | 15 | "please stop" (the default for `kill`), program can clean up |
| `SIGKILL` | 9 | stop **now**, can't be ignored, no clean up |
| `SIGTSTP` | 20 | pause, what `Ctrl+Z` sends |
| `SIGHUP` | 1 | terminal closed / "reload your config" |

```bash
kill 1234            # polite stop (SIGTERM)
kill -9 1234         # force kill, last resort
killall python3      # by name instead of PID
```

**Gotcha:** try plain `kill` first. `kill -9` doesn't let the program save or close files, so it can leave half-written data behind.

## The environment

The shell keeps a set of **variables** that programs can read.

```bash
printenv            # all environment variables
printenv PATH       # one variable
echo $HOME $USER $SHELL $PWD
set | less          # shell AND environment variables, plus functions
```

| Variable | Holds |
|---|---|
| `HOME` | your home directory |
| `USER` | your user name |
| `PATH` | folders searched for programs (see below) |
| `PWD` / `OLDPWD` | current / previous directory |
| `SHELL` | your login shell |
| `EDITOR` | default text editor |
| `PS1` | what the prompt looks like |
| `LANG` | language and character set |

```bash
MY_VAR="hello"          # shell variable (this shell only), no spaces around =
export MY_VAR           # now child programs (python, psql) can see it too
export API_KEY="..."    # how API keys get into scripts without being in the code
```

### PATH

`PATH` is a `:`-separated list of folders. When you type `python`, bash checks each one in order and runs the first match.

```bash
echo $PATH
# /usr/local/bin:/usr/bin:/bin:/home/arsh/bin
export PATH="$HOME/bin:$PATH"      # add your own folder (to the front)
```

- **Gotcha:** "command not found" means it isn't installed **or** its folder isn't in `PATH`. `which cmd` / `type cmd` to check.
- **Gotcha:** `export PATH="$HOME/bin"` (without `:$PATH`) wipes PATH and almost nothing will work until you open a new terminal.

### Startup files and .bashrc

| File | Read when |
|---|---|
| `/etc/profile` | login shell, system-wide |
| `~/.bash_profile` (or `~/.profile`) | login shell, just you |
| `~/.bashrc` | every new interactive (non-login) shell, just you |

⭐ Put your own aliases, exports and PATH changes at the end of `~/.bashrc`. They only apply to **new** terminals, or run `source ~/.bashrc` to reload now.

**Tip:** back up first: `cp ~/.bashrc ~/.bashrc.bak`. A broken `.bashrc` breaks every new terminal.

### Aliases

```bash
alias ll='ls -lah'
alias gs='git status'
alias ..='cd ..'
alias rm='rm -i'           # safety net
alias                      # list all aliases
unalias ll                 # remove one
```

**Note:** aliases typed at the prompt vanish when the shell closes. Put them in `~/.bashrc` to keep them.

## vi / vim survival

`vi` / `vim` is on every Linux machine, so it's worth knowing the basics even if you normally use VS Code. Git opens it for commit messages by default.

It has **modes**. This is why it's confusing:
- **Normal mode** (where you start): keys are commands, not text.
- **Insert mode**: keys type text. `Esc` goes back to normal mode.
- **Command mode**: `:` from normal mode, for saving / quitting.

| Keys | Does |
|---|---|
| `i` / `a` | insert before / after the cursor |
| `o` | new line below and insert |
| `Esc` | back to normal mode (press it when in doubt) |
| `:w` | save (write) |
| `:q` | quit |
| `:wq` or `ZZ` | save and quit |
| `:q!` | quit **without** saving ⭐ |
| `h j k l` | left, down, up, right (arrows also work) |
| `0` / `$` | start / end of line |
| `gg` / `G` | top / bottom of file |
| `x` | delete character |
| `dd` | delete (cut) line; `5dd` = 5 lines |
| `yy` / `p` | copy (yank) line / paste |
| `u` / `Ctrl+R` | undo / redo |
| `/word` | search; `n` = next |
| `:%s/old/new/g` | replace all in file |

⭐ Stuck in vim: `Esc` then `:q!` and Enter.

**Tip:** `nano` is a simpler editor with the shortcuts shown at the bottom (`Ctrl+O` save, `Ctrl+X` exit). To make git use VS Code instead: `git config --global core.editor "code --wait"`.

## Package management

Linux installs software from **repositories** using a package manager (like an app store, from the terminal).

| Task | Debian / Ubuntu (`apt`) | Fedora / Red Hat (`dnf`) |
|---|---|---|
| refresh the package list | `sudo apt update` | (automatic) |
| upgrade everything | `sudo apt upgrade` | `sudo dnf upgrade` |
| install | `sudo apt install postgresql` | `sudo dnf install postgresql` |
| remove | `sudo apt remove pkg` | `sudo dnf remove pkg` |
| search | `apt search word` | `dnf search word` |
| is it installed? | `dpkg -l \| grep pkg` | `rpm -q pkg` |

**Gotcha:** `apt update` only refreshes the *list*; `apt upgrade` actually upgrades. Run update first, or install can fail with "package not found".

**Note:** dependencies (other packages a program needs) are installed automatically. That's the main reason to use the package manager instead of downloading installers.

## Storage and disk space

```bash
df -h               # free space on each mounted drive
du -sh folder       # total size of a folder
du -sh * | sort -h  # size of everything here, biggest last ⭐
lsblk               # list disks and partitions
mount               # what's mounted where
```

**Tip:** `du -sh * | sort -h` is the fastest way to find what's eating disk space.

## Networking

| Command | Does |
|---|---|
| `ping google.com` | can I reach it? (`Ctrl+C` to stop; `-c 4` = 4 pings) |
| `ip a` | my IP addresses (`ifconfig` on older systems, `ipconfig` on Windows) |
| `traceroute host` | the hops to get there |
| `ss -tuln` / `netstat -tuln` | which ports are listening (e.g. Postgres on 5432) |
| `curl URL` | fetch a URL, print to screen; `curl -o file URL` saves it |
| `wget URL` | download a file |
| `ssh user@host` | log into another machine securely (`-p 2220` = use port 2220 instead of 22) |
| `scp file user@host:path` | copy a file over SSH |

**Tip:** `curl -I URL` shows only the response headers (status code etc.), handy for checking an API is up.

**Gotcha:** `telnet` and `ftp` send passwords in plain text. Use `ssh` / `scp` / `sftp`.

## Searching for files

### find

`find where tests actions`. It walks the folder tree live, so it's always up to date but slower than `locate`.

```bash
find . -name "*.sql"                 # by name (quote the pattern!)
find . -iname "readme*"              # case-insensitive
find . -type d -name "data"          # directories only (-type f = files)
find . -size +10M                    # bigger than 10 MB (k, M, G)
find . -mtime -2                     # modified in the last 2 days
find . -mmin -30                     # modified in the last 30 minutes
find . -empty                        # empty files / folders
find . -name "*.csv" -not -path "./node_modules/*"   # exclude a folder
```

| Test | Meaning |
|---|---|
| `-name` / `-iname` | name matches (case sensitive / not) |
| `-type f` / `-type d` | file / directory |
| `-size +N` / `-size -N` | bigger / smaller than N |
| `-mtime -N` | modified less than N days ago |
| `-user name` | owned by |
| `-perm 644` | has these permissions |
| `-and` / `-or` / `-not` (or `!`) | combine tests; `\( … \)` for brackets |

Actions:

```bash
find . -name "*.tmp" -print                 # default action
find . -name "*.tmp" -delete                # delete matches (test with -print first!)
find . -name "*.py" -exec wc -l {} \;       # run a command on each match ({} = the file)
find . -name "*.py" -exec wc -l {} +        # same, but one command for all files (faster)
find . -name "*.log" | xargs rm             # pipe names to another command
```

- **Gotcha:** quote the pattern: `find . -name "*.sql"`. Without quotes the shell expands `*.sql` first, using the files in the *current* folder only.
- **Gotcha:** `-delete` has no undo. Run the same command without it (prints the list) first.
- **Gotcha:** names with spaces break `| xargs`. Use `find … -print0 | xargs -0 …`.

### locate

`locate filename` searches a database of file names. Very fast, but the database is only updated once a day (`sudo updatedb` to refresh). Not in Git Bash.

## Archiving and compression

### tar

`tar` bundles many files into one archive (`.tar`); add `z` to compress it with gzip (`.tar.gz` / `.tgz`).

| Command | Does |
|---|---|
| `tar -czvf backup.tar.gz folder/` | **c**reate, g**z**ip, **v**erbose, to **f**ile |
| `tar -tzvf backup.tar.gz` | lis**t** what's inside |
| `tar -xzvf backup.tar.gz` | e**x**tract here |
| `tar -xzvf backup.tar.gz -C dest/` | extract into `dest/` |

**Tip:** remember it as **c**reate / e**x**tract / lis**t**, + `zvf`. `f` must come last because the file name follows it.

| Other tools | Does |
|---|---|
| `gzip file` / `gunzip file.gz` | compress / decompress one file (replaces the original) |
| `zip -r out.zip folder` / `unzip out.zip` | zip format, best for sharing with Windows users |
| `bzip2`, `xz` | slower but smaller than gzip |

**Note:** compressing data that's already compressed (JPG, MP4, zip) doesn't make it smaller.

### rsync

Copies only what changed, so it's the go-to for backups.

```bash
rsync -av source/ dest/                   # archive mode, verbose
rsync -av --delete source/ dest/          # also delete files in dest that aren't in source (exact mirror)
rsync -av --dry-run source/ dest/         # show what would happen, change nothing ⭐
rsync -av project/ user@host:backups/     # over the network (SSH)
```

**Gotcha:** the trailing slash matters. `source/` = copy the *contents* of source; `source` = copy the folder itself into dest (`dest/source/…`).

## Regular expressions

A **regular expression** (regex) is a pattern for matching text. Used by `grep`, `sed`, `awk`, `find -regex`, Python's `re`, VS Code search, and SQL (`~` in PostgreSQL).

| Symbol | Matches |
|---|---|
| `.` | any one character |
| `^` | start of line |
| `$` | end of line |
| `[abc]` | one of a, b, c |
| `[^abc]` | one character NOT a, b, c (`^` inside brackets = not) |
| `[a-z]`, `[0-9]` | ranges |
| `*` | 0 or more of the previous thing |
| `+` | 1 or more (extended) |
| `?` | 0 or 1, i.e. optional (extended) |
| `{n}` / `{n,m}` | exactly n / between n and m (extended) |
| `a\|b` | a or b (extended) |
| `( )` | group (extended) |
| `\` | escape: `\.` = a real dot |

- **basic regex (BRE)**: `grep`, `sed`. `+ ? { } | ( )` are literal unless escaped with `\`.
- **extended regex (ERE)**: `grep -E`, `sed -E`, `awk`. Those symbols work without `\`.

⭐ Just always use `grep -E` / `sed -E` so the patterns work like they do in Python.

POSIX character classes (safer than ranges): `[[:digit:]]`, `[[:alpha:]]`, `[[:alnum:]]`, `[[:space:]]`, `[[:upper:]]`, `[[:lower:]]`, `[[:punct:]]`.

```bash
grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}' f    # starts with a YYYY-MM-DD date
grep -E '[0-9]{2}/[0-9]{2}/[0-9]{4}' f     # DD/MM/YYYY dates (the messy ones)
grep -E 'AED ?[0-9]+' f                    # "AED 120" or "AED120"
grep -E ',,' f                             # an empty field in a CSV
grep -E '^$' f                             # blank lines
grep -E '(Food|Groceries)' f               # either word
```

**Gotcha:** wildcards (`*.csv`) and regex (`.*\.csv`) look alike but are different. In globs `*` = anything; in regex `*` = "0 or more of the previous character", and `.` is the "anything".

### grep

`grep pattern files` prints lines that match.

| Option | Meaning |
|---|---|
| `-i` | ignore case |
| `-v` | invert: lines that do NOT match |
| `-c` | count matching lines |
| `-n` | show line numbers |
| `-l` | only list file names that match |
| `-r` | recursive through folders |
| `-w` | whole words only |
| `-o` | print only the matching part |
| `-E` | extended regex |
| `-A 2` / `-B 2` / `-C 2` | 2 lines after / before / around each match |

```bash
grep -rn "TODO" .                     # every TODO in the project, with line numbers
grep -ic "groceries" data/raw.csv     # how many rows mention groceries
grep -v '^#' config.txt               # skip comment lines
grep -rl "category_id" sql/           # which SQL files use category_id
```

**Tip:** `grep -v` is like `WHERE NOT …`. `grep -c` is like `COUNT(*) … WHERE`.

## Text processing

Text is the universal format on Linux (configs, logs, CSVs), so these tools come up all the time. They read files or stdin and write to stdout, so they chain with pipes. None of them change the original file unless told to.

### sort and uniq

| Command | Does |
|---|---|
| `sort file` | alphabetical |
| `sort -n` | numeric (so 10 comes after 9) |
| `sort -r` | reverse |
| `sort -h` | human sizes (`2K`, `1M`) |
| `sort -t, -k3` | split on `,` and sort by field 3 |
| `sort -t, -k3,3n` | by field 3 only, numerically |
| `sort -u` | sort and drop duplicates |
| `uniq` | drop *adjacent* duplicates |
| `uniq -c` | count each group ⭐ |
| `uniq -d` | only show duplicated lines |

```bash
# how many transactions per category (column 2)? = GROUP BY + COUNT + ORDER BY
tail -n +2 data/raw.csv | cut -d, -f2 | sort | uniq -c | sort -rn

# are there duplicate rows?
sort data/raw.csv | uniq -d | wc -l
```

**Gotcha:** `uniq` only removes duplicates that are next to each other. Always `sort` first.

**Tip:** `tail -n +2 file` = everything from line 2, i.e. skip the CSV header.

### cut, paste, join

```bash
cut -d, -f1,3 data/raw.csv     # columns 1 and 3, delimiter = comma
cut -d, -f2-4 file             # columns 2 to 4
cut -c1-10 file                # characters 1 to 10 of each line (e.g. a date)
paste a.txt b.txt              # put files side by side (tab-separated)
paste -d, a.txt b.txt          # comma-separated instead
join a.txt b.txt               # join 2 sorted files on their first field (like SQL JOIN)
```

**Gotcha:** `cut -d,` splits on every comma, so a quoted field like `"Food, Dining"` gets split in two. For real CSVs with quotes use Python's `csv` module (or `csvkit`).

### tr

Translates / deletes characters (stdin only).

```bash
echo "hello" | tr a-z A-Z          # HELLO
tr -d '\r' < win.csv > unix.csv    # strip Windows line endings ⭐
tr -s ' ' < file                   # squeeze repeated spaces into one
tr ',' '\t' < file.csv             # CSV → TSV
```

### sed

**Stream editor**: edits text as it flows through. Mostly used for find and replace.

```bash
sed 's/old/new/' file              # replace the FIRST match on each line
sed 's/old/new/g' file             # replace ALL matches (g = global)
sed 's/AED //g' raw.csv            # strip the "AED " prefix
sed -n '5,10p' file                # print only lines 5–10
sed '1d' file                      # delete line 1 (the header)
sed '/^$/d' file                   # delete blank lines
sed -E 's/([0-9]{2})\/([0-9]{2})\/([0-9]{4})/\3-\2-\1/' f   # DD/MM/YYYY → YYYY-MM-DD
sed -i 's/old/new/g' file          # edit the file IN PLACE
sed -i.bak 's/old/new/g' file      # in place, keep a backup as file.bak ⭐
```

- **Gotcha:** without `-i`, sed only prints the result, the file is unchanged. With `-i` there's no undo, so use `-i.bak` or test without `-i` first.
- **Tip:** the `/` delimiter can be any character. Use `|` when the text has slashes: `sed 's|/usr/bin|/opt/bin|g'`.
- **Note:** `\1`, `\2` … refer back to the `( )` groups in the pattern (needs `-E`, or `\( \)` in basic mode).

### awk (just enough)

`awk` is a mini language for column-based text. `$1`, `$2` … are fields, `$0` is the whole line, `NR` is the line number, `NF` is the number of fields.

```bash
awk -F, '{print $1, $3}' file.csv               # columns 1 and 3
awk -F, 'NR > 1 {print $3}' file.csv            # skip header
awk -F, '$3 > 1000' data/raw.csv                # rows where amount (col 3) > 1000 (WHERE)
awk -F, 'NR > 1 {sum += $3} END {print sum}' f  # total of the amount column (SUM)
awk -F, 'NR > 1 {s[$2] += $3} END {for (k in s) print k, s[k]}' f   # SUM of amount per category (GROUP BY)
awk -F, '{print NF}' f | sort -u                # how many columns per row? (spot broken rows)
```

⭐ `awk` is the tool when `cut` isn't enough: filtering on a value, doing maths, or totalling.

### diff

```bash
diff old.txt new.txt          # lines that differ (< from old, > from new)
diff -u old.txt new.txt       # unified format: the same style as git diff ⭐
diff -r dir1 dir2             # compare folders
comm -12 a.txt b.txt          # lines in BOTH sorted files (-23 = only in a, -13 = only in b)
```

### Other handy ones

| Command | Does |
|---|---|
| `nl file` | number the lines |
| `fold -w 80 file` | wrap long lines at 80 chars |
| `fmt file` | reformat paragraphs |
| `column -t -s, file.csv` | show a CSV as an aligned table ⭐ |
| `printf "%-10s %8.2f\n" Food 12.5` | formatted output (like Python f-strings) |
| `rev`, `shuf`, `split` | reverse each line / shuffle lines / split a big file |

**Tip:** `head -20 data/raw.csv | column -t -s,` gives a readable preview of a CSV in the terminal.

## Shell scripting

A shell script is a text file of commands, run top to bottom. Anything you'd type at the prompt can go in one.

```bash
#!/bin/bash
# backup.sh: back up the project's SQL folder
# The first line ("shebang") says which program runs the script.

set -euo pipefail       # stop on errors (see Debugging)

today=$(date +%F)
dest="$HOME/backups/sql_$today.tar.gz"

tar -czf "$dest" sql/
echo "Saved $dest"
```

```bash
chmod +x backup.sh      # make it executable (once)
./backup.sh             # run it
bash backup.sh          # or run it without chmod
```

**Tip:** put your scripts in `~/bin` and add it to `PATH` (see [PATH](#path)); then you can run `backup.sh` from anywhere.

### Variables

```bash
name="Arsh"              # NO spaces around =
echo "Hi $name"
echo "File: ${name}_notes.md"   # braces when text follows straight after
count=$(wc -l < data/raw.csv)    # store a command's output
total=$((count - 1))             # integer maths only
readonly PI=3.14                 # constant
```

| Special variable | Holds |
|---|---|
| `$0` | the script's name |
| `$1`, `$2` … | arguments passed to the script |
| `$#` | number of arguments |
| `$@` | all arguments (use as `"$@"`) |
| `$?` | exit status of the last command (0 = success) |
| `$$` | PID of the script |

**Gotcha:** `name = "Arsh"` (with spaces) tries to run a command called `name`. It must be `name="Arsh"`.

**Gotcha:** bash maths is integers only: `$((7 / 2))` = 3. For decimals use `bc` (`echo "7/2" | bc -l`) or awk.

### if and test

Every command returns an **exit status**: `0` = success, anything else = failure. `if` runs a command and checks its status.

```bash
if [[ -f "data/raw.csv" ]]; then
    echo "found it"
elif [[ -d "data" ]]; then
    echo "folder exists, file doesn't"
else
    echo "nothing"
fi
```

| Test | True if |
|---|---|
| `-e file` | exists |
| `-f file` | is a regular file |
| `-d dir` | is a directory |
| `-s file` | exists and isn't empty |
| `-r` / `-w` / `-x file` | readable / writable / executable |
| `-z "$s"` / `-n "$s"` | string is empty / not empty |
| `"$a" == "$b"` / `!=` | strings equal / not equal |
| `$a -eq $b` | numbers: `-eq -ne -lt -le -gt -ge` |
| `"$s" =~ regex` | matches a regex (`[[ ]]` only) |
| `&&` / `\|\|` / `!` | and / or / not |

```bash
(( count > 600 )) && echo "too many rows"   # (( )) for number comparisons, normal symbols work
mkdir out && cd out        # run the 2nd only if the 1st succeeded
cd out || exit 1           # run the 2nd only if the 1st failed
```

- ⭐ **Focus:** use `[[ ]]` (bash) for strings and files, `(( ))` for numbers.
- **Gotcha:** spaces inside the brackets are required: `[[ -f "$f" ]]` ✅, `[[-f "$f"]]` ❌.
- **Gotcha:** `>` inside `[ ]` is redirection, not "greater than". Use `-gt` or `(( ))`.

**case** for lots of choices:

```bash
case "$1" in
    start)   echo "starting" ;;
    stop)    echo "stopping" ;;
    *.csv)   echo "a CSV" ;;
    *)       echo "usage: $0 start|stop" ;;
esac
```

### Loops

```bash
for f in data/*.csv; do              # over files
    echo "$f: $(wc -l < "$f") lines"
done

for i in {1..5}; do echo "$i"; done  # over a range

for (( i=0; i<5; i++ )); do          # C style
    echo "$i"
done

count=1
while (( count <= 3 )); do           # while the condition is true
    echo "$count"
    ((count++))
done

while IFS=, read -r account category amount txn_date desc; do   # read a CSV line by line
    echo "$category: $amount"
done < <(tail -n +2 data/raw.csv)
```

- `until` = `while` with the condition flipped.
- `break` exits the loop, `continue` skips to the next round.

**Tip:** the `for f in *.csv` loop is the bash version of "do this to every file", e.g. load every CSV into Postgres.

### Functions

```bash
log() {
    local msg="$1"                      # local: only exists inside the function
    echo "[$(date +%T)] $msg"
}

log "starting import"
```

**Note:** functions get their own `$1`, `$2` …. `return` only gives back an exit status (0–255); to return a value, `echo` it and capture it: `result=$(my_func)`.

### Reading input

```bash
read -p "Your name: " name
read -sp "Password: " pass; echo        # -s = don't show what's typed
read -t 10 -p "Continue? (y/n) " ans    # time out after 10 s
```

### Debugging scripts

| Tool | Does |
|---|---|
| `bash -x script.sh` | print each command before it runs (trace) ⭐ |
| `set -x` / `set +x` | turn tracing on / off for part of a script |
| `set -e` | exit as soon as a command fails |
| `set -u` | error on unset variables (catches typos) |
| `set -o pipefail` | a pipeline fails if any part fails, not just the last |
| `echo "DEBUG: x=$x"` | old-fashioned but works |
| [shellcheck.net](https://www.shellcheck.net) | paste a script, get a list of bugs |

- ⭐ **Focus:** start scripts with `set -euo pipefail`. Bash's default is to carry on after errors, which is how scripts end up running `rm` in the wrong folder.
- **Gotcha:** `cd "$dir"; rm -rf *` is dangerous: if `cd` fails, `rm` runs in the current folder. Write `cd "$dir" || exit 1`.
- **Tip:** check `$?` right after the command you care about; the next command overwrites it.

## Gotchas

- **No undo:** `rm`, `>`, `sed -i`, `find -delete` and `mv` over an existing file are permanent. Preview with `ls` / no `-i` / `-print` / `--dry-run` first.
- **Spaces in names:** always quote: `"$file"`, `"My Folder"`.
- **Case sensitive:** `Data.csv` ≠ `data.csv`, `cd Notes` ≠ `cd notes`.
- **Spaces around `=`:** `x=5` ✅, `x = 5` ❌.
- **Windows line endings:** a file saved on Windows has `\r\n`. Scripts fail with `$'\r': command not found` and CSVs get a hidden `\r` on the last column. Fix: `tr -d '\r' < f > f2`, `dos2unix f`, or set VS Code's bottom-right "CRLF" to "LF".
- **`>` vs `>>`:** overwrite vs append.
- **`uniq` without `sort`:** misses non-adjacent duplicates.
- **Unquoted wildcard in `find`:** `find . -name *.sql` expands too early. Quote it.
- **`cut` on quoted CSVs:** commas inside quotes break it.
- **Ctrl+C / Ctrl+V in a terminal:** Ctrl+C kills; use Ctrl+Shift+C / Ctrl+Shift+V.
- **Running `./script.sh` → "Permission denied":** `chmod +x script.sh`.
- **Stuck in vim / less / man:** `Esc` `:q!` for vim, `q` for less and man.

## Linux ↔ SQL ↔ Excel

The same jobs in the 3 tools.

| Job | Linux | SQL | Excel |
|---|---|---|---|
| look at the first rows | `head -n 5 f.csv` | `SELECT * … LIMIT 5` | scroll |
| count rows | `wc -l f.csv` (minus header) | `COUNT(*)` | `ROWS()` / status bar |
| pick columns | `cut -d, -f1,3` | `SELECT a, c` | hide / choose columns |
| filter rows | `grep`, `awk -F, '$3 > 100'` | `WHERE` | Filter, `FILTER()` |
| exclude rows | `grep -v` | `WHERE NOT` | Filter → uncheck |
| sort | `sort -t, -k3,3n` | `ORDER BY` | Sort |
| distinct values | `sort -u` | `DISTINCT` | Remove Duplicates, `UNIQUE()` |
| count per group | `sort \| uniq -c` | `GROUP BY … COUNT(*)` | PivotTable |
| sum per group | `awk -F, '{s[$2]+=$3} END …'` | `GROUP BY … SUM()` | PivotTable, `SUMIFS` |
| find and replace | `sed 's/AED //g'` | `REPLACE()` | Ctrl+H / Power Query |
| join 2 files | `join` (both sorted) | `JOIN` | `XLOOKUP` |
| top n | `sort -rn \| head -n 5` | `ORDER BY … DESC LIMIT 5` | Sort + top rows |

## Practice: OverTheWire Bandit

Wargame at [overthewire.org/wargames/bandit](https://overthewire.org/wargames/bandit/). Each level's password unlocks the next. Connect with `ssh banditN@bandit.labs.overthewire.org -p 2220`.

| Level | Skill |
|---|---|
| 0 | `ssh user@host -p 2220`, then `ls`, `cat` |
| 1 | file named `-` → `cat ./-` (lone `-` = stdin) |
| 2 | spaces in the name → quotes or `\ `; `--` for names starting with `-` |
| 3 | hidden file (name starts with `.`) → `ls -a` / `ls -la` |
| 4 | find the only text file among many → `file ./*` |

Also used: `pwd` and absolute paths.
