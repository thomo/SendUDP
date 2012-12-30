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
static NSString * const IP_WITH_BIG_NUMBER = @"1.256.0.1";
static NSString * const IP_TOO_SHORT = @"1.0.1";

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
    STAssertFalse([cut isValid:IP_WITH_LETTER], @"%@ with letter is invalid", IP_WITH_LETTER);
}

- (void)testShouldReturnFalseWhenIpIsEmpty {
    STAssertFalse([cut isValid:IP_IS_EMPTY], @"Empty IP is invalid");
}

- (void)testShouldReturnTrueWhenLongIp {
    STAssertTrue([cut isValid:IP_VALID_LONG], @"%@ is a valid IP", IP_VALID_LONG);
}

- (void)testShouldReturnTrueWhenShortIp {
    STAssertTrue([cut isValid:IP_VALID_SHORT], @"%@ is a valid IP", IP_VALID_SHORT);
    NSLog(@"done"); // workaround to deal with "XCode problem: testShouldReturnTrueWhenShortIp did not finish"
}

- (void)testShouldReturnFalseWhenIpContainsToFewNumbers {
    STAssertFalse([cut isValid:IP_TOO_SHORT], @"%@ is invalid", IP_TOO_SHORT);
}

- (void)testShouldReturnFalseWhenIpContainsToBigNumber {
    STAssertFalse([cut isValid:IP_WITH_BIG_NUMBER], @"%@ is invalid", IP_WITH_BIG_NUMBER);
}
@end
