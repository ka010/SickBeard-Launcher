//
//  Sickbeard_LauncherAppDelegate.m
//  Sickbeard Launcher
//
//  Created by Kai Aras on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sickbeard_LauncherAppDelegate.h"

@implementation Sickbeard_LauncherAppDelegate

@synthesize window;

@synthesize serverTask;






#pragma mark - IBActions

-(IBAction)setSickbeardPath:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setTitle:@"Select your SickBeard directory"];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setAllowsMultipleSelection:NO];
    NSString* fileName;
    if ( [openPanel runModalForDirectory:nil file:nil] == NSOKButton )
    {
        
        NSArray* files = [openPanel filenames];
              
        fileName = [files objectAtIndex:0];
         NSLog(@"filename: %@",fileName);
        
         [pathField setStringValue:fileName];
        
        [[NSUserDefaults standardUserDefaults]setObject:fileName forKey:@"sickbeardpath"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
   
    [self.window close];
    

}





#pragma mark - Sickbeard Process Wrapper 



-(void)startServer {
    NSString *path = [[[NSUserDefaults standardUserDefaults]stringForKey:@"sickbeardpath"]stringByAppendingPathComponent:@"SickBeard.py"];
    
    NSArray *args = [NSArray arrayWithObjects:path, nil];

    self.serverTask = [[NSTask alloc]init];
    [self.serverTask setLaunchPath:@"/usr/bin/python"];
    [self.serverTask setArguments:args];
    
    [self.serverTask launch];

    
   }


-(void)stopServer {
    if ([self.serverTask isRunning]) {
        [self.serverTask terminate];
        self.serverTask = nil;
        [statusItem setImage:[NSImage imageNamed:@"menuicon_bw"]];

    } 
}

-(void)restartServer {
    [self stopServer];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startServer) userInfo:nil repeats:NO];
}



-(void)checkServer {
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8081"]];
    ConnectionDelegate *_delegate = [[ConnectionDelegate alloc]initWithTarget:self perform:@selector(didGetServerResponse:)];
    [NSURLConnection connectionWithRequest:req delegate:_delegate];
}


-(void)didGetServerResponse:(NSData*)data {
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if ([msg length]>0) {
        NSLog(@"Server OK."); 
        [statusItem setImage:[NSImage imageNamed:@"menuicon"]];

    }
    
}

-(void)serverUnavailable:(NSNotification*)aNotification {
    
    if ([[NSUserDefaults standardUserDefaults]stringForKey:@"sickbeardpath"]==nil) {
        [self.window makeKeyAndOrderFront:self];
        return;
    }
    
    
    NSLog(@"server unavailable ! \n ");
    [statusItem setImage:[NSImage imageNamed:@"menuicon_bw"]];


}





#pragma mark - NSApp Delegate


-(void)awakeFromNib {
    NSString *path = [[NSUserDefaults standardUserDefaults]stringForKey:@"sickbeardpath"];
    if (path != nil) {
        [pathField setStringValue:path];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    

    
    // Insert code here to initialize your application
    statusItem = [[[NSStatusBar systemStatusBar]statusItemWithLength:NSVariableStatusItemLength]retain];
	[statusItem setMenu:statusMenu];
	[statusItem setHighlightMode:YES];
	[statusItem setImage:[NSImage imageNamed:@"menuicon_bw"]];
	[self updateSystemMenu];
    
    
    
    if ([[NSUserDefaults standardUserDefaults]stringForKey:@"sickbeardpath"]==nil) {
        [self.window makeKeyAndOrderFront:self];
        return;
    }
    
    [self startServer];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkServer) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(serverUnavailable:) name:@"serverUnavailableNotification" object:nil];
}


-(void)applicationWillTerminate:(NSNotification *)notification {
    [self stopServer];
}


-(void)updateSystemMenu {
	id element;
	
	for (NSMenuItem *i in [statusMenu itemArray]) {
		[statusMenu removeItem:i];
	}
	

    
    
	
	//*
	//* Updates
	//*
	// seperator
	//item =[NSMenuItem separatorItem];
	//[statusMenu addItem:item];
	
    NSMenuItem *item = [[NSMenuItem alloc]init];
    
    item = [[NSMenuItem alloc]init];
    [item setTitle:@"Open SickBeard"];
	[item setTag:4];
	[item setEnabled:YES];
	[item setAction:@selector(handleSystemMenuEvent:)];
	[statusMenu addItem:item];
	[item release];
    
    [statusMenu addItem:[NSMenuItem separatorItem]];

    	
    

    
    //*
	//* Preferences
	//*
	
     item = [[NSMenuItem alloc]init];
     [item setTitle:@"Preferences..."];
     [item setTag:1];
     [item setEnabled:YES];
     [item setAction:@selector(handleSystemMenuEvent:)];
     [statusMenu addItem:item];
     
    [statusMenu addItem:[NSMenuItem separatorItem]];
    

	
    item = [[NSMenuItem alloc]init];
    [item setTitle:@"Start "];
	[item setTag:5];
	[item setEnabled:YES];
	[item setAction:@selector(handleSystemMenuEvent:)];
	[statusMenu addItem:item];
	[item release];
    
    item = [[NSMenuItem alloc]init];
    [item setTitle:@"Stop "];
	[item setTag:6];
	[item setEnabled:YES];
	[item setAction:@selector(handleSystemMenuEvent:)];
	[statusMenu addItem:item];
	[item release];
    
    item = [[NSMenuItem alloc]init];
	[item setTitle:@"Restart "];
	[item setTag:2];
	[item setEnabled:YES];
	[item setAction:@selector(handleSystemMenuEvent:)];
	[statusMenu addItem:item];
    [item release];
    

	
	[statusMenu addItem:[NSMenuItem separatorItem]];
	
	
	item = [[NSMenuItem alloc]init];
	[item setTitle:@"Quit"];
	[item setTag:3];
	[item setEnabled:YES];
    [item setTarget:self];
	[item setAction:@selector(handleSystemMenuEvent:)];
	[statusMenu addItem:item];
	[item release];
	
	
	
}

-(void)handleSystemMenuEvent:(NSMenuItem *)item {
	switch ([item tag]) {
		
		case 1:
			[self.window makeKeyAndOrderFront:self];
			
			break;
		case 2:

			[self restartServer];
			break;
		case 3:
            [self stopServer];
			exit(0);
			break;
        
        case 4:
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://localhost:8081"]];
            break;
            
        case 5:
            [self startServer];
            break;
            
        case 6:
            [self stopServer];
            break;
		default:

			[self updateSystemMenu];
			break;
	}
	
}


- (void)dealloc {
    self.serverTask = nil;
    [super dealloc];
}


@end
