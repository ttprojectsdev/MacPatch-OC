//
//  ViewController.h
//  MacPatch-OC
//
//  Created by Teaching Textbooks on 11/25/15.
//  Copyright © 2015 TT. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *MathLevelLabel;

@property (weak) IBOutlet NSTextField *settingsUpdateLabel;

@property (weak) IBOutlet NSProgressIndicator *progressBar;

@property (weak) IBOutlet NSButton *SettingsUpdateBtn;

@end

