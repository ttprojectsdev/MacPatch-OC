//
//  Person.h
//  MacPatch-OC
//
//  Created by chris conley on 11/25/15.
//  Copyright © 2015 TT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (assign) int age;

@property (nonatomic, strong) NSString * name;

- (id) initWithAge: (int)age andName:(NSString *)name;

-(NSString *) printName;

-(int) getBirthYear;

+ (instancetype) personWithAge:(int)age andName:(NSString *)name;

+ (NSString *) speciesName;
@end
