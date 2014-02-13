//
//  AppDelegate.h
//  Almost All TopTrends
//
//  Created by Rhett Rogers on 12/9/13.
//  Copyright (c) 2013 Rhett Rogers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "STTwitter/STTwitterAPI.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource> {
  NSString *_currentAction;
  BOOL _timedOut;
  
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *table;
@property (strong) NSArray *topTrends;
@property (weak) IBOutlet NSTableHeaderView *headers;
@property (strong) STTwitterAPI *twitter;
@property (strong) NSTimer *myTimer;
@property (strong) NSTimer *timeout;
- (IBAction)refreshTrends:(id)sender;
@property (weak) IBOutlet NSTextField *error;


@end
