//
//  AppDelegate.m
//  HelloMobage
//

#import "AppDelegate.h"

#import "ViewController.h"

#import <MobageNDK/MobageNDK.h>
#import <GLKit/GLKit.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"My own personal didFinishLaunchingWithOptions:");
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    
    // create your login background and show it
    // replace the image file LoginBackground.png to use your own image
    UIImageView *splash = [[UIImageView alloc] 
                           initWithImage:[UIImage imageNamed:@"LoginBackground.png"]];
    [splash setContentMode:UIViewContentModeScaleAspectFill];
    UIViewController *splashVc = [[UIViewController alloc] init];
    splashVc.view = splash;
    
    self.window.rootViewController = splashVc;
    [self.window makeKeyAndVisible];
    
    [splash release];
    [splashVc release];
    
    // typedef testing!
//    MBCommonAPIError y = MBCommonAPIInvalidSessionError;
//    NSLog(@"error: %d", y);
    
    [MBMobage initializeMobageWithServerEnvironment:kMBServerEnvironmentSandbox 
                                              appId:@"iansTestApp-iOS"
                                         appVersion:@"1.0" 
                                        consumerKey:@"59346RYOH3kY6fOGAgVg"
                                     consumerSecret:@"q6oL4zL1Gb3SQZZX6a1OVJbwQijnSeoYQhW1Cl13io"];
    
    [MBAuth authorizeToken:@"qfa7hjCUCv5IQpPF608Hw" withCallbackQueue:dispatch_get_main_queue()
                onComplete:^(MBSimpleAPIStatus status, NSObject<MBError> *error, NSString *verifier) {
                    switch (status) {
                        case MBSimpleAPIStatusError:
                            NSLog(@"Authorize Token Error!");
                            break;
                        case MBSimpleAPIStatusSuccess:
                            NSLog(@"Authorize Token Success! Verifier is: %@", verifier);
                    }
                }];
    
    // must be called after Mobage initialize
    // Note that this is an iOS function and it prompts the user for approval to receive
    // remote notifications and it only appears once
    // User needs to change the settings in iOS Settings > Notifications if they wish to
    // change settings later
//    [[UIApplication sharedApplication]
//     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | 
//                                         UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    [MBSocialService executeLoginWithKeys:@[@"LOGIN_OPTIONALITY"] values:@[@"mandatory"] withCallbackQueue:dispatch_get_main_queue() onComplete:^(MBCancelableAPIStatus status, NSObject<MBError> *error){
        
        switch (status){
            case MBCancelableAPIStatusError:
                NSLog(@"An error occured during user login: %@", error);
                break;
            case MBCancelableAPIStatusCancel:
                NSLog(@"User login cancelled.");
                break;
            case MBCancelableAPIStatusSuccess:
            default:
                NSLog(@"User login success.");
                // dismiss splash screen
                self.window.rootViewController = self.viewController;
                
                // start you game
                [MBPeople
                 getCurrentUserWithCallbackQueue:dispatch_get_main_queue()
                 onComplete:^(MBSimpleAPIStatus status, NSObject<MBError> *error, NSObject<MBUser> *user) {
                     if (error){
                         NSLog(@"getCurrentUser failed: %@", error);
                         return;
                     }
                     
                     UIAlertView *message =
                     [[[UIAlertView alloc]
                       initWithTitle:@"Welcome to Mobage"
                       message:[NSString stringWithFormat:@"%@, welcome to Mobage!", user.nickname]
                       delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] autorelease];
                     [message show];
                 }];
                
                [MBAuth authorizeToken:@"qfa7hjCUCv5IQpPF608Hw" withCallbackQueue:dispatch_get_main_queue()
                            onComplete:^(MBSimpleAPIStatus status, NSObject<MBError> *error, NSString *verifier) {
                                switch (status) {
                                    case MBSimpleAPIStatusError:
                                        NSLog(@"Authorize Token Error!");
                                        break;
                                    case MBSimpleAPIStatusSuccess:
                                        NSLog(@"Authorize Token Success! Verifier is: %@", verifier);
                                }
                            }];
                break;
        }
    }];
    
//    [MBSocialService executeLoginWithCallbackQueue:dispatch_get_main_queue()
//                                        onComplete:^(MBCancelableAPIStatus status, NSObject<MBError> *error){
//
//         switch (status){
//             case MBCancelableAPIStatusError:
//                 NSLog(@"An error occured during user login: %@", error);
//                 break;
//             case MBCancelableAPIStatusCancel:
//                 NSLog(@"User login cancelled.");
//                 break;
//             case MBCancelableAPIStatusSuccess:
//             default:
//                 NSLog(@"User login success.");
//                 // dismiss splash screen
//                 self.window.rootViewController = self.viewController;
//                 
//                 // start you game
//                 [MBPeople 
//                  getCurrentUserWithCallbackQueue:dispatch_get_main_queue() 
//                  onComplete:^(MBSimpleAPIStatus status, NSObject<MBError> *error, NSObject<MBUser> *user) {
//                      if (error){
//                          NSLog(@"getCurrentUser failed: %@", error);
//                          return;
//                      }
//                      
//                      UIAlertView *message = 
//                      [[[UIAlertView alloc] 
//                        initWithTitle:@"Welcome to Mobage"
//                        message:[NSString stringWithFormat:@"%@, welcome to Mobage!", user.nickname]
//                        delegate:nil 
//                        cancelButtonTitle:@"OK"
//                        otherButtonTitles:nil] autorelease]; 
//                      [message show];
//                  }];
//                 
//                 [MBAuth authorizeToken:@"qfa7hjCUCv5IQpPF608Hw" withCallbackQueue:dispatch_get_main_queue()
//                             onComplete:^(MBSimpleAPIStatus status, NSObject<MBError> *error, NSString *verifier) {
//                                 switch (status) {
//                                     case MBSimpleAPIStatusError:
//                                         NSLog(@"Authorize Token Error!");
//                                         break;
//                                     case MBSimpleAPIStatusSuccess:
//                                         NSLog(@"Authorize Token Success! Verifier is: %@", verifier);
//                                 }
//                             }];
//                 break;
//         }
//     }];
    
    [MBGameLeaderboard getAllLeaderboardsWithCallbackQueue:dispatch_get_main_queue() onComplete:^(MBSimpleAPIStatus status, NSObject<MBError> *error, NSArray *leaderboards) {
        switch (status) {
            case MBSimpleAPIStatusError:
                NSLog(@"Leaderboards error: %@", error);
                break;
                
            default:
                NSLog(@"Leaderboards success: %@", leaderboards);
                break;
        }
    }];
    
    return YES;
}

//// You need to pass the device token for push notifications to the Mobage instance
//- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSLog(@"my own personal didRegisterForRemoteNotifications");
//    [MBMobage sharedInstance].deviceToken = deviceToken;
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[MBMobage sharedInstance] onPause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[MBMobage sharedInstance] onResume];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[MBMobage sharedInstance] onStop];
}

@end
