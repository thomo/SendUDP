//
//  AppDelegate.h
//  SendUDP
//
//  Created by Thomas Mohaupt on 25.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) Configuration *configuration;

@end
