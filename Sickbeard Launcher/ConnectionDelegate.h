//
//  ConnectionDelegate.h
//  iCouldUse
//
//  Created by ka010 on 07.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConnectionDelegate : NSObject {

	id target;
	SEL action;
	NSMutableData *_data;
}

- (id) initWithTarget:(id)aTarget perform:(SEL)anAction;


@property (retain)id target;
@property (assign)SEL action;
@property (retain)NSMutableData *_data;
@end
