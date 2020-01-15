from os import listdir
from os.path import isfile, join
import json

rootpath = './blog/'
output_file = './blog/blog.json'

files = [join(rootpath, f) for f in listdir(rootpath) if isfile(join(rootpath, f))]
files.sort()

of = open(output_file, 'w')

blogs = []

for fname in files:
    with open(fname, 'r') as f:
        text = f.read()
        blogs.append({ "content": text })


json.dump({ 'data': blogs }, of)
of.close()
