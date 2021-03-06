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
//@synthesize MathLevelLabel;
//***************************************
//Define Constants
//***************************************
NSString *disc_prefix; //prefix to locate disc in drive
NSString *bashPath; //Scripts are ran using bash
NSString *resource_path; //Path to resource folder
NSString *dataPath; //Path to data folders
NSString *admin_file_path; // Used the check if application is installed, and check version
NSArray *mLevel; //array of expected math level disc 1 volumes
NSString *patchID = @"Math 4";//identifies the settings update
bool isAdmin = false; //Admin check bool
bool isUpdateReady = false; //Set to true when disc is matched to patch
//***************************************

//***************************************
//Define Variables for paths
//***************************************
NSString *install_sh_path; //Path to shell script that unzips application files
NSString *settingsUpdateZip_path; //Path to settings update .zip
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
    resource_path = [[NSBundle mainBundle] resourcePath]; //Path to resource folder
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
    while(*admin_group->gr_mem != nil) { //Loop through groups until end
        if (strcmp(pwentry->pw_name, *admin_group->gr_mem) == 0) {
            isAdmin = true; //if admin is listed, set boolean to true
            admin_name = [NSString stringWithFormat:@"%s", pwentry->pw_name];
        }//end if
        admin_group->gr_mem++;
    }//end while
    
    //Checks isAdmin to validate admin group
    if (isAdmin) {
        [self reloadData];
    } else {
        showSimpleCriticalAlert(@"Admin Check", @"This can only be run from an administrator account! Please login to the administrator account and try again.", true);//admin not logged in
    }//end if
    //***************************************
    
    
}//end view did load
//***************************************

//***************************************
//BUTTON: Will do the auto patch
//***************************************
- (IBAction)testBtn:(id)sender {
    self.progressBar.doubleValue = 0;
    cleanInstall();
    self.progressBar.doubleValue = 20;
    installFromDisc1();
    self.progressBar.doubleValue = 40;
    processGradebook();
    self.progressBar.doubleValue = 55;
    fixFlash();
    self.progressBar.doubleValue = 70;
    if (isUpdateReady) {
        settingsUpdate();
        self.progressBar.doubleValue = 85;
    }
    fixPermissions();
    self.progressBar.doubleValue = 95;
    [self reloadData];
    self.progressBar.doubleValue = 100;
}//end testBtn
//***************************************

//***************************************
//BUTTON: Reloads the data for views
//***************************************
- (IBAction)recheckBtn:(id)sender {
    [self reloadData];
}
//***************************************

//***************************************
//BUTTON: Applies settings update
//***************************************
- (IBAction)SettingsUpdateBtn:(NSButton *)sender {
    settingsUpdate();
    fixPermissions();
    [self reloadData];
}
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
   
    [installTask setLaunchPath: bashPath];
    [installTask setArguments: @[install_sh_path, discZipFile, mLevel_app_folder, mLevel_app, mLevel_alias]];
    [installTask launch];
    [installTask waitUntilExit];
}//end installFromDisc1
//****************************************

//****************************************
//FUNCTION: Settings update
//****************************************
//manually installs the mac.zip file from the cd
void settingsUpdate() {
    if (isUpdateReady) {
        checkInstall();
        NSTask *installTask = [[NSTask alloc] init];
        [installTask setLaunchPath: bashPath];
        [installTask setArguments: @[install_sh_path, settingsUpdateZip_path, mLevel_app_folder, mLevel_app, mLevel_alias]];
        [installTask launch];
        [installTask waitUntilExit];
    }//end if
}//end installFromDisc1
//****************************************

//****************************************
//FUNCTION: Checks version of TT software.
//Will aid customers on when to use the settings menu update
//****************************************
bool checkVersion() {
    checkInstall();
    NSFileManager *filemanager = [NSFileManager defaultManager];//Initalize filemanager
    NSDate *file_created_Date = [[filemanager attributesOfItemAtPath:admin_file_path error:nil] fileCreationDate]; //gets file creation date
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:file_created_Date]; //Splits date up into components
    NSInteger year = [components year]; //stores year in integer
    if (year < 2014) {
        return false;
    } else {
        return true;
    }
}
//****************************************

