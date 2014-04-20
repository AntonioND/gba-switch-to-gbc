gba-switch-to-gbc
=================

Routine to switch a GBA into GBC mode by software!

The source code can be found here:

[https://github.com/AntonioND/gba-switch-to-gbc](https://github.com/AntonioND/gba-switch-to-gbc)

I dissasembled the GBA BIOS and looked for the instruction that checks DISPCNT bit 15 (at address 0x00001958). If a GBC cart is detected (impossible in real hardware) a subroutine is called. Most of it is just a screen fade in, but there is some information about the registers configuration needed to switch to GBC mode.

It can even modify some other registers to change the GBC screen! It can apply an affine transformation, or apply mossaic effect... :P There are some things to test in the code.

Tested on GB Micro. Should work in GBA, GBA SP, GB Micro, but NOT in DS (If I remember correctly, the ARM7 is different, GBA mode in DS is just a compatibility mode).

The results are:
- GBA: White square screen for a moment, then black screen. Boot ROM sound still sounds.
- GBA SP: The same as GBA.
- GB Micro: Correct boot ROM animation, with sound. Nintendo logo is white (GBC CPU reads 0s?).
- DS: Doesn't work at all. Black screen. I suppose it hangs in the infinite loop at the end of the code.

A video:

[https://www.youtube.com/watch?v=-SkR8SAdS9w](https://www.youtube.com/watch?v=-SkR8SAdS9w)

Needs devkitPro. Compiled with:

- devkitARM: Version 42
- libgba: Version 20090222

My blog:

[http://antoniond_blog.drunkencoders.com/](http://antoniond_blog.drunkencoders.com/)

[http://antoniond.drunkencoders.com/](http://antoniond.drunkencoders.com/)
