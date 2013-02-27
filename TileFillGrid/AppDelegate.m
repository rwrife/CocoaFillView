//
//  AppDelegate.m
//  TileFillGrid
//
//  Created by Ryan Rife on 2/26/13.
//  Copyright (c) 2013 Jewelry Television. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    

    [self.window.contentView addSubview:self.mainViewController.view];
    self.mainViewController.view.frame = ((NSView*)self.window.contentView).bounds;
}

@end
