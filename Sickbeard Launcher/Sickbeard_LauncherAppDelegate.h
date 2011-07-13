//
//  Sickbeard_LauncherAppDelegate.h
//  Sickbeard Launcher
//
//  Created by Kai Aras on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConnectionDelegate.h"
@interface Sickbeard_LauncherAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSStatusItem *statusItem;
	IBOutlet NSMenu *statusMenu;

    IBOutlet NSTextField *pathField;
    
    NSFileHandle *inFile;

    NSFileHandle *outFile;

}


-(IBAction)setSickbeardPath:(id)sender;

@property (retain) NSTask *serverTask;

@property (assign) IBOutlet NSWindow *window;

@end
