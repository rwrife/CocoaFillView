//
//  MainViewController.m
//  TileFillGrid
//
//  Created by Ryan Rife on 2/26/13.
//  Copyright (c) 2013 Jewelry Television. All rights reserved.
//

#import "MainViewController.h"
#import "SiblingRect.h"

@interface MainViewController ()
{
    NSArray *imageArray;
    int left;
    NSMutableArray *whiteSpace;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        imageArray = [[NSArray alloc] initWithObjects:@"http://weknowmemes.com/wp-content/uploads/2012/07/queen-thinking-meme.jpeg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/yo-london-imma-let-you-finish1.jpg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/olympic-first-world-problems1.jpeg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/why-the-fuck-olympics.jpeg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/pissed-off-walter-olympics.jpeg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/go-to-the-olympics-they-said2.jpg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/if-you-put-john-nobles-face-on-the-quee.jpg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/and-may-the-odds-be-ever-in-your-favor1.jpg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/mom-brought-nutella1.jpg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/finally-chosen-for-the-tri-world-cup1.jpg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/what-the-us-uniforms-should-have-been1.jpeg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/bender-olympics.jpeg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/now-youre-just-a-country-that-i-used-to-own1.jpeg",
                      @"http://weknowmemes.com/wp-content/uploads/2012/07/olympics-meme1.jpeg", nil];
        
        [self performSelectorInBackground:@selector(parseImageArray:) withObject:imageArray];
        
        SiblingRect *rect = [[SiblingRect alloc] init];
        rect.rect = self.view.bounds;
      
        whiteSpace = [[NSMutableArray alloc] initWithObjects:rect, nil];
    }
    
    return self;
}


-(void) parseImageArray:(NSArray*) imgArray {
    
    for(int i=0;i<30;i++)
    {
    for(NSString *url in imgArray) {
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        if(image == nil)
            NSLog(@"Image url is dead.");
        NSInteger randomWidth = arc4random() % 200 + 20;
        
        [self performSelectorOnMainThread:@selector(addImageToScreen:) withObject:[self imageResize:image newSize:NSSizeFromCGSize(CGSizeMake(randomWidth, randomWidth * (image.size.height / image.size.width)))] waitUntilDone:TRUE];
    }
    }
}

- (NSImage *)imageResize:(NSImage*)anImage
                 newSize:(NSSize)newSize
{
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid])
    {
        NSLog(@"Invalid Image");
    } else
    {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

-(void) addImageToScreen:(NSImage*) img {
    
    //find smallest whitespace to fit
    SiblingRect *smallest;

    int area = 0;
    for(SiblingRect *v in whiteSpace) {
        NSRect rect = v.rect;
        int size = rect.size.width * rect.size.height;
        NSInteger randomNumber = arc4random() % 2;
        if(rect.size.width >= img.size.width && rect.size.height >= img.size.height && (area == 0 || (area < size && randomNumber == 0) || (area > size && randomNumber == 1))) {
            smallest = v;
            area = size;
        }
    }
    
    if(!NSIsEmptyRect(smallest.rect)) {
        NSRect rect = smallest.rect;
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(rect.origin.x,rect.origin.y, img.size.width, img.size.height))];
        left += img.size.width;
        imageView.image = img;
        [self.view addSubview:imageView];
        [self.view setNeedsDisplay:FALSE];
    }
    
    
    [whiteSpace removeObject:smallest];
    
    NSRect rect = smallest.rect;
    
    if(smallest.sibling != nil) {
        
        if(!smallest.sibling.isright) {
            CGRect resize = NSRectToCGRect(smallest.sibling.rect);
            resize.size.width = smallest.rect.origin.x - resize.origin.x;
            smallest.sibling.rect =  NSRectFromCGRect(resize);
        } else {
            CGRect resize = NSRectToCGRect(smallest.sibling.rect);
            resize.size.height = smallest.rect.origin.y - resize.origin.y;
            smallest.sibling.rect =  NSRectFromCGRect(resize);
        }
    }
    
    SiblingRect *righty = [[SiblingRect alloc] init];
    if(img.size.width < rect.size.width) {
        NSRect rightRect = NSRectFromCGRect(CGRectMake(rect.origin.x + img.size.width, rect.origin.y, rect.size.width - img.size.width, rect.size.height));
        righty.rect = rightRect;
        righty.isright = true;
        [whiteSpace addObject:righty];
    }
    
    if(img.size.height < rect.size.height) {
        NSRect bottomRect = NSRectFromCGRect(CGRectMake(rect.origin.x, rect.origin.y + img.size.height, rect.size.width, rect.size.height - img.size.height));
        SiblingRect *rect = [[SiblingRect alloc] init];
        rect.isright = false;
        rect.rect = bottomRect;
        rect.sibling = righty;
        righty.sibling = rect;
        [whiteSpace addObject:rect];
    } else {
        
        if(smallest.sibling.rect.origin.x + smallest.sibling.rect.size.width > righty.rect.origin.x || smallest.sibling.rect.origin.y + smallest.sibling.rect.size.height < righty.rect.origin.y)
        {
            righty.sibling = smallest.sibling;
            smallest.sibling.sibling = righty;
        } else {
            righty.sibling = nil;
            smallest.sibling.sibling = nil;
        }
        
    }
    
    
    
    smallest = nil;
        
    
}


@end
