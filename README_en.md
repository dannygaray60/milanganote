# MilangaNote
Since I don't plan to pay for a subscription to use `Milanote`, then I decided to create my own clone app in [Godot Engine 4.2](https://godotengine.org/)!

## What can I do with MilangaNote?
You can create projects where you can add `Text, Headers, Images, Arrows, Color references, Web links` and all this in order to organize your ideas. It can be used to plan stories, design videogames etc.

![screenshoot](static/screenshoot.png)

## How to use the program?
Here is a video showing how to use the program and how to configure it:
[Tutorial to use MilangaNote](https://www.youtube.com/watch?v=3mBBm_nUFtU)

## Where can I download it?
It is available as an executable, check [Releases](https://github.com/dannygaray60/milanganote/releases). You can also download this repository and open it in GodotEngine 4.2 to compile it to another platform.

## Bugs / Known Issues
Because I developed this program in a short time and for personal use in my videogame [Toziuha Night](https://dannygaray60.github.io/tn-oota.html), the source code is not bug proof, so I make no guarantees that it will work perfectly. For now the bugs I have been able to find are:

 - When changing the font size of the `Header` or `Text` node if another node of the same type is selected, the font size is transferred. So when editing the node properties you have to click on an empty space to avoid this.
 - The `Arrow` node has no antialiasing and does not look good when you increase its line thickness too much.
 - The project data is saved in JSON format, I recommend not to edit this file manually because if the program finds any error when reading the file it could be corrupted.
 - The resulting JSON file is not beautified so it is not easy to edit it manually.
 
 ## Upgrades
 Obviously the program has a lot of things to improve or add, but as I said before, MilangaNote was developed for personal use, so from my side there will be no more updates or improvements if they are not necessary for my use. But anyone has the right to improve the program and create some pull request.
 
## Credits
Developed by [Danny Garay](https://dannygaray60.github.io/index.html)
Icons provided by [Flaticon.com](https://www.flaticon.com/)
