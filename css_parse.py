'Parse and Output Selectors and Declarations'
import re
from sys import stdin
import collections

def update(d, u):
    for k, v in u.iteritems():
        if isinstance(v, list) and d.has_key(k) and isinstance(d[k], list):
            d[k] = d[k].extend(v)
        if isinstance(v, collections.Mapping):
            r = update(d.get(k, {}), v)
            d[k] = r
        else:
            d[k] = u[k]
    return d

if __name__ == '__main__':
    css_str = stdin.read()
    selectors = {}
    declars = []

    for selector, declaration in re.findall(r'\s*([^{]+\w)\s+({[^}]*})', css_str):
        #TODO:  Break out selectors
        #parse decl into property: [value] dict
        declar_dict = {prop:[val] for (prop, val) in re.findall(r'\s*([a-zA-Z-]+):\s+([^;]*);', declaration)}
        selects = re.split(r',\s*', selector)
        for select in selects:
           selectors[select] = update(selectors.get(select, {}), declar_dict)

    #TODO:  Output declaration options lists for each selector
    for selector, properties in selectors.iteritems():
        #find max number of overwritten (and possibly duplicate) settings for this selector
        max_overwrites = max([len(properties[key]) for key in properties.keys()])
        print("%s; %d; %s" % (selector, max_overwrites, properties)) 
