//
//  SignUpViewController.h
//  swirv
//
//  Created by Yash sikarvar on 28/11/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UITextField *txtfld_userName;
    IBOutlet UIButton *btn_addPhoto;
    IBOutlet UITextField *txtfld_email;
    
    IBOutlet UITextField *txtfld_password;
}
- (IBAction)acn_back:(id)sender;
- (IBAction)acn_addPhoto:(id)sender;
- (IBAction)acn_signUp:(id)sender;

@end
