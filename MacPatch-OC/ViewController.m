//
//  ViewController.m
//  MacPatch-OC
//
//  Created by Teaching Textbooks on 11/25/15.
//  Copyright © 2015 TT. All rights reserved.
//

#import "ViewController.h"
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <strings.h>
#include <pwd.h>
#include <grp.h>
@implementation ViewController

//***************************************
//Define Constants
//***************************************
NSString *disc_prefix; //prefix to locate disc in drive
NSString *bashPath; //Scripts are ran using bash
NSString *dataPath; //Path to data folders
NSArray *mLevel; //array of expected math level disc 1 volumes
NSString *patchID = @"Math 4";//identifies the settings update
bool isAdmin = false; //Admin check bool
//***************************************

//***************************************
//Define Variables for paths
//***************************************
NSString *install_sh_path; //Path to shell script that unzips application files
NSString *plugin_path; //Path to flash player plugin resource
NSString *player_path; //Path something to mdm_flash_player
NSString *admin_name; //If admin, holds admin user name
//***************************************

//***************************************
//Define Variables for math level
//***************************************
NSString *mLevel_name;
NSString *mLevel_alias;
NSString *mLevel_disc;
NSString *mLevel_app_folder;
NSString *mLevel_app;
NSString *mLevel_data_folder;
NSString *mLevel_dat_file;
NSString *mLevel_zip_file;
BOOL foundDisc = false;
//***************************************


//***************************************
//VIEW DID LOAD
//***************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    //***************************************
    //Fill Constants
    //***************************************
    disc_prefix = @"/Volumes/"; //prefix to locate disc in drive
    bashPath = @"/bin/bash"; //Scripts are ran using bash
    dataPath = @"/Users/Shared/"; //Path to data folders
    mLevel = @[@"Math3-1", @"Math4-1", @"Math5-1", @"Math6-1", @"Math7-1", @"PreAlg-1", @"Alg1-1", @"Alg2-1", @"Geom-1"];
    //***************************************
    
    //***************************************
    //Define Variables for paths
    //***************************************
    install_sh_path = [[NSBundle mainBundle] pathForResource:@"cmd2" ofType:@"sh"]; //Path to shell script that unzips application files
    plugin_path = [[NSBundle mainBundle] pathForResource:@"Flash Player" ofType:@"plugin"]; //Path to flash player plugin resource
    player_path = [[NSBundle mainBundle] pathForResource:@"mdm_flash_player" ofType:@""]; //Path something to mdm_flash_player
    //***************************************
    
    //***************************************
    //Admin Check
    //***************************************
    uid_t current_user_id = getuid(); //Gets the user ID
    struct passwd *pwentry = getpwuid(current_user_id); //Gets PWD of user
    struct group *admin_group = getgrnam("admin"); //Sets group to check for
    while(*admin_group->gr_mem != NULL) { //Loop through groups until end
        if (strcmp(pwentry->pw_name, *admin_group->gr_mem) == 0) {
            isAdmin = true; //if admin is listed, set boolean to true
            admin_name = [NSString stringWithFormat:@"%s", pwentry->pw_name];
        }//end if
        admin_group->gr_mem++;
    }//end while
    
    //Checks isAdmin to validate admin group
    if (isAdmin) {
        loadMathData();
        _MathLevelLabel.stringValue = mLevel_name;
        if ([mLevel_name isEqualToString:patchID]) {
            _SettingsUpdateBtn.enabled = true;
            _settingsUpdateLabel.stringValue = @"Settings update patch is available for this math level!";
        } else {
            _SettingsUpdateBtn.enabled = false;
            _settingsUpdateLabel.stringValue = @"Settings update is not available for this math level. Please download the correct patch from our website http://www.teachingtextbooks.com/updates";
        }
        
    } else {
        showSimpleCriticalAlert(@"Admin Check", @"This can only be run from an administrator account!", true);//admin not logged in
    }//end if
    //***************************************
    
    
}//end view did load
//***************************************


//***************************************
//FUNCTION: Calls the loading of Math data
//and checks if disc can be found
//RETURNS: BOOLEAN
//TRUE = Disc found | Data loaded
//FALSE = NO disc found | No data loaded
//***************************************
BOOL checkMathDisc(){
    BOOL reslut = false;
    
    loadMathData();
    if (foundDisc) {
        reslut = true;
    } else {
        reslut = false;
    }
    
    return reslut;
}
//***************************************

