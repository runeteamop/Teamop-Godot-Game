extends Node

enum ENTERED_FROM {MAIN_MENU, PAUSE_MENU}

@warning_ignore("unused_signal")


signal toggle_level
signal toggle_background
signal toggle_main_menu
signal toggle_pause_menu
signal toggle_options(entered_from: ENTERED_FROM)
