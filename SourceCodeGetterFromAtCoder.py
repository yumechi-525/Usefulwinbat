# Python 3.4.3
import sys
import re
import urllib.request
import urllib.parse

# replace html's symbol
# refer: http://pst.co.jp/powersoft/html/index.php?f=3401
def htmlSymbol2Char(line):
    res = line
    res = res.replace("&quot;", "\"")
    res = res.replace("&amp;", "&")
    res = res.replace("&lt;", "<")
    res = res.replace("&gt;", ">")
    res = res.replace("&nbsp;", " ")
    return res

# decide source code extention (temp)
def getExtentionName(name):
    return ".py" if "Python" in name else ".hoge"

def createSourceFile(url):
    # get html data
    # refer: http://docs.python.jp/3.3/library/urllib.request.html
    reqhtml = urllib.request.urlopen(url)

    # html decode
    # refer: http://pyshu.blog111.fc2.com/blog-entry-64.html
    # refer: http://python.civic-apps.com/string-replace/
    ct = reqhtml.getheader('Content-Type')
    encode = re.search('charset=([\w\-]+)', ct, re.I)
    if encode:
        encode = "utf-8"

    html = reqhtml.read().decode(encode)

    # for source code info
    sourceCode = []
    sourceFlag = False
    sourceStart = '<pre class="prettyprint linenums">'
    sourceEnd = '</pre>'

    # for file name info
    filename = "test"
    nameFlag = False
    extentionFlag = False
    extention = ".py"

    # analyse html data
    for h in html.split("\n"):
        h = htmlSymbol2Char(h)

        # gathering source code
        if sourceStart in h:
            sourceFlag = True
            s = h.split(sourceStart)
            sourceCode.append(s[1])
            continue
        if sourceEnd in h:
            sourceFlag = False
            s = h.split(sourceEnd)
            sourceCode.append(s[0])
        # memory source code
        if sourceFlag:
            sourceCode.append(h)

        # filename decide
        # example
        #      <th><span class="lang"><span class="lang-en">Task</span><span class="lang-ja">問題</span></span></th>
        #      <td><a href="/tasks/abc024_c">C - 民族大移動</a></td>
        if "問題" in h:
            nameFlag = True
            continue
        if nameFlag:
            s = h.split("\"")[1]
            filename = s.split("/")[-1]
            nameFlag = False

        # extention decide
        # example
        #      <th><span class="lang"><span class="lang-en">Language</span><span class="lang-ja">言語</span></span></th>
        #      <td>Python3 (3.4.2)</td>
        if "言語" in h:
            extentionFlag = True
            continue
        if extentionFlag:
            s = h.split(" ")
            idx = 0
            for i in range(len(s)):
                if "<td>" in s[i]:
                    idx = i
                    break
            # s[idx] -> <td>Python3, s[idx][4:] -> Python3
            extention = getExtentionName(s[idx][4:])
            extentionFlag = False

    # file save
    savefile = open(filename + extention, "w")
    savefile.write("".join(sourceCode))
    savefile.close()

# test URL:http://abc024.contest.atcoder.jp/submissions/415453
if __name__ == "__main__":
    # args refer: http://www.yukun.info/blog/2008/07/python-command-line-arguments.html
    args = sys.argv

    if len(args) < 2:
        # with out print "\n"
        # refer: http://www.lifewithpython.com/2013/12/python-print-without-.html
        sys.stdout.write("Please Input URL >>")
        url = input()
        createSourceFile(url)
    else:
        for arg in args[1:]:
            createSourceFile(arg)