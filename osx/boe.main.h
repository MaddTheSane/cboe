int main(void);
void Initialize(void);
void Set_Window_Drag_Bdry();
void Handle_One_Event();
void Handle_Activate();
bool handle_dialog_event() ;
void Handle_Update();
pascal void sbar_action(ControlHandle bar, short part);
pascal void item_sbar_action(ControlHandle bar, short part);
pascal void shop_sbar_action(ControlHandle bar, short part);
void Mouse_Pressed();
void close_program();
void handle_menu_choice(long choice);
void handle_apple_menu(int item_hit);
void handle_file_menu(int item_hit);
void handle_options_menu(int item_hit);
void handle_help_menu(int item_hit);
void handle_library_menu(int item_hit);
void handle_actions_menu(int item_hit);
void handle_mage_spells_menu(int item_hit);
void handle_priest_spells_menu(int item_hit);
void handle_monster_info_menu(int item_hit);
void handle_music_menu(int item_hit);
void change_cursor(Point where_curs);
void find_quickdraw();
void set_pixel_depth();
void restore_depth();
void check_sys_7();
pascal OSErr handle_open_app(AppleEvent *theAppleEvent,AppleEvent *reply,long handlerRefcon);
pascal OSErr handle_open_doc(AppleEvent *theAppleEvent,AppleEvent *reply,long handlerRefcon);
pascal OSErr handle_quit(AppleEvent *theAppleEvent,AppleEvent *reply,long handlerRefcon);
void set_up_apple_events();
void move_sound(unsigned char ter,short step);
void incidental_noises(bool on_surface);
void pause(short length);
bool sd_legit(short a, short b);