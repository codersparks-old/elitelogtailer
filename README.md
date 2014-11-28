elitelogtailer
==============

**DISCLAIMER: Use at your own risk, as shown in the license https://github.com/codersparks/elitelogtailer/blob/master/LICENSE .**

A ruby project to tail the elite file to find current system and then alert pilot if that system is not contained within EDSC - http://edstarcoordinator.com/

Installation
------------

elitelogtailer requires `ruby` - This can be found (for windows) here: http://rubyinstaller.org/downloads/

At the moment, this is just a proof of concept, it can be run by calling (from the directory downloaded from github):

`ruby Main.rb`

Command line parameters are:

```
-d <directory> - REQUIRED - The directory containing the netLog files
-l <level>     - OPTIONAL - The logging level to use - default: WARN (available - ERROR, WARN, INFO, DEBUG, OFF)
-t             - OPTIONAL - Use the test EDSC database (mainly used for test purposes)
-e             - OPTIONAL - This will terminate when the end of the log file is reached instead of tailing the file (again this is mainly used for test purposes)

```

The default log direcory is normally (for win7 machine):

`C:/Users/<user>/AppData/Local/Frontier_Developments/Products/FORC-FDEV-D-1002/Logs`

**A couple of gotchas**

* I have yet to have this happen to me but if the log "rolls over" into another file this will not reopen it - you will need to stop the script using `CTRL-C` and then start it again
* Because everytime you start Elite a new log is created, you will need to start the tailer after elite has started - I have found `ALT-TAB` to be flakey at best therefore I recommend you do not use that. Instead use the following:
```
1. change to run in windowed mode (`ALT-ENTER`)
2. start the tailer from command line
3. click back on the elite window and press unwindow (`ALT-ENTER`)
4. If it minimises click on the program on the task bar.
```


I will probably replace it at a later date with a "better designed" solution.

Required Gems
-------------

To read more about gems see here: http://guides.rubygems.org/

To install the required gem simply run (once ruby is installed):

`gem install <gem_name>`

This project uses the following gems (to install simply replace `gem_name` with the following in turn:

* logging
* file-tail
* win32-sound
* rest-client

Bugs, Changes, Issues
---------------------

If you find a problem with this tool please let me know by either:

1. Raising an issue here: https://github.com/codersparks/elitelogtailer/issues
2. Taking a copy and fixing the problem yourself and then submitting a pull request (https://help.github.com/articles/using-pull-requests/)

Footnote
--------

This is my first venture into Ruby so I do not claim to be proficient in this language - If you think there is a better way of doing something I am doing please let me know
