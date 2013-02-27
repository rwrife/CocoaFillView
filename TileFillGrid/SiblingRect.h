//
//  SiblingRects.h
//  TileFillGrid
//
//  Created by Ryan Rife on 2/27/13.
//  Copyright (c) 2013 Jewelry Television. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiblingRect : NSObject
@property (nonatomic) NSRect rect;
@property (nonatomic,strong) SiblingRect *sibling;
@property (nonatomic) BOOL isright;
@end
