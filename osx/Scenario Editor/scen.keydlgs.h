void fancy_choice_dialog_event_filter (short item_hit);
short fancy_choice_dialog(short which_dlog,short parent);
void display_strings_event_filter (short item_hit);
bool cre(short val,short min,short max,char *text1, char *text2,short parent_num) ;
void give_error(char *text1, char *text2,short parent_num);
void display_strings_event_filter (short item_hit);
void display_strings(char *text1, char *text2,
	char *title,short sound_num,short graphic_num,short graphic_type,short parent_num);
void choose_graphic_event_filter (short item_hit);
void put_choice_pics(short g_type);
short choose_graphic(short first_g,short last_g,short cur_choice,short g_type,short parent_num);
void put_text_res();
short choose_text_res(short res_list,short first_t,short last_t,short cur_choice,short parent_num,char *title);
void choose_text_res_event_filter (short item_hit);
void edit_text_event_filter (short item_hit);
void edit_text_str(short which_str,short mode);
bool save_spec_enc();
void put_spec_enc_in_dlog();
void edit_spec_enc_event_filter (short item_hit);
void edit_spec_enc(short which_node,short mode,short parent_num);
short get_fresh_spec(short which_mode);
void edit_spec_text_event_filter (short item_hit);
void edit_spec_text(short mode,short *str1,short *str2,short parent);
void edit_dialog_text(short mode,short *str1,short parent);
void edit_spec_text(short mode,short *str1,short *str2,short parent);
void edit_special_num_event_filter (short item_hit);
short edit_special_num(short mode,short what_start);
void edit_scen_intro_event_filter (short item_hit);
void edit_scen_intro();
short choice_dialog(short pic,short num);
bool edit_area_rect_str(short which_str,short mode);
void edit_area_rect_event_filter (short item_hit);
void make_cursor_sword() ;
void edit_dialog_text_event_filter (short item_hit);
void edit_dialog_text(short mode,short *str1,short parent);
void set_cursor(short which_c) ;
void restore_cursor();
