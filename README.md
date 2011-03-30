jQuery Background Slider
========================

What does it do?
----------------

Well... You point it at a UL full of LI's each with a single image in it, and it will scale, crop, and center them as your background, and rotate through them like a slideshow. It will also fix all of it's dimensions and positioning on resize.

Why not X?
----------

Because X doesn't scale and crop. The general consensus on how to set a picture as a full bg image is to just set the width to 100% in css. The problem with this is that it allows you to have open space if you change the browser shape to be out of ratio with the image. Another issue, is that the top and left will always be at 0,0. 

With my script, the image will always be equal to, or just bigger than the dimensions of the window. The middle of the image will also, always be affixed to the middle of the window. It's very pleasant, you should check it out.

tl;dr
-----

c'mon now... I didn't type that much... just read it.


demos
-----
[http://pthrasher.github.com/jQuery.backgroundSlider/](http://pthrasher.github.com/jQuery.backgroundSlider/)


requirements
------------

* jQuery (DUH!)
* jQueryUI (if you want fancy easing and whatnot)
* a list where each list item contains one image.

work it like so:

	$(document).ready(function(){
		$("#myList").backgroundSlider();
	});



Possible options
----------------

* easing: specify the easing (default: "linear")
* delay: how long (in milliseconds) in between slides (default: 6000)
* animationTime: duration (in milliseconds) of animation itself. (default: 600)
* current: index of first slide (first li would be 0) (default: 0)
* animType: type of slide, can be 'sidebyside' or 'reveal' (default: "reveal")