//***************************************
//FUNCTION: Load math level data
void loadMathData() {
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *keys;
    keys = @[NSURLVolumeNameKey, NSURLVolumeIsRemovableKey, NSURLVolumeIsEjectableKey];
    NSArray *paths;
    paths = [filemanager mountedVolumeURLsIncludingResourceValuesForKeys:keys options:0];

    for (NSURL *item in paths) {
        NSArray *components = item.pathComponents ;
        if (components.count > 1 && [components[1]  isEqualToString: @"Volumes"]) {
                for (NSString *index in mLevel ){
                    NSString *discPath = [NSString stringWithFormat:@"%@%@",disc_prefix,index];
                    if ([item.path isEqualToString: discPath]) {
                        if ([index isEqualToString:@"Math3-1"]){
                            mLevel_name = @"Math 3";
                            mLevel_alias = @"Math3";
                            mLevel_disc = @"Math3-1";
                            mLevel_app_folder = @"Math 3";
                            mLevel_app = @"Math3.app";
                            mLevel_data_folder = @"TT Math 3";
                            mLevel_dat_file = @"math3dat";
                            mLevel_zip_file = @"ttmath3mac.zip";
                            foundDisc = true;
                        } else if([index isEqualToString:@"Math4-1"]){
                            mLevel_name = @"Math 4";
                            mLevel_alias = @"Math4";
                            mLevel_disc = @"Math4-1";
                            mLevel_app_folder = @"Math 4";
                            mLevel_app = @"Math4.app";
                            mLevel_data_folder = @"TT Math 4";
                            mLevel_dat_file = @"math4dat";
                            mLevel_zip_file = @"ttmath4mac.zip";
                            foundDisc = true;
                        } else if([index isEqualToString:@"Math5-1"]){
                            mLevel_name = @"Math 5";
                            mLevel_alias = @"Math5";
                            mLevel_disc = @"Math5-1";
                            mLevel_app_folder = @"Math 5";
                            mLevel_app = @"Math5.app";
                            mLevel_data_folder = @"TT Math 5";
                            mLevel_dat_file = @"math5dat";
                            mLevel_zip_file = @"ttmath5mac.zip";
                            foundDisc = true;
                        }else if([index isEqualToString:@"Math6-1"]){
                            mLevel_name = @"Math 6";
                            mLevel_alias = @"Math6";
                            mLevel_disc = @"Math6-1";
                            mLevel_app_folder = @"Math 6";
                            mLevel_app = @"Math6.app";
                            mLevel_data_folder = @"TT Math 6";
                            mLevel_dat_file = @"math6dat";
                            mLevel_zip_file = @"ttmath6mac.zip";
                                foundDisc = true;
                        }else if([index isEqualToString:@"Math7-1"]){
                            mLevel_name = @"Math 7";
                            mLevel_alias = @"Math7";
                            mLevel_disc = @"Math7-1";
                            mLevel_app_folder = @"Math 7";
                            mLevel_app = @"Math7.app";
                            mLevel_data_folder = @"TT Math 7";
                            mLevel_dat_file = @"math7dat";
                            mLevel_zip_file = @"ttmath7mac.zip";
                                foundDisc = true;
                        } else if([index isEqualToString:@"Pre-Alg"]){
                            mLevel_name = @"Pre-Algebra";
                            mLevel_alias = @"Pre-Algebra";
                            mLevel_disc = @"PreAlg-1";
                            mLevel_app_folder = @"Pre-Algebra";
                            mLevel_app = @"Pre-Algebra.app";
                            mLevel_data_folder = @"TT Pre-Algebra";
                            mLevel_dat_file = @"prealgebradat";
                            mLevel_zip_file = @"ttprealgebramac.zip";
                        }else if([index isEqualToString:@"Alg1-1"]){
                            mLevel_name = @"Algebra 1";
                            mLevel_alias = @"Algebra1";
                            mLevel_disc = @"Algebra1-1";
                            mLevel_app_folder = @"Algebra 1";
                            mLevel_app = @"Algebra1.app";
                            mLevel_data_folder = @"TT Algebra 1";
                            mLevel_dat_file = @"algebra1dat";
                            mLevel_zip_file = @"ttalgebra1mac.zip";
                                foundDisc = true;
                                break;
                        }else if([index isEqualToString:@"Alg2-1"]){
                            mLevel_name = @"Algebra 2";
                            mLevel_alias = @"Algebra2";
                            mLevel_disc = @"Algebra2-1";
                            mLevel_app_folder = @"Algebra 2";
                            mLevel_app = @"Algebra2.app";
                            mLevel_data_folder = @"TT Algebra 2";
                            mLevel_dat_file = @"algebra2dat";
                            mLevel_zip_file = @"ttalgebra2mac.zip";
                        }else if ([index isEqualToString:@"Geom-1"]){
                            mLevel_name = @"Geometry";
                            mLevel_alias = @"Geometry";
                            mLevel_disc = @"Geom-1";
                            mLevel_app_folder = @"Geometry";
                            mLevel_app = @"Geometry.app";
                            mLevel_data_folder = @"TT Geometry";
                            mLevel_dat_file = @"geometrydat";
                            mLevel_zip_file = @"ttgeometrymac.zip";
                                foundDisc = true;
                        }//end if
                    }//end if
                }//end for
            }//end if
    }//end for
}//end math level data function
//***************************************


