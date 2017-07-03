//
//  winutil.mac.mm
//  BoE
//
//  Created by Celtic Minstrel on 14-03-28.
//
//

#include "winutil.hpp"
#include <Cocoa/Cocoa.h>
#include <AppKit/NSBitmapImageRep.h>
#include <SFML/Graphics/RenderWindow.hpp>
#include <sstream>

// TODO: I'm sure there's a better way to do this (maybe one that's keyboard layout agnostic)
// The proper way would involve use of the TextEntered event
char keyToChar(sf::Keyboard::Key key, bool isShift) {
	using kb = sf::Keyboard;
	switch(key) {
		case kb::A: return isShift ? 'A' : 'a';
		case kb::B: return isShift ? 'B' : 'b';
		case kb::C: return isShift ? 'C' : 'c';
		case kb::D: return isShift ? 'D' : 'd';
		case kb::E: return isShift ? 'E' : 'e';
		case kb::F: return isShift ? 'F' : 'f';
		case kb::G: return isShift ? 'G' : 'g';
		case kb::H: return isShift ? 'H' : 'h';
		case kb::I: return isShift ? 'I' : 'i';
		case kb::J: return isShift ? 'J' : 'j';
		case kb::K: return isShift ? 'K' : 'k';
		case kb::L: return isShift ? 'L' : 'l';
		case kb::M: return isShift ? 'M' : 'm';
		case kb::N: return isShift ? 'N' : 'n';
		case kb::O: return isShift ? 'O' : 'o';
		case kb::P: return isShift ? 'P' : 'p';
		case kb::Q: return isShift ? 'Q' : 'q';
		case kb::R: return isShift ? 'R' : 'r';
		case kb::S: return isShift ? 'S' : 's';
		case kb::T: return isShift ? 'T' : 't';
		case kb::U: return isShift ? 'U' : 'u';
		case kb::V: return isShift ? 'V' : 'v';
		case kb::W: return isShift ? 'W' : 'w';
		case kb::X: return isShift ? 'X' : 'x';
		case kb::Y: return isShift ? 'Y' : 'y';
		case kb::Z: return isShift ? 'Z' : 'z';
		case kb::Num1: return isShift ? '!' : '1';
		case kb::Num2: return isShift ? '@' : '2';
		case kb::Num3: return isShift ? '#' : '3';
		case kb::Num4: return isShift ? '$' : '4';
		case kb::Num5: return isShift ? '%' : '5';
		case kb::Num6: return isShift ? '^' : '6';
		case kb::Num7: return isShift ? '&' : '7';
		case kb::Num8: return isShift ? '*' : '8';
		case kb::Num9: return isShift ? '(' : '9';
		case kb::Num0: return isShift ? ')' : '0';
		case kb::Tilde: return isShift ? '~' : '`';
		case kb::Dash: return isShift ? '_' : '-';
		case kb::Equal: return isShift ? '+' : '=';
		case kb::LBracket: return isShift ? '{' : '[';
		case kb::RBracket: return isShift ? '}' : ']';
		case kb::SemiColon: return isShift ? ':' : ';';
		case kb::Quote: return isShift ? '"' : '\'';
		case kb::Comma: return isShift ? '<' : ',';
		case kb::Period: return isShift ? '>' : '.';
		case kb::Slash: return isShift ? '?' : '/';
		case kb::BackSlash: return isShift ? '|' : '\\';
		case kb::Tab: return '\t';
		case kb::Space: return ' ';
		case kb::Return: return '\n';
		case kb::BackSpace: return '\b';
		case kb::Delete: return '\x7f';
		case kb::Numpad0: return '0';
		case kb::Numpad1: return '1';
		case kb::Numpad2: return '2';
		case kb::Numpad3: return '3';
		case kb::Numpad4: return '4';
		case kb::Numpad5: return '5';
		case kb::Numpad6: return '6';
		case kb::Numpad7: return '7';
		case kb::Numpad8: return '8';
		case kb::Numpad9: return '9';
			// TODO: Should have Equal here, but SFML doesn't distinguish between normal and keybad equal :/
			// Ditto for the decimal point.
		case kb::Divide: return '/';
		case kb::Multiply: return '*';
		case kb::Subtract: return '-';
		case kb::Add: return '+';
		default: break;
	}
	return 0;
}

