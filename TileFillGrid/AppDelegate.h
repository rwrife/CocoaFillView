//
//  AppDelegate.h
//  TileFillGrid
//
//  Created by Ryan Rife on 2/26/13.
//  Copyright (c) 2013 Jewelry Television. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,strong) IBOutlet MainViewController *mainViewController;

@end
