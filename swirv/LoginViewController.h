//
//  LoginViewController.h
//  swirv
//
//  Created by Yash sikarvar on 28/11/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtfld_email;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_password;
- (IBAction)acn_signIn:(id)sender;
- (IBAction)acn_forgotPassword:(id)sender;
- (IBAction)acn_signUp:(id)sender;


- (IBAction)acn_fblogin:(id)sender;
@end
