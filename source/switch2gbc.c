
/*
	gba-switch-to-gbc - A demo to switch a GBA into GBC mode by software.
    Copyright (C) 2014 Antonio Niño Díaz (AntonioND)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Email: antonio_nd@outlook.com
*/

#include <gba.h>

u16 GBC_DISPCNT_VALUE;

void switch2gbc(void)
{
	// Reset all I/O to default values
	
	*((u16*)0x04000002) = 0; // GREENSWAP
	
	REG_BG0CNT = 0; REG_BG1CNT = 0; REG_BG3CNT = 0;
	REG_BG2PA = 0x0100; REG_BG2PB = 0x0000; REG_BG2PC = 0x0000; REG_BG2PD = 0x0100;
	REG_BG3PA = 0x0100; REG_BG3PB = 0x0000; REG_BG3PC = 0x0000; REG_BG3PD = 0x0100;
	REG_BG3X = 0; REG_BG3Y = 0; 
	
	REG_WIN0H = 0; REG_WIN0V = 0; REG_WIN1H = 0; REG_WIN1V = 0; REG_WININ = 0; REG_WINOUT = 0;
	
	REG_MOSAIC = 0; REG_BLDCNT = 0; REG_BLDALPHA = 0; REG_BLDY = 0;
	
	REG_VCOUNT = 0;
	
	REG_BG0HOFS = 0; REG_BG0VOFS = 0; REG_BG1HOFS = 0; REG_BG1VOFS = 0;
	REG_BG2HOFS = 0; REG_BG2VOFS = 0; REG_BG3HOFS = 0; REG_BG3VOFS = 0;
	
	REG_SOUND1CNT_L = 0; REG_SOUND1CNT_H = 0; REG_SOUND1CNT_X = 0;
	REG_SOUND2CNT_L = 0; REG_SOUND2CNT_H = 0;
	REG_SOUND3CNT_L = 0; REG_SOUND3CNT_H = 0; REG_SOUND3CNT_X = 0;
	REG_SOUND4CNT_L = 0; REG_SOUND4CNT_H = 0;
	
	REG_SOUNDCNT_L = 0; REG_SOUNDCNT_X = 0;
	
	REG_DMA0SAD = 0; REG_DMA0DAD = 0; REG_DMA0CNT = 0;
	REG_DMA1SAD = 0; REG_DMA1DAD = 0; REG_DMA1CNT = 0;
	REG_DMA2SAD = 0; REG_DMA2DAD = 0; REG_DMA2CNT = 0;
	REG_DMA3SAD = 0; REG_DMA3DAD = 0; REG_DMA3CNT = 0;
	
	REG_TM0CNT = 0; REG_TM1CNT = 0; REG_TM2CNT = 0; REG_TM3CNT = 0;
	
	REG_KEYCNT = 0;
	
	//REG_WAITCNT = ???
	
	//-----------------------------------------------------------------------------
	
	// Do BIOS configuration...
	
	//REG_IME = 0;
	//REG_IE = 1;
	//REG_IF = 0x0C63;
	
	//REG_DISPSTAT = 8;
	
	int i;
	for(i = 0; i < 0x18000/4; i ++) // Fill VRAM with 0xFF
		((u32*)VRAM)[i] = 0xFFFFFFFF;
	
	BG_PALETTE[0] = 0x0000;
	BG_PALETTE[1] = 0x7FFF;
	
	REG_BG2CNT = 0x4180;
	REG_BG2X = 0xFFFFD800; // -40.0
	REG_BG2Y = 0xFFFFF800; // -8.0
	
	REG_SOUNDCNT_H = 0x88C2;
	REG_SOUNDBIAS = 0xC200; // 6 bit, 262.144kHz
	
	//-----------------------------------------------------------------------------	
	
	// Extra: Things that actually work!!! :D
	
	int keys = keysHeld();
	
	if(keys&KEY_B)
	{
		*((u16*)0x04000002) = 1; // GREENSWAP
	}
	
	if(keys&KEY_UP)
	{
		REG_BG2X = 0xFFFFF000; // -16.0
		REG_BG2Y = 0xFFFFFC00; // -4.0 - Change screen position
	}
	
	// It is strange, when pressing L to stretch the screen, it seems that BG2 affine transformation is ignored.
	// When pressing R again, the affine transformation is applied again.
	
	if(keys&KEY_DOWN)
	{
		REG_BG2PA = 0x0180; // Change screen size and shape
		REG_BG2PB = 0x0010;
		REG_BG2PC = 0x0020;
		REG_BG2PD = 0x0080;
		
		//REG_BG3PA = 0x0080; // Change screen size - Does nothing, even when stretching screen
		//REG_BG2PB = 0x0010;
	}
	
	if(keys&KEY_RIGHT)
	{
		REG_BG2CNT |= BIT(6); // mosaic
		REG_MOSAIC = 0x0011;
	}
	
	if(keys&KEY_R) // Rotate 90º :P
	{
		REG_BG2X = 0<<8;
		REG_BG2Y = 160<<8;
		
		REG_BG2PA = 0x0000;
		REG_BG2PB = 0x0100;
		REG_BG2PC = 0xFF00;
		REG_BG2PD = 0x0000;
	}

	//REG_BG3CNT = 0x4180; // NOT TESTED

	
	// Note: changing BG_PALETTE does nothing. Only changes for a frame until GBA enters GBC mode.
	
	//Doing this is useless
	//BG_PALETTE[254] = 0x001F;
	//BG_PALETTE[255] = 0x03E0;
	//BG_PALETTE[254] = 0x7C00;
	//BG_PALETTE[255] = 0x7FFF;
	//for(i = 0; i < 0x18000/4; i ++)
	//	((u32*)VRAM)[i] = 0xFCFDFEFF;
	
	//-----------------------------------------------------------------------------
	
	REG_IME = 1;
	
	// DISPCNT = 0x0408 -> Video mode 0, GBC mode enabled, BG2 enabled
	// GBC mode bit can only be modified from BIOS
	GBC_DISPCNT_VALUE = 0x0408;
	CpuSet(&GBC_DISPCNT_VALUE,(void*)0x04000000, 1); // copy 1 halfword, 16 bit mode
	
	VBlankIntrWait(); // It seems that the GBC mode begins when HALTCNT is written.
	
	while(1); // Never reached in hardware. Trap emulators.
}

int main(void)
{
	irqInit();
	irqDisable(0xFFFF);
	irqEnable(IRQ_VBLANK);
	
	while(1)
	{
		VBlankIntrWait();
		scanKeys();
		if(!(keysHeld()&KEY_A)) break;
	}
	
	while(1)
	{
		VBlankIntrWait();
		scanKeys();
		if(keysHeld()&KEY_A) break;
	}
	
	switch2gbc();
	
	return 0;
}