std::string get_os_version() {
	NSProcessInfo* info = [NSProcessInfo processInfo];
	std::ostringstream os;
	os << "Apple Mac OS X ";
	os << [[info operatingSystemVersionString] UTF8String];
	return os.str();
}

void makeFrontWindow(sf::Window& win) {
	sf::WindowHandle handle = win.getSystemHandle();
	id nsHandle = (__bridge id)(handle);
	if([nsHandle isKindOfClass: [NSWindow class]]) {
		[nsHandle orderFrontRegardless];
		[nsHandle makeKeyWindow];
	}
}

void setWindowFloating(sf::Window& win, bool floating) {
	sf::WindowHandle handle = win.getSystemHandle();
	id nsHandle = (__bridge id)(handle);
	if([nsHandle isKindOfClass: [NSWindow class]]) {
		[nsHandle setLevel: floating ? NSFloatingWindowLevel : NSNormalWindowLevel];
	}
}

ModalSession::ModalSession(sf::Window& win, sf::Window& /*parent*/) {
	sf::WindowHandle handle = win.getSystemHandle();
	id nsHandle = (__bridge id)(handle);
	if([nsHandle isKindOfClass: [NSWindow class]])
		session = [[NSApplication sharedApplication] beginModalSessionForWindow: nsHandle];
}

ModalSession::~ModalSession() {
	NSModalSession nsHandle = (NSModalSession)session;
	[[NSApplication sharedApplication] endModalSession: nsHandle];
}

void ModalSession::pumpEvents() {
	NSModalSession nsHandle = (NSModalSession)session;
	[[NSApplication sharedApplication] runModalSession: nsHandle];
}

void set_clipboard(std::string text) {
	NSString* str = [[NSString stringWithUTF8String: text.c_str()] stringByReplacingOccurrencesOfString: @"|" withString: @"\n"];
	NSArray* contents = [NSArray arrayWithObject: str];
	NSPasteboard* pb = [NSPasteboard generalPasteboard];
	[pb clearContents];
	[pb writeObjects: contents];
}

std::string get_clipboard() {
	NSPasteboard* pb = [NSPasteboard generalPasteboard];
	NSDictionary* options = [NSDictionary dictionary];
	NSArray* types = [NSArray arrayWithObject: [NSString class]];
	if(![pb canReadObjectForClasses: types options: options])
		return "";
	NSArray* contents = [pb readObjectsForClasses: types options: options];
	NSString* str = [contents objectAtIndex: 0];
	return [[str stringByReplacingOccurrencesOfString: @"\n" withString: @"|"] cStringUsingEncoding: NSUTF8StringEncoding];
}

void set_clipboard_img(sf::Image& img) {
	if(!img.getPixelsPtr()) return;
	sf::Vector2u sz = img.getSize();
	size_t data_sz = (sz.x * sz.y * 4);
	NSBitmapImageRep* bmp = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: nullptr
			pixelsWide: sz.x pixelsHigh: sz.y bitsPerSample: 8 samplesPerPixel: 4
			hasAlpha: true isPlanar: false colorSpaceName: NSCalibratedRGBColorSpace
			bytesPerRow: sz.x * 4 bitsPerPixel: 32
		];
	std::copy(img.getPixelsPtr(), img.getPixelsPtr() + data_sz, [bmp bitmapData]);
	NSImage * image = [[NSImage alloc] initWithSize: NSMakeSize(sz.x, sz.y)];
	[image addRepresentation: bmp];
	NSArray* contents = [NSArray arrayWithObject: image];
	NSPasteboard* pb = [NSPasteboard generalPasteboard];
	[pb clearContents];
	[pb writeObjects: contents];
}

