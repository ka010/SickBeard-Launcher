//
//  Sickbeard_LauncherAppDelegate.h
//  Sickbeard Launcher
//
//  Created by Kai Aras on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Sickbeard_LauncherAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
