//
//  ViewController.m
//  MultiFacebook
//
//  Created by Ian  Terrell on 12/7/12.
//  Copyright (c) 2012 Ian Terrell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(strong, nonatomic) Facebook *facebook;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.facebook = [[Facebook alloc] initWithAppId:@"YOUR_FACEBOOK_APP_ID" urlSchemeSuffix:nil andDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginToFacebook:(id)sender {
    NSLog(@"BOOM");
    [self.facebook authorize:@[@"offline_access", @"publish_stream"]];
}
-(void)setAccessTokenFromURL:(NSURL*)url {
    NSLog(@"URL: %@", url);
    
    NSLog(@"ABSOLUTE URL STRING %@", [url absoluteString]);
    
    NSLog(@"parameter string: %@", [url parameterString]);

    NSString *absoluteString = [url absoluteString];
    NSArray *pathSegments = [absoluteString componentsSeparatedByString:@"#"];
    NSString *parameterString = [pathSegments objectAtIndex:1];
    NSDictionary *parameters = [self parseURLParams:parameterString];
    NSLog(@"parameters: %@", parameters);
    self.facebook.accessToken = [parameters objectForKey:@"access_token"];
    self.facebook.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[[parameters objectForKey:@"expires_in"] intValue]];
    
    NSLog(@"access token is %@", self.facebook.accessToken);
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

// Handle the publish feed call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    NSDictionary *params = [self parseURLParams:[url query]];
    NSString *msg = [NSString stringWithFormat:
                     @"Posted story, id: %@",
                     [params valueForKey:@"post_id"]];
    NSLog(@"%@", msg);
    // Show the result in an alert
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

- (IBAction)publishButtonAction:(id)sender {
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Test App", @"name",
                                   @"Hurray! This is a test!", @"caption",
                                   @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
                                   @"https://developers.facebook.com/ios", @"link",
                                   @"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png", @"picture",
                                   nil];
    
    // Invoke the dialog
    [self.facebook dialog:@"feed" andParams:params andDelegate:self];
}

- (void)onNativeAppOpen {
    NSLog(@"---onNativeAppOpen");
}

@end
