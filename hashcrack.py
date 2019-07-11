#!/usr/bin/python

import sys
from hashlib import sha1

def main(wordlist):
    """Crack a hash using a wordlist.

    Simple loop to crack a hash. Default is the default user password
    algorithm for post-4.1 mySQL. A simple sha1 alternative is listed
    as well.

    Assumes a wordlist consisting of words separated by newlines.

    Due to the use of raw_input, this won't leave hashes in shell
    history when executing in non-interactive mode. It will leave
    the wordlist file, though.
    """

    # read hash to be cracked
    hashtocrack = raw_input('Hash to crack: ')

    # read line of wordlist file
    with open(wordlist,'r') as f:
        counter = 0
        for word in f:
            counter += 1

            # create hash
            #hash1 = '*' + sha1(word.strip()).hexdigest().upper()
            hash1 = '*' + sha1(sha1(word.strip()).digest()).hexdigest().upper()

            # compare hashes
            if hashtocrack == hash1:
                print "\nThe original string is", word
                sys.exit()

    print "Original string not found in", counter,"hashes"

main(sys.argv[1])
