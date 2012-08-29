'Parse and Output Selectors and Declarations'
import re
from sys import stdin

if __name__ == '__main__':
    html_str = stdin.read()

    for tag, clazz, ident in re.findall(r'<(\w+)|class=[\"\']?([\w-]*)[\"\']?|id=[\"\']?([\w-]*)[\"\']?', html_str):
        if tag:
            print(tag)
        if clazz:
            print("." + clazz)
        if ident:
            print("#" + ident)