static sf::Image* sfImageFromNSImage(NSImage* inImage);

std::unique_ptr<sf::Image> get_clipboard_img() {
	std::unique_ptr<sf::Image> ret = nullptr;
	NSPasteboard* pb = [NSPasteboard generalPasteboard];
	if(![NSImage canInitWithPasteboard: pb])
		return ret; // a null pointer
	NSImage* img = [[NSImage alloc] initWithPasteboard: pb];
	ret.reset(sfImageFromNSImage(img));
	return ret;
}

void beep() {
	NSBeep();
}

void launchURL(std::string url) {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@(url.c_str())]];
}

int getMenubarHeight() {
	// Mac menubar isn't in the window, so we return 0 here.
	return 0;
}

extern sf::RenderWindow mainPtr;

void init_fileio(){
	//Do nothing
}

fs::path nav_get_scenario() {
	NSOpenPanel *dlg_get_scen = [NSOpenPanel openPanel];
	[dlg_get_scen setAllowedFileTypes: @[@"exs", @"boes", NSFileTypeForHFSTypeCode('BETM'), @"com.spidweb.bladesofexile.scenario"]];
	[dlg_get_scen setMessage: @"Select a scenario to edit:"];
	[dlg_get_scen setTitle: @"Load Scenario"];
	dlg_get_scen.allowsMultipleSelection = NO;

	bool gotFile = [dlg_get_scen runModal] == NSFileHandlingPanelOKButton;
	makeFrontWindow(mainPtr);
	if(gotFile) {
		return fs::path([[dlg_get_scen URL] fileSystemRepresentation]);
	}
	return "";
}

fs::path nav_put_scenario(fs::path def) {
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setAllowedFileTypes: @[@"com.spidweb.bladesofexile.scenario"]];
	[savePanel setMessage: @"Select a location to save the scenario:"];
	[savePanel setTitle: @"Save Scenario"];
	
	if(!def.empty()) {
		[savePanel setNameFieldStringValue:@(def.filename().c_str())];
		const fs::path parPath = def.parent_path();
		const char *parPathCStr = parPath.c_str();
		NSString *parPathNSStr = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:parPathCStr length:strlen(parPathCStr)];
		[savePanel setDirectoryURL:[NSURL fileURLWithPath:parPathNSStr]];
	}
	bool gotFile = [savePanel runModal] == NSFileHandlingPanelOKButton;
	makeFrontWindow(mainPtr);
	if(gotFile)
		return fs::path([[[savePanel URL] absoluteURL] fileSystemRepresentation]);
	return "";
}

fs::path nav_get_party() {
	NSOpenPanel *dlg_get_game = [NSOpenPanel openPanel];
	[dlg_get_game setAllowedFileTypes: @[@"exg", @"boe", @"SAV", @"mac", NSFileTypeForHFSTypeCode('beSV'), @"com.spidweb.bladesofexile.savegame", @"com.spidweb.bladesofexile.oldwinsave", @"com.spidweb.bladesofexile.oldmacsave"]];
	[dlg_get_game setMessage: @"Select a saved game to resume:"];
	[dlg_get_game setTitle: @"Load Game"];
	dlg_get_game.allowsMultipleSelection = NO;
	
	bool gotFile = [dlg_get_game runModal] == NSFileHandlingPanelOKButton;
	makeFrontWindow(mainPtr);
	if(gotFile)
		return fs::path([[dlg_get_game URL] fileSystemRepresentation]);
	return "";
}

