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

    [cut addObserver:self forKeyPath:@"ipAddress" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    [cut addObserver:self forKeyPath:@"port" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

- (void)tearDown
{
    [cut removeObserver:self forKeyPath:@"port"];
    [cut removeObserver:self forKeyPath:@"ipAddress"];
    [super tearDown];
}

- (void)testShouldNotifyObserverWhenSetNewIp {
    [cut setIpAddress:NEW_IP];
    STAssertEquals(changeCount, 1, @"Configuration should notify about change.");
}

- (void)testShouldNotifyObserverWhenSetNewPort {
    [cut setPort:NEW_PORT];
    STAssertEquals(changeCount, 1, @"Configuration should notify about change.");
}

- (void)configurationHasChanged:(NSNotification*)notification {
    ++changeCount;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self configurationHasChanged:NULL];
}

@end
