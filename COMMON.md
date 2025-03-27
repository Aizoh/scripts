## COMMON LINUX COMMANDS
DISK USAGE
```bash
# df: This is the command for "disk free.
#:du This is the command for "disk usage."
#-s: This option stands for "summarize" and gives you a total for the specified directory.
#-h: This option stands for "human-readable" and makes the output easier to read for humans 
#.: This specifies the current directory.
#
#space
df -h
#current directory usage 
du -sh .
# output the content of a particular line in a big file that cannot be opened normally for instance line 6574 of an over 20gb sql file
sed -n '6574p'filename.sql

```

