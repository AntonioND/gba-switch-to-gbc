// SPDX-License-Identifier: MIT
//
// Copyright (c) 2020 Antonio Niño Díaz (AntonioND)

#include <stdio.h>

#include <gba.h>

#include "switch2gbc.h"

extern uint16_t EFFECTS;

int main(void)
{
    irqInit();
    irqEnable(IRQ_VBLANK);

    consoleDemoInit();

    while(1)
    {
        VBlankIntrWait();

        iprintf("\x1b[0;0H");

        iprintf("Press A to continue\n");
        iprintf("\n");
        iprintf("B: GREENSWAP: %d\n", (EFFECTS & E_GREENSWAP) != 0);
        iprintf("UP: Move screen: %d\n", (EFFECTS & E_MOVE_SCREEN) != 0);
        iprintf("RIGHT: Distort screen: %d\n", (EFFECTS & E_DISTORT_SCREEN) != 0);
        iprintf("DOWN: Mosaic: %d\n", (EFFECTS & E_MOSAIC) != 0);
        iprintf("LEFT: Rotate screen: %d\n", (EFFECTS & E_ROTATE_SCREEN) != 0);

        scanKeys();

        uint16_t keys = keysDown();

        if (keys & KEY_B)
            EFFECTS ^= E_GREENSWAP;
        if (keys & KEY_UP)
            EFFECTS ^= E_MOVE_SCREEN;
        if (keys & KEY_RIGHT)
            EFFECTS ^= E_DISTORT_SCREEN;
        if (keys & KEY_DOWN)
            EFFECTS ^= E_MOSAIC;
        if (keys & KEY_LEFT)
            EFFECTS ^= E_ROTATE_SCREEN;

        if (keys & KEY_A)
            break;
    }

    irqDisable(IRQ_VBLANK);

    iprintf("\n");

    delayed_switch2gbc();

    return 0;
}
