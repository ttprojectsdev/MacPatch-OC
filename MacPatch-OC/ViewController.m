//
//  ViewController.m
//  MacPatch-OC
//
//  Created by Teaching Textbooks on 11/25/15.
//  Copyright © 2015 TT. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)testBtn:(NSButton *)sender {
    Person *william = [[Person alloc] initWithAge:18 andName:@"William2"];
    _msgLbl.stringValue = [william printName];

}

@end
