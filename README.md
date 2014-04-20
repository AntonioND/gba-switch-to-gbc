gba-switch-to-gbc
=================

Routine to switch a GBA into GBC mode by software!

I dissasembled the GBA BIOS and looked for the instruction that checks DISPCNT bit 15 (at address 0x00001958). If a GBC cart is detected (impossible in real hardware) a subroutine is called. Most of it is just a screen fade in, but there is some information about the registers configuration needed to switch to GBA mode.

Tested on GB Micro. Should work in GBA, GBA SP, GB Micro, but NOT in DS (If I remember correctly, the ARM7 is different, GBA mode in DS is just a compatibility mode).

Needs devkitPro. Compiled with:

- devkitARM: Version 42
- libgba: Version20090222