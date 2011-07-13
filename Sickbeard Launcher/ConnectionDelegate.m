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
		self._data = [[NSMutableData alloc]init];
	}
	return self;
}


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//	NSLog(@"ConnectionDidFailWithError: %@",error);
	[[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"serverUnavailableNotification" object:nil]];

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
	//	console.log("DidReceiveResponse: "+response )
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	//	 x = [CPData dataWithJSONObject: JSON.parse(data)];
	//	console.log(@"data: " + data)
	[self._data appendData:data];
	//	var _json = JSON.parse(data);
	//[target performSelector:action withObject:data];
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self.target performSelector:self.action withObject:self._data];
}


- (void) dealloc
{
	[self._data release];
	[super dealloc];
}


@end