fs::path nav_put_party(fs::path def) {
	NSSavePanel *dlg_put_game = [NSSavePanel savePanel];
	[dlg_put_game setAllowedFileTypes: @[@"com.spidweb.bladesofexile.savegame"]];
	[dlg_put_game setMessage: @"Select a location to save your game:"];
	[dlg_put_game setTitle: @"Save Game"];
	
	if(!def.empty()) {
		[dlg_put_game setNameFieldStringValue:@(def.filename().c_str())];
		const fs::path parPath = def.parent_path();
		const char *parPathCStr = parPath.c_str();
		NSString *parPathNSStr = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:parPathCStr length:strlen(parPathCStr)];
		[dlg_put_game setDirectoryURL:[NSURL fileURLWithPath:parPathNSStr]];
	}
	bool gotFile = [dlg_put_game runModal] == NSFileHandlingPanelOKButton;
	makeFrontWindow(mainPtr);
	if(gotFile)
		return fs::path([[dlg_put_game URL] fileSystemRepresentation]);
	return "";
}

fs::path nav_get_rsrc(std::initializer_list<std::string> extensions) {
	NSOpenPanel *dlg_get_rsrc = [NSOpenPanel openPanel];
	[dlg_get_rsrc setMessage: @"Select a resource to import:"];
	[dlg_get_rsrc setTitle: @"Import Resource"];
	dlg_get_rsrc.allowsMultipleSelection = NO;

	NSMutableArray* allowTypes = [[NSMutableArray alloc] initWithCapacity: extensions.size()];
	for(std::string ext : extensions) {
		NSString* the_ext = @(ext.c_str());
		[allowTypes addObject: the_ext];
	}
	[dlg_get_rsrc setAllowedFileTypes: allowTypes];
	bool gotFile = [dlg_get_rsrc runModal] == NSFileHandlingPanelOKButton;
	if(gotFile)
		return fs::path([[dlg_get_rsrc URL] fileSystemRepresentation]);
	return "";
}

fs::path nav_put_rsrc(std::initializer_list<std::string> extensions, fs::path def) {
	NSSavePanel *dlg_put_rsrc = [NSSavePanel savePanel];
	[dlg_put_rsrc setMessage: @"Select a location to export the resource:"];
	[dlg_put_rsrc setTitle: @"Export Resource"];
	
	if(!def.empty()) {
		[dlg_put_rsrc setNameFieldStringValue:@(def.filename().c_str())];
		const fs::path parPath = def.parent_path();
		const char *parPathCStr = parPath.c_str();
		NSString *parPathNSStr = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:parPathCStr length:strlen(parPathCStr)];
		[dlg_put_rsrc setDirectoryURL:[NSURL fileURLWithPath:parPathNSStr]];
	}
	NSMutableArray* allowTypes = [[NSMutableArray alloc] initWithCapacity: extensions.size()];
	for(std::string ext : extensions) {
		NSString* the_ext = @(ext.c_str());
		[allowTypes addObject: the_ext];
	}
	[dlg_put_rsrc setAllowedFileTypes: allowTypes];
	bool gotFile = [dlg_put_rsrc runModal] == NSFileHandlingPanelOKButton;
	if(gotFile)
		return fs::path([[dlg_put_rsrc URL] fileSystemRepresentation]);
	return "";
}

// Utility function for converting an NSImage into the RGBA format that SFML uses
// Adapted from <https://mikeash.com/pyblog/friday-qa-2012-08-31-obtaining-and-interpreting-image-data.html>
sf::Image* sfImageFromNSImage(NSImage *image) {
	int width = [image size].width;
	int height = [image size].height;
	
	if(width < 1 || height < 1)
		return nil;
	
	NSBitmapImageRep* rep = [[NSBitmapImageRep alloc]
							initWithBitmapDataPlanes: nil
							pixelsWide: width
							pixelsHigh: height
							bitsPerSample: 8
							samplesPerPixel: 4
							hasAlpha: YES
							isPlanar: NO
							colorSpaceName: NSCalibratedRGBColorSpace
							bytesPerRow: width * 4
							bitsPerPixel: 32];
	
	NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext: ctx];
	
	[image drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeCopy fraction: 1.0];
	
	[ctx flushGraphics];
	[NSGraphicsContext restoreGraphicsState];
	
	sf::Image* sfi = new sf::Image;
	sfi->create(width, height, (UInt8*) [rep bitmapData]);
	
	return sfi;
}
