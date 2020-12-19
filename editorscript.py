import os
from pathlib import Path
name = "pricklepoint" # current proj name

# get proj name from text file
# f = open('/Users/Paula/Documents/Pico-8/cproj.txt', 'r')
# name = f.read().replace('\n', '')
# f.close()

# open project files 
path = "/mnt/c/Users/Paula/Documents/pico-8/projects/" + name + "/"
dr = Path(path)

lua = " "
projectfile = dr  / 'luafiles.txt'
# text file contains names of all lua files
fcode = open(projectfile, 'r')
for line in fcode:
	fc = open(dr / line.replace('\n', ''), 'r')
	lua += fc.read() + '\n'
fcode.close()
print(lua)

# write all lua files into a giant lua file
fluastr = path + name + "-code.lua"
flua = Path(fluastr)
fp = open(flua, "w")
fp.write(lua)
fp.close()

# get cart path and windows path to run as command line (same file, 2 ways of describing path)
fname = '/mnt/c/Users/Paula/Documents/pico-8/projects/' + name + '.p8' 
cfname =  Path("C:/Users/Paula/Documents/pico-8/projects/" + name + '.p8').__str__()
other = path+name+ '.p8' # get cart in projname file that holds visual + audio 
 
# compile script with the cart 
os.system("/mnt/c/Users/Paula/Documents/pico-8/picotool-master/p8tool build " + fname + " --gfx " + fname +
 " --sfx " + fname + " --music " + fname + " --map " + fname + " --lua " + fluastr + " && /mnt/c/Users/Paula/Documents/pico-8/pico-8/pico8.exe -run " + cfname)