//
//  IpPortValidatorTest.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 30.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "IpPortValidator.h"

@interface IpPortValidatorTest : SenTestCase

@end

@implementation IpPortValidatorTest

static NSString * const NOT_A_NUMBER = @"12c";
static NSString * const PORT_ZERO = @"0";
static NSString * const PORT_8888 = @"8888";

IpPortValidator *cut;

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    cut = [IpPortValidator alloc];
}

- (void)testShouldReturnFalseWhenValidatingNotANumber {
    STAssertFalse([cut isValid:NOT_A_NUMBER], @"%@ is invalid", NOT_A_NUMBER);
}

- (void)testShouldReturnFalseWhenNumberIsZero {
    STAssertFalse([cut isValid:PORT_ZERO], @"%@ is invalid", PORT_ZERO);
}

- (void)testShouldReturnTrueWhenIsValid {
    STAssertTrue([cut isValid:PORT_8888], @"%@ is valid", PORT_8888);
}



@end
