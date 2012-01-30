//
//  ConnectionDelegate.m
//  iCouldUse
//
//  Created by ka010 on 07.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConnectionDelegate.h"


@implementation ConnectionDelegate
@synthesize target,action,_data;

- (id) initWithTarget:(id)aTarget perform:(SEL)anAction
{
	self = [super init];
	if (self != nil) {
		self.target = aTarget;
		self.action = anAction;
		
	}
	return self;
}


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"serverUnavailableNotification" object:nil]];

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    _data = [[NSMutableData alloc]init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self.target performSelector:self.action withObject:self._data];
    self._data = nil;
}


- (void) dealloc
{
    [target release];
	[_data release];
	[super dealloc];
}


@end
