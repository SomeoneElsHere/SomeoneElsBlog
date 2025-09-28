+++
date = '2025-09-01T09:40:32-05:00'
draft = false
title = 'Mips Map'
+++





Hi there! This is a simple graphics-thing that I made for MIPS using the MARS IDE.

To use, it is recommended you use the MARS IDE. 



First, set the bitmap tool to the following settings: 2px for pixel width and height, 128px for window width and height, and then set the heap as the starting address. Connect it to the IDE and run it. It should show a little face :D 



You can use the 'methods' that I created, that being the writeDot method and the doHorz and doVer methods. Use the corresponding registers and you should be fine. Emphasis on should. Anyways, have fun!

[EDIT 1] 

Now the map was edited with the new writeTextDecimal 0-9, writeTextCapital A-Z (capital), and writeTextPunct (:,!,.,?) functions! Keep in mind they operate on a 8 by 10 grid.
On startup, the bitmap now should display "HELLO WORLD!"


[Download Here](/SomeoneElsBlog/downloads/map.asm)