//****************************************
//FUNCTION: Checks if math level is installed
//before installing settings update
//****************************************
void checkInstall() {
    NSFileManager *filemanager = [NSFileManager defaultManager];//Initalize filemanager
    if ([filemanager fileExistsAtPath:admin_file_path] == false) {
        installFromDisc1();
        showSimpleCriticalAlert(@"First time run", @"TT Mac Patch has noticed that your software is not currently installed. This has been taken care of you automatically!", false);
    }
}
//****************************************

//****************************************
//FUNCTION: Checks dat files and makes
//sure working ones are in place
//****************************************
void processGradebook(){
    NSString *dataFolderPath;
    NSString *gbFilePath;
    NSString *programDatPath;
    NSString *discDataFolderPath;
    NSString *discGbFilePath;
    NSString *discProgramDatPath;
    
    dataFolderPath = [NSString stringWithFormat:@"%@%@", dataPath, mLevel_data_folder];
    gbFilePath = [NSString stringWithFormat:@"%@%@%@", dataFolderPath, @"/", mLevel_dat_file];
    programDatPath = [NSString stringWithFormat:@"%@%@", dataFolderPath, @"/programdat"];
    
    discDataFolderPath = [NSString stringWithFormat:@"%@%@%@%@", disc_prefix, mLevel_disc, @"/", mLevel_data_folder];
    discGbFilePath = [NSString stringWithFormat:@"%@%@%@", discDataFolderPath, @"/", mLevel_dat_file];
    discProgramDatPath = [NSString stringWithFormat:@"%@%@", discDataFolderPath, @"/programdat"];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];//Initalize filemanager
    if ([filemanager fileExistsAtPath:dataFolderPath] == false) { //Check if data folder exists
        if ( [[NSFileManager defaultManager] isReadableFileAtPath:discDataFolderPath]) {
            [[NSFileManager defaultManager] copyItemAtPath:discDataFolderPath toPath:dataFolderPath error:nil];//If disc is readable then copy datafolder
        } else { //If folder not readable
            showSimpleCriticalAlert(@"Disc Read Error", @"There was a problem reading the data on your Disc 1. Please clean your disc and try again. If the problem continues, contact customer support at (866)-867-6284.", true); //If failed then prompt with disc read error
        }//end readable if
    } else { //if data folder exists
        //check if gb dat file exists
        if ([filemanager fileExistsAtPath:gbFilePath] == false) { //Check if gb dat exists
            if ( [[NSFileManager defaultManager] isReadableFileAtPath:discGbFilePath]) {
                [[NSFileManager defaultManager] copyItemAtPath:discGbFilePath toPath:gbFilePath error:nil];//If disc is readable then copy gb dat file
            } else { //If file not readable
                showSimpleCriticalAlert(@"Disc Read Error", @"There was a problem reading the data on your Disc 1. Please clean your disc and try again. If the problem continues, contact customer support at (866)-867-6284.", true); //If failed then prompt with disc read error
            }//end readable if
        } else { //If it does exist
            isValidDatFile(gbFilePath, discGbFilePath);
        }//end exist if
        
        //check if programdat file exists
        if ([filemanager fileExistsAtPath:programDatPath] == false) { //Check if programdat exists
            if ( [[NSFileManager defaultManager] isReadableFileAtPath:discProgramDatPath]) {
                [[NSFileManager defaultManager] copyItemAtPath:discProgramDatPath toPath:programDatPath error:nil];//If disc is readable then copy programdat file
            } else { //If file not readable
                showSimpleCriticalAlert(@"Disc Read Error", @"There was a problem reading the data on your Disc 1. Please clean your disc and try again. If the problem continues, contact customer support at (866)-867-6284.", true); //If failed then prompt with disc read error
            }//end readable if
        } else { //if it does exist
            isValidDatFile(programDatPath, discProgramDatPath);
        }//end exist if
    }//end datafolder exist if
}//end function
//****************************************

