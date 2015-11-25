//
//  GlobalVars.h
//  MacPatch-OC
//
//  Created by chris conley on 11/25/15.
//  Copyright © 2015 TT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVars : NSObject

//***************************************
//Constants
//***************************************
@property (nonatomic, strong) NSString * discPrefix;
@property (nonatomic, strong) NSString * bashPath;
@property (nonatomic, strong) NSString * dataPath;
@property (nonatomic, strong) NSArray * mLevel;
- (id) initDiscPrefix: (NSString *) discPrefix;
- (NSString *) discPrefix;
//["Math3-1", "Math4-1", "Math5-1", "Math6-1", "Math7-1", "PreAlg-1", "Alg1-1", "Alg2-1", "Geom-1"]
//***************************************

//- (id) initWithAge: (int)age andName:(NSString *)name;

//-(NSString *) printName;

@end
