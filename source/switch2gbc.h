// SPDX-License-Identifier: MIT
//
// Copyright (c) 2014, 2020 Antonio Niño Díaz (AntonioND)

#ifndef SWITCH2GBC__
#define SWITCH2GBC__

#include <gba.h>

#define E_GREENSWAP                 (1 << 0)
#define E_MOVE_SCREEN               (1 << 1)
#define E_DISTORT_SCREEN            (1 << 2)
#define E_MOSAIC                    (1 << 3)
#define E_ROTATE_SCREEN             (1 << 4)

IWRAM_CODE void prepare_registers(void);
IWRAM_CODE void delayed_switch2gbc(void);

#endif // SWITCH2GBC__
