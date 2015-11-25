//
//  Person.m
//  MacPatch-OC
//
//  Created by chris conley on 11/25/15.
//  Copyright © 2015 TT. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id) initWithAge:(int)age andName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        self.age = age;
        self.name = name;
    }
    return self;
}

- (NSString *) printName
{
    return self.name;
}

- (int) getBirthYear
{
    int currentYear = 2015;
    int birthYear = currentYear - self.age;
    return birthYear;
}

+ (instancetype) personWithAge:(int)age andName:(NSString *)name
{
    Person *william = [[Person alloc] initWithAge:age andName:name];
    return william;
}

+ (NSString *) speciesName
{
    NSString *speciesName = @"Homo sapiens";
    return speciesName;
}
@end