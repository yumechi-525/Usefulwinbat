# coding: UTF-8

import subprocess
import platform
import time
import os
import sys


def createData(filename):
    # set utf-8
    encoding = useEncoding()
    cmd = "git log --numstat --oneline --encoding=" + encoding + " > " + filename
    subprocess.call(cmd, shell=True)


def deleteDate(filename):
    # error check
    if os.path.exists(filename):
        os.remove(filename)


def calcRowDate(filename):
    # error check
    if not os.access(filename, os.R_OK):
        return [-1, -1, -1]

    charcode = useEncoding()

    f = open(filename, "r")
    delrow = addrow = 0

    lines = []
    line = "start"
    while f.readable() and line != "":
        # if words can't decode, set error messsage
        try:
            line = f.readline()
        except Exception as e:
            line = str(e)
        # debug print
        # print(line, -1)
        lines.append(line)

    for row in lines:
        elems = row.split("\t")
        # debug print
        # print(elems, len(elems))

        # ideal format, 3 elements
        # add\tdel\tmessage -> [add, del, message]
        if len(elems) != 3:
            continue

        # debug print
        # print(elems[0], elems[1])
        if elems[0].isdigit() and elems[1].isdigit():
            addrow += int(elems[0])
            delrow += int(elems[1])

    sumrow = addrow - delrow
    return [addrow, delrow, sumrow]  # main


def useEncoding():
    return "cp932" if platform.system() == "Windows" else "uft-8"


def main():
    nowtime = int(time.time())
    resultFileName = str(nowtime) + "_result.txt"
    createData(resultFileName)

    addrow, delrow, sumrow = calcRowDate(resultFileName)

    # if user give command line arguments and argv[1] == "-l",
    # result file don't remove.
    if not (len(sys.argv) == 2 and sys.argv[1] != "-l"):
        deleteDate(resultFileName)

    print("Result: ADD:{0}  DEL:{1}  SUM:{2}".format(addrow, delrow, sumrow))
    print("Please input Any key...")
    input()


if __name__ == '__main__':
    main()