//****************************************
//FUNCTION: Fix file permissions
//****************************************
void fixPermissions() {
    NSString *target_file;
    NSArray *target_directory;
    
    target_directory = @[[NSString stringWithFormat:@"%@%@", @"/Applications/Teaching Textbooks/", mLevel_app_folder], [NSString stringWithFormat:@"%@%@", @"/Users/Shared/", mLevel_data_folder]];
    //Enumerate files
    //Loop through paths to be considered in the file permission changes
    for (NSString *t_dir in target_directory) {
        NSDirectoryEnumerator *dirEnum =[[NSFileManager defaultManager] enumeratorAtPath:t_dir];
        NSString *file; //Holds file name
        
        while (file = [dirEnum nextObject]) {//Loop through files
            target_file = [NSString stringWithFormat:@"%@%@%@", t_dir, @"/", file];
            NSDictionary *properties = [[NSFileManager defaultManager] attributesOfItemAtPath:target_file error:nil];
            //Build permission object
            NSMutableDictionary *newProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
            [newProperties setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
            
            //Set attributes
            [[NSFileManager defaultManager] setAttributes:newProperties ofItemAtPath:target_file error:nil];
        }//End while
    }//end for
}//End function
//****************************************

//****************************************
//FUNCTION: Settings update
//****************************************
void fixFlash() {
    NSString *localContentsPath;
    NSString *localPlayerPath;
    NSString *localPluginPath;
    //Initalize strings to hold local paths
    localContentsPath = [NSString stringWithFormat:@"%@%@%@%@%@", @"/Applications/Teaching Textbooks/", mLevel_app_folder, @"/", mLevel_app, @"/Contents/"];
    localPlayerPath = [NSString stringWithFormat:@"%@%@", localContentsPath, @"MacOS/mdm_flash_player"];
    localPluginPath = [NSString stringWithFormat:@"%@%@", localContentsPath, @"Resources/Flash Player.plugin"];

    //Removing old files
    [[NSFileManager defaultManager] removeItemAtPath:localPlayerPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:localPluginPath error:nil];
    
    //Copy new files
    [[NSFileManager defaultManager] copyItemAtPath:player_path toPath:localPlayerPath error:nil];
    [[NSFileManager defaultManager] copyItemAtPath:plugin_path toPath:localPluginPath error:nil];
    
}
//****************************************

//****************************************
//FUNCTION: checks file sizes
//****************************************
void isValidDatFile(NSString *path, NSString *path_d) {
    uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    //Checking on dat file
    //fileSize = [fileAttributes objectForKey:NSFileSize];
    if (fileSize < 4096) {
        if ( [[NSFileManager defaultManager] isReadableFileAtPath:path_d]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:path toPath:path_d error:nil];//If disc is readable then copy dat file
        } else { //If file not readable
            showSimpleCriticalAlert(@"Disc Read Error", @"There was a problem reading the data on your Disc 1. Please clean your disc and try again. If the problem continues, contact customer support at (866)-867-6284.", true); //If failed then prompt with disc read error
        }//end readable if
    }//end file check size if
}//end function
//****************************************

//****************************************
//FUNCTION: Reloads data
//****************************************
- (id) init{ //initalize methods from header
    self.MathLevelLabel = [[NSTextField alloc] init];
    self.settingsUpdateLabel = [[NSTextField alloc] init];
    self.SettingsUpdateBtn = [[NSButton alloc] init];
    return self;
}

- (void) reloadData {
    loadMathData();
    _MathLevelLabel.stringValue = mLevel_name;
    admin_file_path = [NSString stringWithFormat:@"%@%@%@", @"/Applications/Teaching Textbooks/",mLevel_app_folder, @"/Asset/Admin"]; //location of admin swf

    if ([mLevel_name isEqualToString:patchID]) {
        isUpdateReady = true;
        _SettingsUpdateBtn.enabled = true;
        if (checkVersion()) {
            _settingsUpdateLabel.stringValue = @"The settings update has already been applied for this math level! It is not necessary to apply it again.";
            settingsUpdateZip_path = [NSString stringWithFormat:@"%@%@%@", resource_path, @"/", mLevel_zip_file]; //Path to settings update zip: TODO Make into function. Redundant code
        } else {
            _settingsUpdateLabel.stringValue = @"This math level is not up to date. To apply the settings update, click the [Settings Update] button above! (Optional)";
            settingsUpdateZip_path = [NSString stringWithFormat:@"%@%@%@", resource_path, @"/", mLevel_zip_file];
        }
    } else {
        isUpdateReady = false;
        _SettingsUpdateBtn.enabled = false;
        _settingsUpdateLabel.stringValue = @"Settings update is not available for this math level. Please download the correct patch from our website http://www.teachingtextbooks.com/updates";
    }

}//end function
//****************************************
@end
