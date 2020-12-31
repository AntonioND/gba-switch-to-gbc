gba-switch-to-gbc
=================

Routine to switch a GBA into GBC mode by software!

The source code can be found here:

https://github.com/AntonioND/gba-switch-to-gbc

I dissasembled the GBA BIOS and looked for the instruction that checks
``DISPCNT`` bit 15 (at address ``0x00001958``). If a GBC cart is detected (
impossible in real hardware) a subroutine is called. Most of it is just a screen
fade in, but there is some information about the registers configuration needed
to switch to GBC mode.

It can even modify some other registers to change the GBC screen! It can apply
an affine transformation, or apply mossaic effect... There are some things to
test in the code.

Note that, as soon as a GBC cartridge is inserted in the GBA, EWRAM can't be
used. This means the function that switches to GBC mode (and any function that
is used to wait before switching) need to be placed in IWRAM, as well as any
variable used by the functions.

Tested on GB Micro. Should work in GBA, GBA SP, GB Micro, but NOT in DS (If I
remember correctly, the ARM7 is different, GBA mode in DS is just a
compatibility mode).

The results are:

- GBA: It works.
- GBA SP: It works.
- GB Micro: Correct boot ROM animation, with sound. Nintendo logo is white,
  which means the GBC CPU is reading zeroes from the cart instead of data.
- DS: It doesn't work at all. Black screen. I suppose it hangs in the infinite
  loop at the end of the code.
- GB Player: It works.

It seems that the GB Micro in GBC mode can't read anything from the cart. I have
to do more tests, but I've tried a cartridge that runs at 3.3V and the GB Micro
doesn't load garbage in the Nintendo logo like the real GBC or MGB.

To build it, you need devkitPro.

My website: www.skylyrac.net/

GBATEK information
------------------

Taken from here: https://problemkaputt.de/gbatek.htm#auxgbagamepakbus

    8bit-Gamepak-Switch (GBA, GBA SP only) (not DS)

    A small switch is located inside of the cartridge slot, the switch is pushed
    down when an 8bit cartridge is inserted, it is released when a GBA cartridge
    is inserted (or if no cartridge is inserted).

    The switch mechanically controls whether VDD3 or VDD5 are output at VDD35;
    ie. in GBA mode 3V power supply/signals are used for the cartridge slot and
    link port, while in 8bit mode 5V are used.

    The switch additionally drags IN35 to 3V when an 8bit cart is inserted, the
    current state of IN35 can be determined in GBA mode via Port 4000204h
    (WAITCNT), if the switch is pushed, then CGB mode can be activated via Port
    4000000h (DISPCNT.3), this bit can be set ONLY by opcodes in BIOS region
    (eg. via CpuSet SWI function).

    In 8bit mode, the cartridge bus works much like for GBA SRAM, however, the
    8bit /CS signal is expected at Pin 5, while GBA SRAM /CS2 at Pin 30 is
    interpreted as /RESET signal by the 8bit MBC chip (if any). In practice,
    this appears to result in 00h being received as data when attempting to
    read-out 8bit cartridges from inside of GBA mode.
