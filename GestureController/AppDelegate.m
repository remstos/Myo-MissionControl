//
//  AppDelegate.m
//  MYOMissionControl
//
//  Created by Remi Santos on 1/28/13.
//  Copyright (c) 2013 Remi Santos. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.myo = [[Myo alloc] initWithApplicationIdentifier:@"com.example.myoMissonControl"];
    
    BOOL found = false;
    while (!found) {
        found = [self.myo connectMyoWaiting:10000];
    }
    self.myo.delegate = self;
    self.myo.updateTime = 1000;
    isPaused = false;
    [self.myo startUpdate];
}

-(void)awakeFromNib{

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:[self statusMenu]];
    //[statusItem setTitle:@"Test"];
    NSBundle *bundle = [NSBundle mainBundle];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"status_icon" ofType:@"png"]];
    [img setSize:NSMakeSize(20, 20)];
    [statusItem setImage:img];
    [statusItem setHighlightMode:YES];
    [window close];
    
}

-(void) scrollX:(NSInteger)x scrollY:(NSInteger)y{
    CGWheelCount wheelCount = 2; // 1 for Y-only, 2 for Y-X, 3 for Y-X-Z
    int32_t xScroll = x; // Negative for right
    int32_t yScroll = y; // Negative for down
    //NSLog(@"Scroll X: %ld, Y: %ld", (long)x, (long)y);
    CGEventRef cgEvent = CGEventCreateScrollWheelEvent(NULL, kCGScrollEventUnitPixel, wheelCount, yScroll, xScroll);
    
    // You can post the CGEvent to the event stream to have it automatically sent to the window under the cursor
    CGEventPost(kCGHIDEventTap, cgEvent);
    
//    NSEvent *theEvent = [NSEvent eventWithCGEvent:cgEvent];
    CFRelease(cgEvent);
}

-(void) pressKey:(int)key down:(BOOL)pressDown{
    CGEventRef downEvent = CGEventCreateKeyboardEvent(NULL, key, pressDown);
    
    CGEventPost(kCGHIDEventTap, downEvent);
    
    CFRelease(downEvent);
}

- (IBAction)onQuitClick:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction)onAboutClick:(id)sender {
}

- (IBAction)onPauseClick:(NSMenuItem*)sender {
    [self togglePlayPauseMyo];
}
-(void)togglePlayPauseMyo {
    if (isPaused) {
//        [self.myo startUpdate];
        [self.pauseButton setTitle:@"Pause"];
    }
    else {
//        [self.myo stopUpdate];
        [self.pauseButton setTitle:@"Play"];
    }
    isPaused = !isPaused;
}
#pragma mark - MYO
-(void)myo:(Myo *)myo onPose:(MyoPose *)pose
{
    if (!isPaused) {
        if (pose.poseType == MyoPoseTypeWaveIn) {
            [self pressKey:kVK_Control down:true];
            [NSThread sleepForTimeInterval: 0.1]; // 100 mS delay
            [self pressKey:kVK_LeftArrow down:true];
            
            [NSThread sleepForTimeInterval: 0.1]; // 100 mS delay
            
            [self pressKey:kVK_Control down:false];
            [NSThread sleepForTimeInterval: 0.1]; // 100 mS delay
            [self pressKey:kVK_LeftArrow down:false];
            
            [myo vibrateWithType:MyoVibrationTypeShort];
        }
        else if (pose.poseType == MyoPoseTypeWaveOut) {
            [self pressKey:kVK_Control down:true];
            [NSThread sleepForTimeInterval: 0.1]; // 100 mS delay
            [self pressKey:kVK_RightArrow down:true];
            
            [NSThread sleepForTimeInterval: 0.1]; // 100 mS delay
            
            [self pressKey:kVK_Control down:false];
            [NSThread sleepForTimeInterval: 0.1]; // 100 mS delay
            [self pressKey:kVK_RightArrow down:false];
            [myo vibrateWithType:MyoVibrationTypeShort];
        }
        else if (pose.poseType == MyoPoseTypeFist) {
    //        [self togglePlayPauseMyo];
        }
        else if (pose.poseType == MyoPoseTypeFingersSpread) {
            [[NSWorkspace sharedWorkspace] launchApplication:@"Mission Control"];
            [myo vibrateWithType:MyoVibrationTypeShort];
        }
    }
}
@end