//***************************************
//BUTTON
//***************************************
- (IBAction)testBtn:(NSButton *)sender {
    cleanInstall();
    installFromDisc1();
}//end testBtn
//***************************************


//***************************************
//BUTTON
//***************************************
- (IBAction)recheckBtn:(NSButton *)sender {
    loadMathData();
    _MathLevelLabel.stringValue = mLevel_name;
    if ([mLevel_name isEqualToString:patchID]) {
        _SettingsUpdateBtn.enabled = true;
        _settingsUpdateLabel.stringValue = @"Settings update patch is available for this math level!";
    } else {
        _SettingsUpdateBtn.enabled = false;
        _settingsUpdateLabel.stringValue = @"Settings update is not available for this math level. Please download the correct patch from our website http://www.teachingtextbooks.com/updates";
    }
}
//***************************************


//***************************************
//BUTTON
//***************************************
- (IBAction)SettingsUpdateBtn:(NSButton *)sender {
    
}
//***************************************


//***************************************
//FUNCTION: Display alert message
//***************************************
void showSimpleCriticalAlert(NSString *title, NSString *msg,bool exitApp) {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:title];
    [alert setInformativeText:msg];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert runModal];
    if (exitApp) {
        [[NSApplication sharedApplication] terminate:nil];
    }//end if
}//end showsimplecirticalalert
//***************************************


//****************************************
//FUNCTION: Cleans all applications and folders
//associated with previous istalls that may
//be corrupt or misplaced
//****************************************
//function looks in four common locations where icons are placed and removes them from the computer in preparation for the install
void cleanInstall(){
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *mathTargets = @[mLevel_app, mLevel_app_folder, mLevel_name, mLevel_alias];
    NSString *pathToUser = [NSString stringWithFormat:@"%@%@", @"/Users/", admin_name];
    NSString *pathToDownloads = [NSString stringWithFormat:@"%@%@", pathToUser, @"/Downloads/"];
    NSString *pathToDesktop = [NSString stringWithFormat:@"%@%@", pathToUser, @"/Desktop/"];
    NSArray *pathArray = @[pathToDownloads, pathToDesktop, @"/Applications/",@"/Applications/Teaching Textbooks/"];
    for (NSString *path in pathArray) {
        NSArray *path_data = [filemanager contentsOfDirectoryAtPath:path error:nil];
        if (path_data != nil) {
            for (NSString *files in path_data){
                for (NSString *mathTarget in mathTargets) {
                    if ([mathTarget isEqualToString:files]) {
                        NSString *appPath = [NSString stringWithFormat:@"%@%@",path,mathTarget];
                        //NSString *aliasPath = [NSString stringWithFormat:@"%@%@",path,alias];
                        [filemanager removeItemAtPath:appPath error:nil];
                      //  [filemanager removeItemAtPath:aliasPath error:nil];
                    }//end if
                }//end for
            }//end for
        }//end if
    }//end for
}//end cleanInstall
//****************************************


//****************************************
//FUNCTION: Automates the install process
//using disc 1 resources (TODO: Find ways to possible download missing, dammaged, or updated files
//****************************************
//manually installs the mac.zip file from the cd
void installFromDisc1() {
    NSTask *installTask = [[NSTask alloc] init];
    NSString *discZipFile = [NSString stringWithFormat:@"%@%@%@%@",@"/Volumes/",mLevel_disc, @"/", mLevel_zip_file];
   
    [installTask setLaunchPath: @"/bin/bash"];
    [installTask setArguments: @[install_sh_path, discZipFile, mLevel_app_folder, mLevel_app, mLevel_alias]];
    [installTask launch];
    [installTask waitUntilExit];
}//end installFromDisc1
//****************************************
@end
