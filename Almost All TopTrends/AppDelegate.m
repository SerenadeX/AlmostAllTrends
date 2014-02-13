//
//  AppDelegate.m
//  Almost All TopTrends
//
//  Created by Rhett Rogers on 12/9/13.
//  Copyright (c) 2013 Rhett Rogers. All rights reserved.
//

#import "AppDelegate.h"
#import "STTwitter/STTwitterAPI.h"

@implementation AppDelegate

// USA: 	23424977
// Paris: 615702
// Utah:  12590285
// 84604: 12794268

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [self.table setHeaderView:nil];
  [self.table setDataSource:self];
  NSString *key = @"HSnVLZS3UAFpPGjARLNJUQ";
  NSString *secret = @"YhTD8Fbubjgah6xIeqBzxw2mEp6Xeru8fzGMpNFSr7c";


  self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:key consumerSecret:secret];

  _timedOut = NO;
  [self refresh];
  [self startRefreshTimer];
  
  
  


}


-(void)refresh {
  [self.twitter getTrendsForWOEID:@"23424977" excludeHashtags:0 successBlock:^(NSDate *asOf, NSDate *createdAt, NSArray *locations, NSArray *trends){
    NSMutableArray *reloadTrends = [[NSMutableArray alloc] init];
    
    
    for ( id trend in trends) {
      NSString *name = [NSString stringWithFormat:@"%@", [trend objectForKey:@"name"]];
      [reloadTrends addObject:name];
    }
    _topTrends = reloadTrends;
    [self.table reloadData];
  } errorBlock:^(NSError *error) {
    NSLog([error localizedDescription], @"%@");
    [self.error setStringValue:[error localizedDescription]];
    [self stopRefreshTimer];
    [self startTimeout];
  }];
}


- (long)numberOfRowsInTableView:(NSTableView *)tableView
{
  return (int)[self.topTrends count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(long)row
{
  return [self.topTrends objectAtIndex:(long)row];
}

- (IBAction)refreshTrends:(id)sender {
  if (_timedOut) {
    return;
  }
  [self refresh];
  
}

- (void) startRefreshTimer {
  self.myTimer = [NSTimer scheduledTimerWithTimeInterval:600
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) stopRefreshTimer {
  [self.myTimer invalidate];
}

- (void) startTimeout {
  _timedOut = YES;
  self.timeout = [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(timeoutFinished:) userInfo:nil repeats:YES];
}

- (void) stopTimeout {
  _timedOut = NO;
  [self.timeout invalidate];
}


- (void) timerFired:(NSTimer*)theTimer
{
  [self refresh];
}

- (void) timeoutFinished:(NSTimer*)theTimer {
  [self refresh];
  [self startRefreshTimer];
  
}



@end
