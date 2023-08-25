# Fedora Setup Script
This is my personal Fedora setup script. Due to being an NVIDIA user (for now), I sometimes encounter OS breaking updates, and rather than allow myself to get frustrated with an operating system I absolutely love because of a billion dollar company that I don't, I decided to do everything I can to make reinstalling and reconfiguring my operating system as easy as possible. This also allows me to get up and running with my favorite applications on any system very quickly. Below I am going to list out my rules/opinions on how an operating system should be. I find that Gnome + Extensions gets me the closest to my ideal experience. If you find yourself agreeing with all of my points, perhaps this script will work well for you as well. I am always up for feedback and additions to the script, though I do doubt that anyone will even find this repository let alone use it.

# Rules that make an operating system/program not cringe

1. Every desktop should be empty, or at the least should only contain files you are currently working with.
It is called a desktop for a reason. It should be clean and pretty and should be the virtual equivalent of what is on your desk. Writing a paper, or writing code? Well of course that would be on your desk. Moving files around, or going back and forth editting files? Sure. Keep it on your desk. You wouldn't need or want to have to open your filing cabinet every time you want to work on the report you are working on. What should not be on your desktop is application shortcuts, even if they are applications that you use frequently. That is what your dock or taskbar should be for. 

2. Every OS should have a dock. In that dock, You should have your show applications icon first, at the very left side, with your trash bin on the other side, to the very right. To start, your dock should have, from left to right, your settings icon, your terminal (can be omitted if you do not use a terminal), your file explorer, & your web browser. This is non-negotiable. This is simply the correct way to have a dock. Following these, your application choices are not necessarily set in stone. If you use a GUI package manager frequently, I would say that should go next, followed by any communication applications you use frequently enough to want to have in your dock. Perhaps SMS, Email, Discord, etc. All other apps in your dock can go in whatever order you see fit, but they should be organized in some way. Your development applications should be together, as should your gaming applications, and so on. The last negotiable rule is your primary text editor should be thelast application, before your trash bin. If your operating system or desktop environment does not allow you to have a dock or to change any of these settings, you are simply using the wrong operating system. This does not apply to tiling window managers.

3. You should have some sort of bar at the top of the desktop, such as a taskbar. The taskbar is used for managing applications you have in focus, displaying the time, and for applications that run in the background that don't need to be present in the dock, but do sometimes need to be opened or managed. You should also have a quick settings area to the very left of the taskbar which allows you to turn off or connect to wifi and bluetooth devices. You should also be able to manage things like screen brightness, etc. To the very left, you should have some way of managing your workspaces. If possible (I am only aware of this feature existing in KDE & Mac OS), you should have the application settings (File, Edit, etc) on the left side of your taskbar. This is most ideal and saves the most space, and I do not understand why it is not possible in Gnome. And of course, the time should be in the middle. You can also have the weather in the middle too if you'd like. 

4. Your home directory should be clean. You should have very few extra folders in your home directory. You can store your code in a folder in your documents folder, and mostly everything else can be stored in one of the default folders, within a folder. It should be very rare and unlikely to simply have files in any of the folders in your home directory. For instance, your Pictures folder will have folders such as Wallpapers, Screenshots, etc. You should never simply have a photo in ~/Pictures/photo.png or something like that. There is almost always a folder this belongs in. Your music folder should be organized by ~/Music/Artist/Album at the very least, but I would recommend nesting the artists into a separate folder, to properly separate Podcasts, for instance from your Music. Now, going back to the home folder, acceptable additional folders in your home directory would be, perhaps a Games folder, but can also include a Media folder in the event that such a folder is mounted to a larger drive that you store all of your Media in. Now this may render your Music and Videos folder useless if you do so, but you can remove or simply move those folders to your media folder. The XDG standard should be respected. If you are making an application, please for the love of God try to avoid creating any more hidden directories in the home folder, when there is already a standard in place for such files.

5. You should have the following Keybindings in place. Those with an asterisk are mandatory. Those without have wiggle room on whether or not it should be those specific keys, but you should still have a shortcut that accomplishes the same thing. 
 - Super + Left should move your window to the left half of the screen.
 - Super + Right should move your window to the right half of the screen.
 - Not required, but you get bonus points if you can also have the window take up 40% and 60% of each half of  the screen.
 - Super + Tab should allow you to switch between applications. 
 - Super + ~ should allow you to switch between windows of the same application. 
 - Super + Down should minimize the focused window.
 - Super + Up should maximize the focused window. 
 - Super + g should center the current window. The size of the window is up to you, but you should be able to center a window.*
 - Super + Shift + Up should move your window to the top half of the screen.*
 - Super + Shift + Left should move your window to the top left corner quarter of the screen.*
 - Super + Shift + Right should move your window to the top right corner quarter of the screen.* 
 - Super + Ctrl + Down should move your window to the bottom half of the screen.*
 - Super + Ctrl + Left should move your window to the bottom left corner quarter of the screen.*
 - Super + Ctrl + Right should move your window to the bottom right corner quarter of the screen.*
 - Super + T should open your terminal.*
 - Super + H should open your file explorer Home directory.*
 - Super + C should open your calculator.
 - Super + I should open your settings.*
 - Super + L should lock your Computer.

# Additional, non-Operating System Specific Rules/Opinions.

 - 16 x 10 is the optimal Resolution Ratio. The added vertical space is extremely valuable. 
 - Vertical Tabs in your web browser is optimal for the added vertical space. (This means that they are useless if they do not actually provide you with more space. Vivaldi & Microsoft Edge are the only browsers I am aware of that actually have good implementations of Vertical Tabs, and Microsoft Edge's vertical tabs are by far the best implementation.
 - Dark mode > Light Mode. 
 - Your desktop wallpaper should not be too busy. It's very difficult to find a good desktop wallpaper, and it is even more difficult to try to explain what makes a good desktop wallpaper. This is a hard rule to have, because you simply have to have good tastes to accomplish this one. Over all the years of using computers, I have only found less than 10. 
 - Window Opacity is a vastly underrated and underdeveloped feature across all operating systems. You should take advantage of terminals with the option to adjust the background and opacity, as it is a nice feature to have. The ability to have PiP windows that allow you to change the opacity of them would be an absolute game changer for those of us who like to have a video up in the corner while working, but constantly find that no matter where the video is, it is blocking off important content.

