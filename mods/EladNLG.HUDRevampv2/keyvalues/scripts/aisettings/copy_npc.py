import os

path = "C:/Program Files (x86)/Steam/steamapps/common/Titanfall2/vpk_exports/sp_beacon/scripts/turrets"
newPath = "C:/Program Files (x86)/Steam/steamapps/common/Titanfall2/"\
    "R2Northstar/mods/EladNLG.HUDRevampv2/keyvalues/scripts/turrets/"
toPaste = '''{
    ui_targetinfo ""
    ui_targetinfo "" [$mp]
    ui_targetinfo "" [$sp]
}'''

for filename in os.listdir(path):
    f = os.path.join(path, filename)
    # checking if it is a file
    if os.path.isfile(f):
        content = open(f, "r").read()
        if (content.find("ui_targetinfo") != -1):
            newFile = open(os.path.join(newPath, filename), "w+")
            newFile.write(filename.split(".")[0] + "\n" + toPaste)