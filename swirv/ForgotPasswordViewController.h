//
//  ForgotPasswordViewController.h
//  swirv
//
//  Created by Yash sikarvar on 28/11/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
{
    
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UITextField *txtfld_email;
}
- (IBAction)acn_submit:(id)sender;

@end
