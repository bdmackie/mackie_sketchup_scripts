# mackie_sketchup_scripts
(c) 2017 Copyright Ben Mackie, All rights reserved.

Useful scripts for SketchUp

## Installing
This is installed by manually copying the mackie_scripts.rb file and the mackie_scripts subfolder to the SketchUp Plugins folder.
On OSX this is something like /Users/<User>/Library/Application Support/SketchUp 2017/SketchUp/Plugins.

You'll see additional menu items on the File menu including a "Reload Mackie Scripts" item which is what I use for development.
If something isn't happening, open the Ruby console when running the script to check for errors.

## Scenes exporter
* Adds additional menu items to the File menu for exporting all scenes to images with a similar filename to the SketchUp file.
* Adds "Export" and a sequential number after each image in order.
* If you want to slurp up the output and generate a PDF you can do so (on OSX) via Preview or automate with Automator.

## Credits
* Credit to Rick Wilson for his version of the Scene exporter concept.
