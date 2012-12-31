//
//  ConfigurationTest.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 30.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Configuration.h"

@interface ConfigurationTest : SenTestCase

@end

@implementation ConfigurationTest

static NSString * const DEFAULT_IP = @"2.0.2.2";
static NSString * const NEW_IP = @"1.0.0.1";
static NSString * const DEFAULT_PORT = @"11111";
static NSString * const NEW_PORT = @"11112";


Configuration *cut;
int changeCount;

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    cut = [Configuration alloc];
    [cut setIpAddress:DEFAULT_IP];
    [cut setPort:DEFAULT_PORT];

    changeCount = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configurationHasChanged:) name:ConfigurationHasChangedNotification object:nil];
}

- (void)tearDown
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super tearDown];
}

- (void)testShouldNotifyObserverWhenSetNewIp {
    [cut setIpAddress:NEW_IP];
    STAssertEquals(changeCount, 1, @"Configuration should notify about change.");
}

- (void)testShouldNotNotifyObserverWhenSetSameIp {
    [cut setIpAddress:DEFAULT_IP];
    STAssertEquals(changeCount, 0, @"Configuration should not notify about change.");
}

- (void)testShouldNotifyObserverWhenSetNewPort {
    [cut setPort:NEW_PORT];
    STAssertEquals(changeCount, 1, @"Configuration should notify about change.");
}

- (void)testShouldNotNotifyObserverWhenSetSamePort {
    [cut setPort:DEFAULT_PORT];
    STAssertEquals(changeCount, 0, @"Configuration should not notify about change.");
}

- (void)configurationHasChanged:(NSNotification*)notification {
    ++changeCount;
}

@end
