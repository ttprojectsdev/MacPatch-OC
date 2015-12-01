//
//  ViewController.h
//  MacPatch-OC
//
//  Created by Teaching Textbooks on 11/25/15.
//  Copyright © 2015 TT. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ViewController : NSViewController

@property (strong) IBOutlet NSTextField *MathLevelLabel;

@property (strong) IBOutlet NSTextField *settingsUpdateLabel;

@property (weak) IBOutlet NSProgressIndicator *progressBar;

@property (strong) IBOutlet NSButton *SettingsUpdateBtn;
- (id) init;
- (void)reloadData;
- (IBAction)recheckBtn: (id)sender;
- (IBAction)SettingsUpdateBtn: (id)sender;
- (IBAction)testBtn: (id)sender;

@end

