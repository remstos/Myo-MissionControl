//
//  AppDelegate.h
//  MYOMissionControl
//
//  Created by Remi Santos on 1/28/13.
//  Copyright (c) 2013 Remi Santos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyoObjectiveC.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,MyoDelegate>{
    NSWindow *window;
    NSStatusItem * statusItem;
    BOOL isPaused;    
}
@property (weak) IBOutlet NSMenuItem *pauseButton;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (nonatomic, strong) Myo *myo;

@property (assign) IBOutlet NSWindow *window;
-(void) pressKey:(int)key down:(BOOL)pressDown;
-(void) scrollX:(NSInteger)x scrollY:(NSInteger)y;
- (IBAction)onQuitClick:(id)sender;
- (IBAction)onAboutClick:(id)sender;
- (IBAction)onPauseClick:(NSMenuItem*)sender;



@end
