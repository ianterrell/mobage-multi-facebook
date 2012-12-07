//
//  ViewController.h
//  MultiFacebook
//
//  Created by Ian  Terrell on 12/7/12.
//  Copyright (c) 2012 Ian Terrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface ViewController : UIViewController <FBDialogDelegate>

-(void)setAccessTokenFromURL:(NSURL*)url;

@end
