terminder
=========

#### OSX Terminal reminder for Developers.

Currently being written in C and Objective-C


### Install 
- download latest build from releases section
- `echo $PATH`and you’ll see dir, you sould copy your executable program. 
- They are separated by **':'** and you can choose any of them. I chose */usr/bin*
- `cd /usr/bin` to go there, and `open .` to open it in Finder. Drag release file to it.

### Usage
- `terminder -d <title> yyyy-mm-dd hh:mm` to add reminder on a specific date.
- `terminder -l <title> <time specifier> <time>` to add reminder on later. Time specifiers are **-d for day, -m for minute -h for hour**
- `terminder`then follow the instruction

### Example commands
- `terminder -d myremindertitle 2014-08-10 12:12`
- `terminder -l myremindertitle -h 3`
