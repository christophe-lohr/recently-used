# recently-used.sh

`recently-used.sh` is a bash script to play with the list of 'Recent Files' 
you used with some Linux desktop applications
and stored in your ~/.local/share/recently-used.xbel

(e.g. See:  $ gio tree recent:///)

Here, we rearrange this xml file with [xmlstarlet](https://xmlstar.sourceforge.net/)


## Usage

`recently-used.sh` [*-h*] [*file*] ...

  `-h`
: Display a short help message and exit

  `*file* ...`
: Update or add file(s) in the list of Recently Used Files

  `no args`
: Display the list of Recently Used Files


## Notice

It's a simple shell script for basic tasks, with no pretensions or guarantees.

Despite its interest, certain functions are not coded: rearrange the xml
file to sort the list (by date, by name), clean the list of dead entries
(files no longer present on the system), prune the list down to a certain
number of entries, etc.
I just don't have the use for such things.

Nor is it a question of launching a debate on a certain number of issues
- why there is not yet such tool by the gvfsd-recent team...
- is it really a good idea to maintain this list of recent used files, except the wish to mimic Microsoft Windows...
- why do so many desktop applications mismanage the list of recently used files (extract n entries at the tail of the list regardless of dates, and then reorganize this extract to obtain more recent entries)
- why do so many desktop applications ignore the plain old standard concept of Current Working Directory (man getcwd)...
- etc.

No debate here... no
