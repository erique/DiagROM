;
; Validation file for Globals structure
; This file verifies that globals.i matches the label layout
;

    IFNE (Variables-V)-(s_Variables-s_V)
        FAIL "Offset mismatch: Variables"
    ENDIF

    IFNE (Endstack-V)-(s_Endstack-s_V)
        FAIL "Offset mismatch: Endstack"
    ENDIF

    IFNE (V-V)-(s_V-s_V)
        FAIL "Offset mismatch: V"
    ENDIF

    IFNE (StackSize-V)-(s_StackSize-s_V)
        FAIL "Offset mismatch: StackSize"
    ENDIF

    IFNE (StartAddress-V)-(s_StartAddress-s_V)
        FAIL "Offset mismatch: StartAddress"
    ENDIF

    IFNE (Bpl1Ptr-V)-(s_Bpl1Ptr-s_V)
        FAIL "Offset mismatch: Bpl1Ptr"
    ENDIF

    IFNE (Bpl2Ptr-V)-(s_Bpl2Ptr-s_V)
        FAIL "Offset mismatch: Bpl2Ptr"
    ENDIF

    IFNE (Bpl3Ptr-V)-(s_Bpl3Ptr-s_V)
        FAIL "Offset mismatch: Bpl3Ptr"
    ENDIF

    IFNE (BplEnd-V)-(s_BplEnd-s_V)
        FAIL "Offset mismatch: BplEnd"
    ENDIF

    IFNE (Xpos-V)-(s_Xpos-s_V)
        FAIL "Offset mismatch: Xpos"
    ENDIF

    IFNE (Ypos-V)-(s_Ypos-s_V)
        FAIL "Offset mismatch: Ypos"
    ENDIF

    IFNE (LogYpos-V)-(s_LogYpos-s_V)
        FAIL "Offset mismatch: LogYpos"
    ENDIF

    IFNE (shit-V)-(s_shit-s_V)
        FAIL "Offset mismatch: shit"
    ENDIF

    IFNE (b2dTemp-V)-(s_b2dTemp-s_V)
        FAIL "Offset mismatch: b2dTemp"
    ENDIF

    IFNE (b2dString-V)-(s_b2dString-s_V)
        FAIL "Offset mismatch: b2dString"
    ENDIF

    IFNE (bindecoutput-V)-(s_bindecoutput-s_V)
        FAIL "Offset mismatch: bindecoutput"
    ENDIF

    IFNE (binhexoutput-V)-(s_binhexoutput-s_V)
        FAIL "Offset mismatch: binhexoutput"
    ENDIF

    IFNE (binstringoutput-V)-(s_binstringoutput-s_V)
        FAIL "Offset mismatch: binstringoutput"
    ENDIF

    IFNE (Color-V)-(s_Color-s_V)
        FAIL "Offset mismatch: Color"
    ENDIF

    IFNE (HexBinBin-V)-(s_HexBinBin-s_V)
        FAIL "Offset mismatch: HexBinBin"
    ENDIF

    IFNE (DecBinBin-V)-(s_DecBinBin-s_V)
        FAIL "Offset mismatch: DecBinBin"
    ENDIF

    IFNE (SerialSpeed-V)-(s_SerialSpeed-s_V)
        FAIL "Offset mismatch: SerialSpeed"
    ENDIF

    IFNE (OldSerialSpeed-V)-(s_OldSerialSpeed-s_V)
        FAIL "Offset mismatch: OldSerialSpeed"
    ENDIF

    IFNE (keymap-V)-(s_keymap-s_V)
        FAIL "Offset mismatch: keymap"
    ENDIF

    IFNE (NoSerial-V)-(s_NoSerial-s_V)
        FAIL "Offset mismatch: NoSerial"
    ENDIF

    IFNE (LoopB-V)-(s_LoopB-s_V)
        FAIL "Offset mismatch: LoopB"
    ENDIF

    IFNE (GetCharData-V)-(s_GetCharData-s_V)
        FAIL "Offset mismatch: GetCharData"
    ENDIF

    IFNE (keypressed-V)-(s_keypressed-s_V)
        FAIL "Offset mismatch: keypressed"
    ENDIF

    IFNE (keypressedshifted-V)-(s_keypressedshifted-s_V)
        FAIL "Offset mismatch: keypressedshifted"
    ENDIF

    IFNE (keyresult-V)-(s_keyresult-s_V)
        FAIL "Offset mismatch: keyresult"
    ENDIF

    IFNE (skipnextkey-V)-(s_skipnextkey-s_V)
        FAIL "Offset mismatch: skipnextkey"
    ENDIF

    IFNE (scancode-V)-(s_scancode-s_V)
        FAIL "Offset mismatch: scancode"
    ENDIF

    IFNE (key-V)-(s_key-s_V)
        FAIL "Offset mismatch: key"
    ENDIF

    IFNE (keyctrl-V)-(s_keyctrl-s_V)
        FAIL "Offset mismatch: keyctrl"
    ENDIF

    IFNE (keyalt-V)-(s_keyalt-s_V)
        FAIL "Offset mismatch: keyalt"
    ENDIF

    IFNE (keyshift-V)-(s_keyshift-s_V)
        FAIL "Offset mismatch: keyshift"
    ENDIF

    IFNE (keycaps-V)-(s_keycaps-s_V)
        FAIL "Offset mismatch: keycaps"
    ENDIF

    IFNE (keyup-V)-(s_keyup-s_V)
        FAIL "Offset mismatch: keyup"
    ENDIF

    IFNE (keydown-V)-(s_keydown-s_V)
        FAIL "Offset mismatch: keydown"
    ENDIF

    IFNE (keystatus-V)-(s_keystatus-s_V)
        FAIL "Offset mismatch: keystatus"
    ENDIF

    IFNE (keynew-V)-(s_keynew-s_V)
        FAIL "Offset mismatch: keynew"
    ENDIF

    IFNE (keyrepeat-V)-(s_keyrepeat-s_V)
        FAIL "Offset mismatch: keyrepeat"
    ENDIF

    IFNE (CPUCache-V)-(s_CPUCache-s_V)
        FAIL "Offset mismatch: CPUCache"
    ENDIF

    IFNE (ChipStart-V)-(s_ChipStart-s_V)
        FAIL "Offset mismatch: ChipStart"
    ENDIF

    IFNE (ChipEnd-V)-(s_ChipEnd-s_V)
        FAIL "Offset mismatch: ChipEnd"
    ENDIF

    IFNE (FastStart-V)-(s_FastStart-s_V)
        FAIL "Offset mismatch: FastStart"
    ENDIF

    IFNE (FastEnd-V)-(s_FastEnd-s_V)
        FAIL "Offset mismatch: FastEnd"
    ENDIF

    IFNE (BaseStart-V)-(s_BaseStart-s_V)
        FAIL "Offset mismatch: BaseStart"
    ENDIF

    IFNE (BaseEnd-V)-(s_BaseEnd-s_V)
        FAIL "Offset mismatch: BaseEnd"
    ENDIF

    IFNE (ChipUnreserved-V)-(s_ChipUnreserved-s_V)
        FAIL "Offset mismatch: ChipUnreserved"
    ENDIF

    IFNE (ChipUnreservedAddr-V)-(s_ChipUnreservedAddr-s_V)
        FAIL "Offset mismatch: ChipUnreservedAddr"
    ENDIF

    IFNE (FastBlocksAtBoot-V)-(s_FastBlocksAtBoot-s_V)
        FAIL "Offset mismatch: FastBlocksAtBoot"
    ENDIF

    IFNE (GetChipAddr-V)-(s_GetChipAddr-s_V)
        FAIL "Offset mismatch: GetChipAddr"
    ENDIF

    IFNE (MemAdr-V)-(s_MemAdr-s_V)
        FAIL "Offset mismatch: MemAdr"
    ENDIF

    IFNE (TotalChip-V)-(s_TotalChip-s_V)
        FAIL "Offset mismatch: TotalChip"
    ENDIF

    IFNE (TotalFast-V)-(s_TotalFast-s_V)
        FAIL "Offset mismatch: TotalFast"
    ENDIF

    IFNE (ChipAdr-V)-(s_ChipAdr-s_V)
        FAIL "Offset mismatch: ChipAdr"
    ENDIF

    IFNE (oldkey-V)-(s_oldkey-s_V)
        FAIL "Offset mismatch: oldkey"
    ENDIF

    IFNE (InputRegister-V)-(s_InputRegister-s_V)
        FAIL "Offset mismatch: InputRegister"
    ENDIF

    IFNE (OldMouse1X-V)-(s_OldMouse1X-s_V)
        FAIL "Offset mismatch: OldMouse1X"
    ENDIF

    IFNE (OldMouse1Y-V)-(s_OldMouse1Y-s_V)
        FAIL "Offset mismatch: OldMouse1Y"
    ENDIF

    IFNE (OldMouse2X-V)-(s_OldMouse2X-s_V)
        FAIL "Offset mismatch: OldMouse2X"
    ENDIF

    IFNE (OldMouse2Y-V)-(s_OldMouse2Y-s_V)
        FAIL "Offset mismatch: OldMouse2Y"
    ENDIF

    IFNE (MouseX-V)-(s_MouseX-s_V)
        FAIL "Offset mismatch: MouseX"
    ENDIF

    IFNE (MouseY-V)-(s_MouseY-s_V)
        FAIL "Offset mismatch: MouseY"
    ENDIF

    IFNE (OldMouseX-V)-(s_OldMouseX-s_V)
        FAIL "Offset mismatch: OldMouseX"
    ENDIF

    IFNE (OldMouseY-V)-(s_OldMouseY-s_V)
        FAIL "Offset mismatch: OldMouseY"
    ENDIF

    IFNE (MOUSE-V)-(s_MOUSE-s_V)
        FAIL "Offset mismatch: MOUSE"
    ENDIF

    IFNE (BUTTON-V)-(s_BUTTON-s_V)
        FAIL "Offset mismatch: BUTTON"
    ENDIF

    IFNE (MBUTTON-V)-(s_MBUTTON-s_V)
        FAIL "Offset mismatch: MBUTTON"
    ENDIF

    IFNE (LMB-V)-(s_LMB-s_V)
        FAIL "Offset mismatch: LMB"
    ENDIF

    IFNE (RMB-V)-(s_RMB-s_V)
        FAIL "Offset mismatch: RMB"
    ENDIF

    IFNE (MMB-V)-(s_MMB-s_V)
        FAIL "Offset mismatch: MMB"
    ENDIF

    IFNE (P1LMB-V)-(s_P1LMB-s_V)
        FAIL "Offset mismatch: P1LMB"
    ENDIF

    IFNE (P2LMB-V)-(s_P2LMB-s_V)
        FAIL "Offset mismatch: P2LMB"
    ENDIF

    IFNE (P1RMB-V)-(s_P1RMB-s_V)
        FAIL "Offset mismatch: P1RMB"
    ENDIF

    IFNE (P2RMB-V)-(s_P2RMB-s_V)
        FAIL "Offset mismatch: P2RMB"
    ENDIF

    IFNE (P1MMB-V)-(s_P1MMB-s_V)
        FAIL "Offset mismatch: P1MMB"
    ENDIF

    IFNE (P2MMB-V)-(s_P2MMB-s_V)
        FAIL "Offset mismatch: P2MMB"
    ENDIF

    IFNE (STUCKP1LMB-V)-(s_STUCKP1LMB-s_V)
        FAIL "Offset mismatch: STUCKP1LMB"
    ENDIF

    IFNE (STUCKP2LMB-V)-(s_STUCKP2LMB-s_V)
        FAIL "Offset mismatch: STUCKP2LMB"
    ENDIF

    IFNE (STUCKP1RMB-V)-(s_STUCKP1RMB-s_V)
        FAIL "Offset mismatch: STUCKP1RMB"
    ENDIF

    IFNE (STUCKP2RMB-V)-(s_STUCKP2RMB-s_V)
        FAIL "Offset mismatch: STUCKP2RMB"
    ENDIF

    IFNE (STUCKP1MMB-V)-(s_STUCKP1MMB-s_V)
        FAIL "Offset mismatch: STUCKP1MMB"
    ENDIF

    IFNE (STUCKP2MMB-V)-(s_STUCKP2MMB-s_V)
        FAIL "Offset mismatch: STUCKP2MMB"
    ENDIF

    IFNE (DISPAULA-V)-(s_DISPAULA-s_V)
        FAIL "Offset mismatch: DISPAULA"
    ENDIF

    IFNE (OVLErr-V)-(s_OVLErr-s_V)
        FAIL "Offset mismatch: OVLErr"
    ENDIF

    IFNE (RASTER-V)-(s_RASTER-s_V)
        FAIL "Offset mismatch: RASTER"
    ENDIF

    IFNE (SCRNMODE-V)-(s_SCRNMODE-s_V)
        FAIL "Offset mismatch: SCRNMODE"
    ENDIF

    IFNE (SerData-V)-(s_SerData-s_V)
        FAIL "Offset mismatch: SerData"
    ENDIF

    IFNE (Serial-V)-(s_Serial-s_V)
        FAIL "Offset mismatch: Serial"
    ENDIF

    IFNE (OldSerial-V)-(s_OldSerial-s_V)
        FAIL "Offset mismatch: OldSerial"
    ENDIF

    IFNE (SerBufLen-V)-(s_SerBufLen-s_V)
        FAIL "Offset mismatch: SerBufLen"
    ENDIF

    IFNE (SerBuf-V)-(s_SerBuf-s_V)
        FAIL "Offset mismatch: SerBuf"
    ENDIF

    IFNE (SerAnsiFlag-V)-(s_SerAnsiFlag-s_V)
        FAIL "Offset mismatch: SerAnsiFlag"
    ENDIF

    IFNE (SerAnsi35Flag-V)-(s_SerAnsi35Flag-s_V)
        FAIL "Offset mismatch: SerAnsi35Flag"
    ENDIF

    IFNE (SerAnsi36Flag-V)-(s_SerAnsi36Flag-s_V)
        FAIL "Offset mismatch: SerAnsi36Flag"
    ENDIF

    IFNE (SerAnsiBufLen-V)-(s_SerAnsiBufLen-s_V)
        FAIL "Offset mismatch: SerAnsiBufLen"
    ENDIF

    IFNE (SerAnsiChecks-V)-(s_SerAnsiChecks-s_V)
        FAIL "Offset mismatch: SerAnsiChecks"
    ENDIF

    IFNE (SerAnsiBuff-V)-(s_SerAnsiBuff-s_V)
        FAIL "Offset mismatch: SerAnsiBuff"
    ENDIF

    IFNE (PrintMenuFlag-V)-(s_PrintMenuFlag-s_V)
        FAIL "Offset mismatch: PrintMenuFlag"
    ENDIF

    IFNE (UpdateMenuFlag-V)-(s_UpdateMenuFlag-s_V)
        FAIL "Offset mismatch: UpdateMenuFlag"
    ENDIF

    IFNE (UpdateMenuNumber-V)-(s_UpdateMenuNumber-s_V)
        FAIL "Offset mismatch: UpdateMenuNumber"
    ENDIF

    IFNE (MenuEntrys-V)-(s_MenuEntrys-s_V)
        FAIL "Offset mismatch: MenuEntrys"
    ENDIF

    IFNE (MenuPos-V)-(s_MenuPos-s_V)
        FAIL "Offset mismatch: MenuPos"
    ENDIF

    IFNE (MenuChoose-V)-(s_MenuChoose-s_V)
        FAIL "Offset mismatch: MenuChoose"
    ENDIF

    IFNE (MenuMouseAdd-V)-(s_MenuMouseAdd-s_V)
        FAIL "Offset mismatch: MenuMouseAdd"
    ENDIF

    IFNE (MenuMouseSub-V)-(s_MenuMouseSub-s_V)
        FAIL "Offset mismatch: MenuMouseSub"
    ENDIF

    IFNE (PortJoy0-V)-(s_PortJoy0-s_V)
        FAIL "Offset mismatch: PortJoy0"
    ENDIF

    IFNE (PortJoy1-V)-(s_PortJoy1-s_V)
        FAIL "Offset mismatch: PortJoy1"
    ENDIF

    IFNE (P0Fire-V)-(s_P0Fire-s_V)
        FAIL "Offset mismatch: P0Fire"
    ENDIF

    IFNE (P1Fire-V)-(s_P1Fire-s_V)
        FAIL "Offset mismatch: P1Fire"
    ENDIF

    IFNE (P0FireOLD-V)-(s_P0FireOLD-s_V)
        FAIL "Offset mismatch: P0FireOLD"
    ENDIF

    IFNE (P1FireOLD-V)-(s_P1FireOLD-s_V)
        FAIL "Offset mismatch: P1FireOLD"
    ENDIF

    IFNE (PortJoy0OLD-V)-(s_PortJoy0OLD-s_V)
        FAIL "Offset mismatch: PortJoy0OLD"
    ENDIF

    IFNE (PortJoy1OLD-V)-(s_PortJoy1OLD-s_V)
        FAIL "Offset mismatch: PortJoy1OLD"
    ENDIF

    IFNE (PowerONStatus-V)-(s_PowerONStatus-s_V)
        FAIL "Offset mismatch: PowerONStatus"
    ENDIF

    IFNE (SerTstBps-V)-(s_SerTstBps-s_V)
        FAIL "Offset mismatch: SerTstBps"
    ENDIF

    IFNE (OldMarkItem-V)-(s_OldMarkItem-s_V)
        FAIL "Offset mismatch: OldMarkItem"
    ENDIF

    IFNE (MarkItem-V)-(s_MarkItem-s_V)
        FAIL "Offset mismatch: MarkItem"
    ENDIF

    IFNE (NoDraw-V)-(s_NoDraw-s_V)
        FAIL "Offset mismatch: NoDraw"
    ENDIF

    IFNE (WorkOrder-V)-(s_WorkOrder-s_V)
        FAIL "Offset mismatch: WorkOrder"
    ENDIF

    IFNE (MenuNumber-V)-(s_MenuNumber-s_V)
        FAIL "Offset mismatch: MenuNumber"
    ENDIF

    IFNE (OldMenuNumber-V)-(s_OldMenuNumber-s_V)
        FAIL "Offset mismatch: OldMenuNumber"
    ENDIF

    IFNE (NoChar-V)-(s_NoChar-s_V)
        FAIL "Offset mismatch: NoChar"
    ENDIF

    IFNE (Inverted-V)-(s_Inverted-s_V)
        FAIL "Offset mismatch: Inverted"
    ENDIF

    IFNE (Menu-V)-(s_Menu-s_V)
        FAIL "Offset mismatch: Menu"
    ENDIF

    IFNE (MenuVariable-V)-(s_MenuVariable-s_V)
        FAIL "Offset mismatch: MenuVariable"
    ENDIF

    IFNE (CurX-V)-(s_CurX-s_V)
        FAIL "Offset mismatch: CurX"
    ENDIF

    IFNE (CurY-V)-(s_CurY-s_V)
        FAIL "Offset mismatch: CurY"
    ENDIF

    IFNE (CurAddX-V)-(s_CurAddX-s_V)
        FAIL "Offset mismatch: CurAddX"
    ENDIF

    IFNE (CurSubX-V)-(s_CurSubX-s_V)
        FAIL "Offset mismatch: CurSubX"
    ENDIF

    IFNE (CurAddY-V)-(s_CurAddY-s_V)
        FAIL "Offset mismatch: CurAddY"
    ENDIF

    IFNE (CurSubY-V)-(s_CurSubY-s_V)
        FAIL "Offset mismatch: CurSubY"
    ENDIF

    IFNE (temp-V)-(s_temp-s_V)
        FAIL "Offset mismatch: temp"
    ENDIF

    IFNE (nomem-V)-(s_nomem-s_V)
        FAIL "Offset mismatch: nomem"
    ENDIF

    IFNE (DriveTestVar-V)-(s_DriveTestVar-s_V)
        FAIL "Offset mismatch: DriveTestVar"
    ENDIF

    IFNE (DriveNo-V)-(s_DriveNo-s_V)
        FAIL "Offset mismatch: DriveNo"
    ENDIF

    IFNE (DriveOK-V)-(s_DriveOK-s_V)
        FAIL "Offset mismatch: DriveOK"
    ENDIF

    IFNE (DriveMotor-V)-(s_DriveMotor-s_V)
        FAIL "Offset mismatch: DriveMotor"
    ENDIF

    IFNE (SideNo-V)-(s_SideNo-s_V)
        FAIL "Offset mismatch: SideNo"
    ENDIF

    IFNE (TrackNo-V)-(s_TrackNo-s_V)
        FAIL "Offset mismatch: TrackNo"
    ENDIF

    IFNE (WantedTrackNo-V)-(s_WantedTrackNo-s_V)
        FAIL "Offset mismatch: WantedTrackNo"
    ENDIF

    IFNE (oldbfe001-V)-(s_oldbfe001-s_V)
        FAIL "Offset mismatch: oldbfe001"
    ENDIF

    IFNE (oldbfd100-V)-(s_oldbfd100-s_V)
        FAIL "Offset mismatch: oldbfd100"
    ENDIF

    IFNE (sector-V)-(s_sector-s_V)
        FAIL "Offset mismatch: sector"
    ENDIF

    IFNE (trackbuff-V)-(s_trackbuff-s_V)
        FAIL "Offset mismatch: trackbuff"
    ENDIF

    IFNE (sectorbuff-V)-(s_sectorbuff-s_V)
        FAIL "Offset mismatch: sectorbuff"
    ENDIF

    IFNE (AudSimpVar-V)-(s_AudSimpVar-s_V)
        FAIL "Offset mismatch: AudSimpVar"
    ENDIF

    IFNE (AudSimpChan1-V)-(s_AudSimpChan1-s_V)
        FAIL "Offset mismatch: AudSimpChan1"
    ENDIF

    IFNE (AudSimpChan2-V)-(s_AudSimpChan2-s_V)
        FAIL "Offset mismatch: AudSimpChan2"
    ENDIF

    IFNE (AudSimpChan3-V)-(s_AudSimpChan3-s_V)
        FAIL "Offset mismatch: AudSimpChan3"
    ENDIF

    IFNE (AudSimpChan4-V)-(s_AudSimpChan4-s_V)
        FAIL "Offset mismatch: AudSimpChan4"
    ENDIF

    IFNE (AudSimpVol-V)-(s_AudSimpVol-s_V)
        FAIL "Offset mismatch: AudSimpVol"
    ENDIF

    IFNE (AudSimpWave-V)-(s_AudSimpWave-s_V)
        FAIL "Offset mismatch: AudSimpWave"
    ENDIF

    IFNE (AudSimpFilter-V)-(s_AudSimpFilter-s_V)
        FAIL "Offset mismatch: AudSimpFilter"
    ENDIF

    IFNE (AudSimpVolStr-V)-(s_AudSimpVolStr-s_V)
        FAIL "Offset mismatch: AudSimpVolStr"
    ENDIF

    IFNE (AudioWaveNo-V)-(s_AudioWaveNo-s_V)
        FAIL "Offset mismatch: AudioWaveNo"
    ENDIF

    IFNE (AudioModAddr-V)-(s_AudioModAddr-s_V)
        FAIL "Offset mismatch: AudioModAddr"
    ENDIF

    IFNE (AudioModInit-V)-(s_AudioModInit-s_V)
        FAIL "Offset mismatch: AudioModInit"
    ENDIF

    IFNE (AudioModEnd-V)-(s_AudioModEnd-s_V)
        FAIL "Offset mismatch: AudioModEnd"
    ENDIF

    IFNE (AudioModMusic-V)-(s_AudioModMusic-s_V)
        FAIL "Offset mismatch: AudioModMusic"
    ENDIF

    IFNE (AudioModMVol-V)-(s_AudioModMVol-s_V)
        FAIL "Offset mismatch: AudioModMVol"
    ENDIF

    IFNE (AudioModData-V)-(s_AudioModData-s_V)
        FAIL "Offset mismatch: AudioModData"
    ENDIF

    IFNE (AudioVolSelect-V)-(s_AudioVolSelect-s_V)
        FAIL "Offset mismatch: AudioVolSelect"
    ENDIF

    IFNE (AudioModStatData-V)-(s_AudioModStatData-s_V)
        FAIL "Offset mismatch: AudioModStatData"
    ENDIF

    IFNE (AudioModStatFormerData-V)-(s_AudioModStatFormerData-s_V)
        FAIL "Offset mismatch: AudioModStatFormerData"
    ENDIF

    IFNE (IRQLev7-V)-(s_IRQLev7-s_V)
        FAIL "Offset mismatch: IRQLev7"
    ENDIF

    IFNE (IRQLevDone-V)-(s_IRQLevDone-s_V)
        FAIL "Offset mismatch: IRQLevDone"
    ENDIF

    IFNE (Frames-V)-(s_Frames-s_V)
        FAIL "Offset mismatch: Frames"
    ENDIF

    IFNE (Ticks-V)-(s_Ticks-s_V)
        FAIL "Offset mismatch: Ticks"
    ENDIF

    IFNE (TickFrame-V)-(s_TickFrame-s_V)
        FAIL "Offset mismatch: TickFrame"
    ENDIF

    IFNE (CIAPalLow-V)-(s_CIAPalLow-s_V)
        FAIL "Offset mismatch: CIAPalLow"
    ENDIF

    IFNE (CIAPalHigh-V)-(s_CIAPalHigh-s_V)
        FAIL "Offset mismatch: CIAPalHigh"
    ENDIF

    IFNE (CIANtscLow-V)-(s_CIANtscLow-s_V)
        FAIL "Offset mismatch: CIANtscLow"
    ENDIF

    IFNE (CIANtscHigh-V)-(s_CIANtscHigh-s_V)
        FAIL "Offset mismatch: CIANtscHigh"
    ENDIF

    IFNE (CIACtrl-V)-(s_CIACtrl-s_V)
        FAIL "Offset mismatch: CIACtrl"
    ENDIF

    IFNE (RTCsec-V)-(s_RTCsec-s_V)
        FAIL "Offset mismatch: RTCsec"
    ENDIF

    IFNE (RTCirq-V)-(s_RTCirq-s_V)
        FAIL "Offset mismatch: RTCirq"
    ENDIF

    IFNE (RTC1secframe-V)-(s_RTC1secframe-s_V)
        FAIL "Offset mismatch: RTC1secframe"
    ENDIF

    IFNE (RTC10secframe-V)-(s_RTC10secframe-s_V)
        FAIL "Offset mismatch: RTC10secframe"
    ENDIF

    IFNE (RTCold-V)-(s_RTCold-s_V)
        FAIL "Offset mismatch: RTCold"
    ENDIF

    IFNE (RTCString-V)-(s_RTCString-s_V)
        FAIL "Offset mismatch: RTCString"
    ENDIF

    IFNE (MemTestStart-V)-(s_MemTestStart-s_V)
        FAIL "Offset mismatch: MemTestStart"
    ENDIF

    IFNE (MemTestEnd-V)-(s_MemTestEnd-s_V)
        FAIL "Offset mismatch: MemTestEnd"
    ENDIF

    IFNE (MemTestFail-V)-(s_MemTestFail-s_V)
        FAIL "Offset mismatch: MemTestFail"
    ENDIF

    IFNE (GfxChipset-V)-(s_GfxChipset-s_V)
        FAIL "Offset mismatch: GfxChipset"
    ENDIF

    IFNE (BootMBFastmem-V)-(s_BootMBFastmem-s_V)
        FAIL "Offset mismatch: BootMBFastmem"
    ENDIF

    IFNE (FastMem-V)-(s_FastMem-s_V)
        FAIL "Offset mismatch: FastMem"
    ENDIF

    IFNE (DetectMemRnd-V)-(s_DetectMemRnd-s_V)
        FAIL "Offset mismatch: DetectMemRnd"
    ENDIF

    IFNE (MemDetected-V)-(s_MemDetected-s_V)
        FAIL "Offset mismatch: MemDetected"
    ENDIF

    IFNE (FastmemBlock-V)-(s_FastmemBlock-s_V)
        FAIL "Offset mismatch: FastmemBlock"
    ENDIF

    IFNE (CheckMemCancel-V)-(s_CheckMemCancel-s_V)
        FAIL "Offset mismatch: CheckMemCancel"
    ENDIF

    IFNE (CheckMemPreFail-V)-(s_CheckMemPreFail-s_V)
        FAIL "Offset mismatch: CheckMemPreFail"
    ENDIF

    IFNE (CheckMemCancelReason-V)-(s_CheckMemCancelReason-s_V)
        FAIL "Offset mismatch: CheckMemCancelReason"
    ENDIF

    IFNE (CheckMemStepSize-V)-(s_CheckMemStepSize-s_V)
        FAIL "Offset mismatch: CheckMemStepSize"
    ENDIF

    IFNE (CheckMemPassQuit-V)-(s_CheckMemPassQuit-s_V)
        FAIL "Offset mismatch: CheckMemPassQuit"
    ENDIF

    IFNE (CheckMemRND-V)-(s_CheckMemRND-s_V)
        FAIL "Offset mismatch: CheckMemRND"
    ENDIF

    IFNE (CheckMemSeed-V)-(s_CheckMemSeed-s_V)
        FAIL "Offset mismatch: CheckMemSeed"
    ENDIF

    IFNE (CheckMemQuick-V)-(s_CheckMemQuick-s_V)
        FAIL "Offset mismatch: CheckMemQuick"
    ENDIF

    IFNE (CheckMemRandom-V)-(s_CheckMemRandom-s_V)
        FAIL "Offset mismatch: CheckMemRandom"
    ENDIF

    IFNE (CheckMemRandom1-V)-(s_CheckMemRandom1-s_V)
        FAIL "Offset mismatch: CheckMemRandom1"
    ENDIF

    IFNE (CheckMemRandom2-V)-(s_CheckMemRandom2-s_V)
        FAIL "Offset mismatch: CheckMemRandom2"
    ENDIF

    IFNE (CheckMemArea-V)-(s_CheckMemArea-s_V)
        FAIL "Offset mismatch: CheckMemArea"
    ENDIF

    IFNE (CheckMemAdrRnd-V)-(s_CheckMemAdrRnd-s_V)
        FAIL "Offset mismatch: CheckMemAdrRnd"
    ENDIF

    IFNE (CheckMemScanAdr-V)-(s_CheckMemScanAdr-s_V)
        FAIL "Offset mismatch: CheckMemScanAdr"
    ENDIF

    IFNE (CheckMemOldScanAdr-V)-(s_CheckMemOldScanAdr-s_V)
        FAIL "Offset mismatch: CheckMemOldScanAdr"
    ENDIF

    IFNE (CheckMemFrom-V)-(s_CheckMemFrom-s_V)
        FAIL "Offset mismatch: CheckMemFrom"
    ENDIF

    IFNE (CheckMemFrom2-V)-(s_CheckMemFrom2-s_V)
        FAIL "Offset mismatch: CheckMemFrom2"
    ENDIF

    IFNE (CheckMemTo-V)-(s_CheckMemTo-s_V)
        FAIL "Offset mismatch: CheckMemTo"
    ENDIF

    IFNE (CheckMemTo2-V)-(s_CheckMemTo2-s_V)
        FAIL "Offset mismatch: CheckMemTo2"
    ENDIF

    IFNE (CheckMemStatus-V)-(s_CheckMemStatus-s_V)
        FAIL "Offset mismatch: CheckMemStatus"
    ENDIF

    IFNE (CheckMemPass-V)-(s_CheckMemPass-s_V)
        FAIL "Offset mismatch: CheckMemPass"
    ENDIF

    IFNE (CheckMemPassOK-V)-(s_CheckMemPassOK-s_V)
        FAIL "Offset mismatch: CheckMemPassOK"
    ENDIF

    IFNE (CheckMemPassFail-V)-(s_CheckMemPassFail-s_V)
        FAIL "Offset mismatch: CheckMemPassFail"
    ENDIF

    IFNE (CheckMemPassOLD-V)-(s_CheckMemPassOLD-s_V)
        FAIL "Offset mismatch: CheckMemPassOLD"
    ENDIF

    IFNE (CheckMemPassOKOLD-V)-(s_CheckMemPassOKOLD-s_V)
        FAIL "Offset mismatch: CheckMemPassOKOLD"
    ENDIF

    IFNE (CheckMemPassFailOLD-V)-(s_CheckMemPassFailOLD-s_V)
        FAIL "Offset mismatch: CheckMemPassFailOLD"
    ENDIF

    IFNE (CheckMemBad-V)-(s_CheckMemBad-s_V)
        FAIL "Offset mismatch: CheckMemBad"
    ENDIF

    IFNE (CheckMemOldBad-V)-(s_CheckMemOldBad-s_V)
        FAIL "Offset mismatch: CheckMemOldBad"
    ENDIF

    IFNE (CheckAdrBad-V)-(s_CheckAdrBad-s_V)
        FAIL "Offset mismatch: CheckAdrBad"
    ENDIF

    IFNE (CheckMemBlock-V)-(s_CheckMemBlock-s_V)
        FAIL "Offset mismatch: CheckMemBlock"
    ENDIF

    IFNE (CheckMemBlockEnd-V)-(s_CheckMemBlockEnd-s_V)
        FAIL "Offset mismatch: CheckMemBlockEnd"
    ENDIF

    IFNE (CheckMemGoodBlock-V)-(s_CheckMemGoodBlock-s_V)
        FAIL "Offset mismatch: CheckMemGoodBlock"
    ENDIF

    IFNE (CheckMemBadBlock-V)-(s_CheckMemBadBlock-s_V)
        FAIL "Offset mismatch: CheckMemBadBlock"
    ENDIF

    IFNE (CheckMemBadAdr-V)-(s_CheckMemBadAdr-s_V)
        FAIL "Offset mismatch: CheckMemBadAdr"
    ENDIF

    IFNE (CheckMemCurrent-V)-(s_CheckMemCurrent-s_V)
        FAIL "Offset mismatch: CheckMemCurrent"
    ENDIF

    IFNE (CheckMemBlockDone-V)-(s_CheckMemBlockDone-s_V)
        FAIL "Offset mismatch: CheckMemBlockDone"
    ENDIF

    IFNE (CheckMemCurrentOLD-V)-(s_CheckMemCurrentOLD-s_V)
        FAIL "Offset mismatch: CheckMemCurrentOLD"
    ENDIF

    IFNE (CheckMemChecked-V)-(s_CheckMemChecked-s_V)
        FAIL "Offset mismatch: CheckMemChecked"
    ENDIF

    IFNE (CheckMemCheckedOLD-V)-(s_CheckMemCheckedOLD-s_V)
        FAIL "Offset mismatch: CheckMemCheckedOLD"
    ENDIF

    IFNE (CheckMemUsable-V)-(s_CheckMemUsable-s_V)
        FAIL "Offset mismatch: CheckMemUsable"
    ENDIF

    IFNE (CheckMemUsableOLD-V)-(s_CheckMemUsableOLD-s_V)
        FAIL "Offset mismatch: CheckMemUsableOLD"
    ENDIF

    IFNE (CheckMemOldUsable-V)-(s_CheckMemOldUsable-s_V)
        FAIL "Offset mismatch: CheckMemOldUsable"
    ENDIF

    IFNE (CheckMemOldNonUsable-V)-(s_CheckMemOldNonUsable-s_V)
        FAIL "Offset mismatch: CheckMemOldNonUsable"
    ENDIF

    IFNE (CheckMemNonUsable-V)-(s_CheckMemNonUsable-s_V)
        FAIL "Offset mismatch: CheckMemNonUsable"
    ENDIF

    IFNE (CheckMemNonUsableOLD-V)-(s_CheckMemNonUsableOLD-s_V)
        FAIL "Offset mismatch: CheckMemNonUsableOLD"
    ENDIF

    IFNE (CheckMemBitError-V)-(s_CheckMemBitError-s_V)
        FAIL "Offset mismatch: CheckMemBitError"
    ENDIF

    IFNE (CheckMemHighError-V)-(s_CheckMemHighError-s_V)
        FAIL "Offset mismatch: CheckMemHighError"
    ENDIF

    IFNE (CheckMemLowError-V)-(s_CheckMemLowError-s_V)
        FAIL "Offset mismatch: CheckMemLowError"
    ENDIF

    IFNE (CheckMemBitErrors-V)-(s_CheckMemBitErrors-s_V)
        FAIL "Offset mismatch: CheckMemBitErrors"
    ENDIF

    IFNE (CheckMemAdrError-V)-(s_CheckMemAdrError-s_V)
        FAIL "Offset mismatch: CheckMemAdrError"
    ENDIF

    IFNE (CheckMemAdrErrorOLD-V)-(s_CheckMemAdrErrorOLD-s_V)
        FAIL "Offset mismatch: CheckMemAdrErrorOLD"
    ENDIF

    IFNE (CheckMemAdrError2-V)-(s_CheckMemAdrError2-s_V)
        FAIL "Offset mismatch: CheckMemAdrError2"
    ENDIF

    IFNE (CheckMemAdrOldError2-V)-(s_CheckMemAdrOldError2-s_V)
        FAIL "Offset mismatch: CheckMemAdrOldError2"
    ENDIF

    IFNE (CheckMemByteErrors-V)-(s_CheckMemByteErrors-s_V)
        FAIL "Offset mismatch: CheckMemByteErrors"
    ENDIF

    IFNE (CheckMemErrors-V)-(s_CheckMemErrors-s_V)
        FAIL "Offset mismatch: CheckMemErrors"
    ENDIF

    IFNE (CheckMemErrorsOLD-V)-(s_CheckMemErrorsOLD-s_V)
        FAIL "Offset mismatch: CheckMemErrorsOLD"
    ENDIF

    IFNE (CheckMemNoErrors-V)-(s_CheckMemNoErrors-s_V)
        FAIL "Offset mismatch: CheckMemNoErrors"
    ENDIF

    IFNE (CheckMemNoErrorsBlock-V)-(s_CheckMemNoErrorsBlock-s_V)
        FAIL "Offset mismatch: CheckMemNoErrorsBlock"
    ENDIF

    IFNE (CheckMemOldNoErrors-V)-(s_CheckMemOldNoErrors-s_V)
        FAIL "Offset mismatch: CheckMemOldNoErrors"
    ENDIF

    IFNE (CheckMemType-V)-(s_CheckMemType-s_V)
        FAIL "Offset mismatch: CheckMemType"
    ENDIF

    IFNE (CheckMemTypeEnd-V)-(s_CheckMemTypeEnd-s_V)
        FAIL "Offset mismatch: CheckMemTypeEnd"
    ENDIF

    IFNE (CheckMemOldType-V)-(s_CheckMemOldType-s_V)
        FAIL "Offset mismatch: CheckMemOldType"
    ENDIF

    IFNE (CheckMemTypeChange-V)-(s_CheckMemTypeChange-s_V)
        FAIL "Offset mismatch: CheckMemTypeChange"
    ENDIF

    IFNE (CheckMemRow-V)-(s_CheckMemRow-s_V)
        FAIL "Offset mismatch: CheckMemRow"
    ENDIF

    IFNE (CheckMemCol-V)-(s_CheckMemCol-s_V)
        FAIL "Offset mismatch: CheckMemCol"
    ENDIF

    IFNE (CheckMemFast-V)-(s_CheckMemFast-s_V)
        FAIL "Offset mismatch: CheckMemFast"
    ENDIF

    IFNE (CheckMemNoShadow-V)-(s_CheckMemNoShadow-s_V)
        FAIL "Offset mismatch: CheckMemNoShadow"
    ENDIF

    IFNE (CheckMemManualX-V)-(s_CheckMemManualX-s_V)
        FAIL "Offset mismatch: CheckMemManualX"
    ENDIF

    IFNE (CheckMemManualY-V)-(s_CheckMemManualY-s_V)
        FAIL "Offset mismatch: CheckMemManualY"
    ENDIF

    IFNE (CheckMemStartAdrTxt-V)-(s_CheckMemStartAdrTxt-s_V)
        FAIL "Offset mismatch: CheckMemStartAdrTxt"
    ENDIF

    IFNE (CheckmemEndAdrTxt-V)-(s_CheckmemEndAdrTxt-s_V)
        FAIL "Offset mismatch: CheckmemEndAdrTxt"
    ENDIF

    IFNE (CheckMemTypeStart-V)-(s_CheckMemTypeStart-s_V)
        FAIL "Offset mismatch: CheckMemTypeStart"
    ENDIF

    IFNE (CheckMemEditAdr-V)-(s_CheckMemEditAdr-s_V)
        FAIL "Offset mismatch: CheckMemEditAdr"
    ENDIF

    IFNE (CheckMemEditScreenAdr-V)-(s_CheckMemEditScreenAdr-s_V)
        FAIL "Offset mismatch: CheckMemEditScreenAdr"
    ENDIF

    IFNE (CheckMemEditXpos-V)-(s_CheckMemEditXpos-s_V)
        FAIL "Offset mismatch: CheckMemEditXpos"
    ENDIF

    IFNE (CheckMemEditYpos-V)-(s_CheckMemEditYpos-s_V)
        FAIL "Offset mismatch: CheckMemEditYpos"
    ENDIF

    IFNE (CheckMemEditOldXpos-V)-(s_CheckMemEditOldXpos-s_V)
        FAIL "Offset mismatch: CheckMemEditOldXpos"
    ENDIF

    IFNE (CheckMemEditOldYpos-V)-(s_CheckMemEditOldYpos-s_V)
        FAIL "Offset mismatch: CheckMemEditOldYpos"
    ENDIF

    IFNE (CheckMemEditCharPos-V)-(s_CheckMemEditCharPos-s_V)
        FAIL "Offset mismatch: CheckMemEditCharPos"
    ENDIF

    IFNE (RunCodeStart-V)-(s_RunCodeStart-s_V)
        FAIL "Offset mismatch: RunCodeStart"
    ENDIF

    IFNE (RunCodeEnd-V)-(s_RunCodeEnd-s_V)
        FAIL "Offset mismatch: RunCodeEnd"
    ENDIF

    IFNE (RETURN-V)-(s_RETURN-s_V)
        FAIL "Offset mismatch: RETURN"
    ENDIF

    IFNE (MemTestPass-V)-(s_MemTestPass-s_V)
        FAIL "Offset mismatch: MemTestPass"
    ENDIF

    IFNE (KeyBOld-V)-(s_KeyBOld-s_V)
        FAIL "Offset mismatch: KeyBOld"
    ENDIF

    IFNE (TF1260MemStart-V)-(s_TF1260MemStart-s_V)
        FAIL "Offset mismatch: TF1260MemStart"
    ENDIF

    IFNE (TF1260MemEnd-V)-(s_TF1260MemEnd-s_V)
        FAIL "Offset mismatch: TF1260MemEnd"
    ENDIF

    IFNE (TF1260IOStart-V)-(s_TF1260IOStart-s_V)
        FAIL "Offset mismatch: TF1260IOStart"
    ENDIF

    IFNE (TF1260IOEnd-V)-(s_TF1260IOEnd-s_V)
        FAIL "Offset mismatch: TF1260IOEnd"
    ENDIF

    IFNE (ShowMemAdr-V)-(s_ShowMemAdr-s_V)
        FAIL "Offset mismatch: ShowMemAdr"
    ENDIF

    IFNE (savexpos-V)-(s_savexpos-s_V)
        FAIL "Offset mismatch: savexpos"
    ENDIF

    IFNE (saveypos-V)-(s_saveypos-s_V)
        FAIL "Offset mismatch: saveypos"
    ENDIF

    IFNE (savecol-V)-(s_savecol-s_V)
        FAIL "Offset mismatch: savecol"
    ENDIF

    IFNE (FirstMBMem-V)-(s_FirstMBMem-s_V)
        FAIL "Offset mismatch: FirstMBMem"
    ENDIF

    IFNE (MBMemSize-V)-(s_MBMemSize-s_V)
        FAIL "Offset mismatch: MBMemSize"
    ENDIF

    IFNE (DebugA0-V)-(s_DebugA0-s_V)
        FAIL "Offset mismatch: DebugA0"
    ENDIF

    IFNE (DebugD1-V)-(s_DebugD1-s_V)
        FAIL "Offset mismatch: DebugD1"
    ENDIF

    IFNE (DebD0-V)-(s_DebD0-s_V)
        FAIL "Offset mismatch: DebD0"
    ENDIF

    IFNE (DebD1-V)-(s_DebD1-s_V)
        FAIL "Offset mismatch: DebD1"
    ENDIF

    IFNE (DebD2-V)-(s_DebD2-s_V)
        FAIL "Offset mismatch: DebD2"
    ENDIF

    IFNE (DebD3-V)-(s_DebD3-s_V)
        FAIL "Offset mismatch: DebD3"
    ENDIF

    IFNE (DebD4-V)-(s_DebD4-s_V)
        FAIL "Offset mismatch: DebD4"
    ENDIF

    IFNE (DebD5-V)-(s_DebD5-s_V)
        FAIL "Offset mismatch: DebD5"
    ENDIF

    IFNE (DebD6-V)-(s_DebD6-s_V)
        FAIL "Offset mismatch: DebD6"
    ENDIF

    IFNE (DebD7-V)-(s_DebD7-s_V)
        FAIL "Offset mismatch: DebD7"
    ENDIF

    IFNE (DebA0-V)-(s_DebA0-s_V)
        FAIL "Offset mismatch: DebA0"
    ENDIF

    IFNE (DebA1-V)-(s_DebA1-s_V)
        FAIL "Offset mismatch: DebA1"
    ENDIF

    IFNE (DebA2-V)-(s_DebA2-s_V)
        FAIL "Offset mismatch: DebA2"
    ENDIF

    IFNE (DebA3-V)-(s_DebA3-s_V)
        FAIL "Offset mismatch: DebA3"
    ENDIF

    IFNE (DebA4-V)-(s_DebA4-s_V)
        FAIL "Offset mismatch: DebA4"
    ENDIF

    IFNE (DebA5-V)-(s_DebA5-s_V)
        FAIL "Offset mismatch: DebA5"
    ENDIF

    IFNE (DebA6-V)-(s_DebA6-s_V)
        FAIL "Offset mismatch: DebA6"
    ENDIF

    IFNE (DebA7-V)-(s_DebA7-s_V)
        FAIL "Offset mismatch: DebA7"
    ENDIF

    IFNE (DebSR-V)-(s_DebSR-s_V)
        FAIL "Offset mismatch: DebSR"
    ENDIF

    IFNE (DebPC-V)-(s_DebPC-s_V)
        FAIL "Offset mismatch: DebPC"
    ENDIF

    IFNE (MEMCHECKSIZE-V)-(s_MEMCHECKSIZE-s_V)
        FAIL "Offset mismatch: MEMCHECKSIZE"
    ENDIF

    IFNE (BLTDDAT-V)-(s_BLTDDAT-s_V)
        FAIL "Offset mismatch: BLTDDAT"
    ENDIF

    IFNE (DMACONR-V)-(s_DMACONR-s_V)
        FAIL "Offset mismatch: DMACONR"
    ENDIF

    IFNE (VPOSR-V)-(s_VPOSR-s_V)
        FAIL "Offset mismatch: VPOSR"
    ENDIF

    IFNE (VHPOSR-V)-(s_VHPOSR-s_V)
        FAIL "Offset mismatch: VHPOSR"
    ENDIF

    IFNE (DSKDATR-V)-(s_DSKDATR-s_V)
        FAIL "Offset mismatch: DSKDATR"
    ENDIF

    IFNE (JOY0DAT-V)-(s_JOY0DAT-s_V)
        FAIL "Offset mismatch: JOY0DAT"
    ENDIF

    IFNE (JOY1DAT-V)-(s_JOY1DAT-s_V)
        FAIL "Offset mismatch: JOY1DAT"
    ENDIF

    IFNE (CLXDAT-V)-(s_CLXDAT-s_V)
        FAIL "Offset mismatch: CLXDAT"
    ENDIF

    IFNE (ADKCONR-V)-(s_ADKCONR-s_V)
        FAIL "Offset mismatch: ADKCONR"
    ENDIF

    IFNE (POT0DAT-V)-(s_POT0DAT-s_V)
        FAIL "Offset mismatch: POT0DAT"
    ENDIF

    IFNE (POT1DAT-V)-(s_POT1DAT-s_V)
        FAIL "Offset mismatch: POT1DAT"
    ENDIF

    IFNE (POTINP-V)-(s_POTINP-s_V)
        FAIL "Offset mismatch: POTINP"
    ENDIF

    IFNE (SERDATR-V)-(s_SERDATR-s_V)
        FAIL "Offset mismatch: SERDATR"
    ENDIF

    IFNE (DSKBYTR-V)-(s_DSKBYTR-s_V)
        FAIL "Offset mismatch: DSKBYTR"
    ENDIF

    IFNE (INTENAR-V)-(s_INTENAR-s_V)
        FAIL "Offset mismatch: INTENAR"
    ENDIF

    IFNE (INTREQR-V)-(s_INTREQR-s_V)
        FAIL "Offset mismatch: INTREQR"
    ENDIF

    IFNE (DENISEID-V)-(s_DENISEID-s_V)
        FAIL "Offset mismatch: DENISEID"
    ENDIF

    IFNE (HHPOSR-V)-(s_HHPOSR-s_V)
        FAIL "Offset mismatch: HHPOSR"
    ENDIF

    IFNE (CIAAPRA-V)-(s_CIAAPRA-s_V)
        FAIL "Offset mismatch: CIAAPRA"
    ENDIF

    IFNE (Passno-V)-(s_Passno-s_V)
        FAIL "Offset mismatch: Passno"
    ENDIF

    IFNE (CPU-V)-(s_CPU-s_V)
        FAIL "Offset mismatch: CPU"
    ENDIF

    IFNE (CPUGen-V)-(s_CPUGen-s_V)
        FAIL "Offset mismatch: CPUGen"
    ENDIF

    IFNE (FPU-V)-(s_FPU-s_V)
        FAIL "Offset mismatch: FPU"
    ENDIF

    IFNE (PCRReg-V)-(s_PCRReg-s_V)
        FAIL "Offset mismatch: PCRReg"
    ENDIF

    IFNE (CPU060Rev-V)-(s_CPU060Rev-s_V)
        FAIL "Offset mismatch: CPU060Rev"
    ENDIF

    IFNE (MMU-V)-(s_MMU-s_V)
        FAIL "Offset mismatch: MMU"
    ENDIF

    IFNE (ADR24BIT-V)-(s_ADR24BIT-s_V)
        FAIL "Offset mismatch: ADR24BIT"
    ENDIF

    IFNE (CPUPointer-V)-(s_CPUPointer-s_V)
        FAIL "Offset mismatch: CPUPointer"
    ENDIF

    IFNE (FPUPointer-V)-(s_FPUPointer-s_V)
        FAIL "Offset mismatch: FPUPointer"
    ENDIF

    IFNE (GayleData-V)-(s_GayleData-s_V)
        FAIL "Offset mismatch: GayleData"
    ENDIF

    IFNE (DiskBuffer-V)-(s_DiskBuffer-s_V)
        FAIL "Offset mismatch: DiskBuffer"
    ENDIF

    IFNE (GfxTestBpl-V)-(s_GfxTestBpl-s_V)
        FAIL "Offset mismatch: GfxTestBpl"
    ENDIF

    IFNE (OKtxt-V)-(s_OKtxt-s_V)
        FAIL "Offset mismatch: OKtxt"
    ENDIF

    IFNE (SHIT-V)-(s_SHIT-s_V)
        FAIL "Offset mismatch: SHIT"
    ENDIF

    IFNE (C-V)-(s_C-s_V)
        FAIL "Offset mismatch: C"
    ENDIF

    IFNE (MenuCopper-V)-(s_MenuCopper-s_V)
        FAIL "Offset mismatch: MenuCopper"
    ENDIF

    IFNE (ECSCopper-V)-(s_ECSCopper-s_V)
        FAIL "Offset mismatch: ECSCopper"
    ENDIF

    IFNE (ECSCopper2-V)-(s_ECSCopper2-s_V)
        FAIL "Offset mismatch: ECSCopper2"
    ENDIF

    IFNE (JunkBuffer-V)-(s_JunkBuffer-s_V)
        FAIL "Offset mismatch: JunkBuffer"
    ENDIF

    IFNE (AudioWaves-V)-(s_AudioWaves-s_V)
        FAIL "Offset mismatch: AudioWaves"
    ENDIF

    IFNE (DummySprite-V)-(s_DummySprite-s_V)
        FAIL "Offset mismatch: DummySprite"
    ENDIF

    IFNE (AutoConfDone-V)-(s_AutoConfDone-s_V)
        FAIL "Offset mismatch: AutoConfDone"
    ENDIF

    IFNE (AutoConfFlag-V)-(s_AutoConfFlag-s_V)
        FAIL "Offset mismatch: AutoConfFlag"
    ENDIF

    IFNE (AutoConfBoards-V)-(s_AutoConfBoards-s_V)
        FAIL "Offset mismatch: AutoConfBoards"
    ENDIF

    IFNE (AutoConfList-V)-(s_AutoConfList-s_V)
        FAIL "Offset mismatch: AutoConfList"
    ENDIF

    IFNE (AutoConfMode-V)-(s_AutoConfMode-s_V)
        FAIL "Offset mismatch: AutoConfMode"
    ENDIF

    IFNE (AutoConfBuffer-V)-(s_AutoConfBuffer-s_V)
        FAIL "Offset mismatch: AutoConfBuffer"
    ENDIF

    IFNE (AutoConfShutD-V)-(s_AutoConfShutD-s_V)
        FAIL "Offset mismatch: AutoConfShutD"
    ENDIF

    IFNE (AutoConfZ2Ram-V)-(s_AutoConfZ2Ram-s_V)
        FAIL "Offset mismatch: AutoConfZ2Ram"
    ENDIF

    IFNE (AutoConfZ2IO-V)-(s_AutoConfZ2IO-s_V)
        FAIL "Offset mismatch: AutoConfZ2IO"
    ENDIF

    IFNE (AutoConfZ3-V)-(s_AutoConfZ3-s_V)
        FAIL "Offset mismatch: AutoConfZ3"
    ENDIF

    IFNE (AutoConfType-V)-(s_AutoConfType-s_V)
        FAIL "Offset mismatch: AutoConfType"
    ENDIF

    IFNE (BackupAutoConfZ2Ram-V)-(s_BackupAutoConfZ2Ram-s_V)
        FAIL "Offset mismatch: BackupAutoConfZ2Ram"
    ENDIF

    IFNE (BackupAutoConfZ2IO-V)-(s_BackupAutoConfZ2IO-s_V)
        FAIL "Offset mismatch: BackupAutoConfZ2IO"
    ENDIF

    IFNE (BackupAutoConfZ3-V)-(s_BackupAutoConfZ3-s_V)
        FAIL "Offset mismatch: BackupAutoConfZ3"
    ENDIF

    IFNE (AutoConfExit-V)-(s_AutoConfExit-s_V)
        FAIL "Offset mismatch: AutoConfExit"
    ENDIF

    IFNE (AutoConfIllegal-V)-(s_AutoConfIllegal-s_V)
        FAIL "Offset mismatch: AutoConfIllegal"
    ENDIF

    IFNE (AutoConfZorro-V)-(s_AutoConfZorro-s_V)
        FAIL "Offset mismatch: AutoConfZorro"
    ENDIF

    IFNE (AutoConfSize-V)-(s_AutoConfSize-s_V)
        FAIL "Offset mismatch: AutoConfSize"
    ENDIF

    IFNE (AutoConfWByte-V)-(s_AutoConfWByte-s_V)
        FAIL "Offset mismatch: AutoConfWByte"
    ENDIF

    IFNE (AutoConfAddr-V)-(s_AutoConfAddr-s_V)
        FAIL "Offset mismatch: AutoConfAddr"
    ENDIF

    IFNE (AutoConfFrom-V)-(s_AutoConfFrom-s_V)
        FAIL "Offset mismatch: AutoConfFrom"
    ENDIF

    IFNE (AutoConfTo-V)-(s_AutoConfTo-s_V)
        FAIL "Offset mismatch: AutoConfTo"
    ENDIF

    IFNE (Bpl1str-V)-(s_Bpl1str-s_V)
        FAIL "Offset mismatch: Bpl1str"
    ENDIF

    IFNE (Bpl1-V)-(s_Bpl1-s_V)
        FAIL "Offset mismatch: Bpl1"
    ENDIF

    IFNE (EndBpl1-V)-(s_EndBpl1-s_V)
        FAIL "Offset mismatch: EndBpl1"
    ENDIF

    IFNE (Bpl2str-V)-(s_Bpl2str-s_V)
        FAIL "Offset mismatch: Bpl2str"
    ENDIF

    IFNE (Bpl2-V)-(s_Bpl2-s_V)
        FAIL "Offset mismatch: Bpl2"
    ENDIF

    IFNE (EndBpl2-V)-(s_EndBpl2-s_V)
        FAIL "Offset mismatch: EndBpl2"
    ENDIF

    IFNE (Bpl3str-V)-(s_Bpl3str-s_V)
        FAIL "Offset mismatch: Bpl3str"
    ENDIF

    IFNE (Bpl3-V)-(s_Bpl3-s_V)
        FAIL "Offset mismatch: Bpl3"
    ENDIF

    IFNE (EndBpl3-V)-(s_EndBpl3-s_V)
        FAIL "Offset mismatch: EndBpl3"
    ENDIF

    ifeq	a1k
    IFNE (ptplay-V)-(s_ptplay-s_V)
        FAIL "Offset mismatch: ptplay"
    ENDIF

    endc
    IFNE (EndData-V)-(s_EndData-s_V)
        FAIL "Offset mismatch: EndData"
    ENDIF
