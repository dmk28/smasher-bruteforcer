# SMASHER - a SSH/FTP bruteforcer written in Nim :boom:

Smasher is my first attempt to write an asynchronous FTP/SSH bruteforcer, though the project might expand to comport webapp endpoints as well, such as login forms and whatnot.

## How to use:


Compile the code with nim c main.nim on the main directory
Afterwards:
./main -s (for SSH)/-f (for FTP) --url=<IP only for now> --passlist=<wordlist rel or abspath> --userlist=<userlist rel or abspath>

It will ask you for the port to probe

It will then try to iterate the lists to get the right combination



