//
//  IpAddressValidatorTest.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 28.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "IpAddressValidator.h"

#import <SenTestingKit/SenTestingKit.h>

@interface IpAddressValidatorTest : SenTestCase

@end


@implementation IpAddressValidatorTest

static NSString * const IP_WITH_LETTER = @"aaa.bbb.ccc.ddd";
static NSString * const IP_IS_EMPTY = @"";
static NSString * const IP_VALID_LONG = @"111.111.111.111";
static NSString * const IP_VALID_SHORT = @"1.0.0.1";

IpAddressValidator *cut;

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    cut = [IpAddressValidator alloc];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testShouldReturnFalseWhenValidatingIpContainsLetter {
    BOOL result = [cut isValid:IP_WITH_LETTER];
    STAssertFalse(result, @"IP with letter is invalid");
}

- (void)testShouldReturnFalseWhenIpIsEmpty {
    BOOL result = [cut isValid:IP_IS_EMPTY];
    STAssertFalse(result, @"Empty IP is invalid");
}

- (void)testShouldReturnTrueWhenLongIp {
    BOOL result = [cut isValid:IP_VALID_LONG];
    STAssertTrue(result, @"%@ is a valid IP", IP_VALID_LONG);
}

- (void)testShouldReturnTrueWhenShortIp {
    BOOL result = [cut isValid:IP_VALID_SHORT];
    STAssertTrue(result, @"%@ is a valid IP", IP_VALID_SHORT);
}


@end
