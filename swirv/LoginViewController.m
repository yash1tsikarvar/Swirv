//
//  LoginViewController.m
//  swirv
//
//  Created by Yash sikarvar on 28/11/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"
#import "inviteViewController.h"

@interface LoginViewController ()
{
    int dis;// distance of self view from origin (0,0)
    IBOutlet UIActivityIndicatorView *spinner;
     NSDictionary *dicInfo;// global dictionary to save user information
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dis=0;
    spinner.hidden=YES;
    UIImage *imgEmail = [UIImage imageNamed:@"email.png"];
    [self rectFrame:self.txtfld_email image:imgEmail];

     UIImage *imgPassword = [UIImage imageNamed:@"password.png"];
    [self rectFrame:self.txtfld_password image:imgPassword];
    

    // Do any additional setup after loading the view from its nib.
}

//Insert image on TextField
-(void)rectFrame:(UITextField *)textField image:(UIImage *)image
{
    UIImageView * imgVw= [[UIImageView alloc]initWithImage:image];

    float height = CGRectGetHeight(imgVw.frame);
    float width =  CGRectGetWidth(imgVw.frame) + 15;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [paddingView addSubview:imgVw];
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView=paddingView;
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.view.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.hidden=NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
//Login with Facebook
- (IBAction)acn_fblogin:(id)sender {
    [self loginFacebook];
}

- (void)loginFacebook {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile",@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show ];
        }
        else if (result.isCancelled) {
            
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Result Cancel" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show ];
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            NSLog(@"%@",result.token);
            if ([result.grantedPermissions containsObject:@"email"]) {
                
                //start
                
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:@"/me?fields=email,name,first_name,last_name"
                                              parameters:nil
                                              HTTPMethod:@"GET"];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                    
                    if (result)
                    {
                        
                        if([AppDelegate networkAvailable])
                        {
                            dicInfo = result;
                            NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",dicInfo[@"id"]]];
                            NSString *name = [NSString stringWithFormat:@"%@ %@",[result valueForKey:@"first_name"],[result valueForKey:@"last_name"]];
                            NSData  *data = [NSData dataWithContentsOfURL:url1];
                            NSString *encoded = [data  base64EncodedStringWithOptions:0];
                            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:name,@"name",[result valueForKey:@"id"],@"id",[result valueForKey:@"email"],@"email",encoded,@"avatar", nil];
                            NSString *url = [NSString stringWithFormat:@"%@loginWithFacebookToken",baseurl];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                
                                [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
                                id response = [HttpUtility makePostConnectionRequestWithURL:url andPostData:dic withAuthorization:NO];
                                NSLog(@"response=%@",response);
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [NSThread detachNewThreadSelector:@selector(stopAnimation) toTarget:self withObject:nil];
                                    if(response!=nil)
                                    {
                                        if([[response valueForKey:@"success"] intValue]==1)
                                        {
                                            
                                            NSMutableDictionary *dic = [response mutableCopy];
                                            
                                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
                                            
                                            
                                            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfo"];
                                            
                                            inviteViewController *controller = [[inviteViewController alloc]initWithNibName:@"inviteViewController" bundle:nil];
                                            [self presentViewController:controller animated:YES completion:nil];
                                            
                                        }
                                        else
                                        {
                                            [self popUp:[response valueForKey:@"message"]];

                                        }
                                    }
                                    else{
                                        [self popUp:@"Please try again"];
                                    }
                                });});
                        }
                        
                        else
                        {
                            [self popUp:@"Check Internet connection"];
                           
                        }
                        // Handle the result
                    }
                    
                    else
                    {
                        
                        [self popUp:[NSString stringWithFormat:@"%@",error]];
                        

                        
                    }
                    
                }];
            }
            
            else{
                [self popUp:@"You dont have permission to get email"];
                
            }
        }
    }];
    
}

//to show popUp messages
-(void)popUp:(NSString *)str
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


// signIn using email and password
- (IBAction)acn_signIn:(id)sender {

        
        [self animateTextField:self.view up:NO distance:dis duration:0.1f];
        dis= 0;
        [self.txtfld_password resignFirstResponder];
        [self.txtfld_email resignFirstResponder];
        
        
        if(self.txtfld_email.text.length>0)
        {
            if(self.txtfld_password.text.length>0)
            {
                BOOL isValidEmail = [self NSStringIsValidEmail:self.txtfld_email.text];
                if (isValidEmail) {
                    NSString *url = [NSString stringWithFormat:@"%@log-in",baseurl];
                    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.txtfld_email.text,@"email",self.txtfld_password.text,@"password", nil];
                    if([AppDelegate networkAvailable])
                    {
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
                            id response = [HttpUtility makePostConnectionRequestWithURL:url andPostData:dic withAuthorization:NO];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [NSThread detachNewThreadSelector:@selector(stopAnimation) toTarget:self withObject:nil];
                                if(response!=nil)
                                {
                                    if([[response valueForKey:@"success"] intValue] == 1)
                                    {
                                        
                                        NSMutableDictionary *dic = [response mutableCopy];
                                        
                                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
                                        
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfo"];
                                        
                                        inviteViewController *controller = [[inviteViewController alloc]initWithNibName:@"inviteViewController" bundle:nil];
                                        [self presentViewController:controller animated:YES completion:nil];
                                    }
                                    else{
                                        [self popUp:[response valueForKey:@"message"]];

                                    }
                                    
                                }
                                else
                                {
                                    [self popUp:@"Please try again"];
                                }
                            });});
                    }
                    else{
                        [self popUp:@"Check Internet connection"];
                      
                    }
                }
                else
                {
                    [self popUp:@"Please provide valid email address"];
              
                }
            }
            else
            {
                [self popUp:@"Password can not be blank"];
               
            }
            
        }
        else{
            
            [self popUp:@"Email can not be blank"];
        }
        
        
    

}


// Animate view to up/down according to requirements
-(void)animateTextField:(UIView*)view up:(BOOL)up distance:(const int)movementDistance duration:(const float)movementDuration
{
    
    dis += movementDistance;
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    view.frame = CGRectOffset(view.frame, 0, movement);
    
    [UIView commitAnimations];
}

#pragma- UITextfield Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect frame = screen.bounds;
    // textView.inputAccessoryView = self.toolbar;
    
    if(textField.frame.origin.y+ textField.frame.size.height+dis >frame.size.height-(frame.size.height-200))
    {
        
        [self animateTextField:self.view up:YES distance:(-(textField.frame.origin.y+ textField.frame.size.height+dis)+(frame.size.height-(frame.size.height-255))) duration:0.4f];
    }
}

//when click on return button of keyboard
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self animateTextField:self.view up:NO distance:dis duration:0.1f];
    dis= 0;
    [textField resignFirstResponder];
    return YES;
}

// validation for emailId
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


//Method for UIActivity Indicator
-(void) startAnimation
{
    spinner.hidden=NO;
    [spinner startAnimating];
}

-(void) stopAnimation
{
    [spinner stopAnimating];
    spinner.hidden=YES;
}

//when user click on forgot password button
- (IBAction)acn_forgotPassword:(id)sender {
    
    ForgotPasswordViewController *controller = [[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self presentViewController:controller animated:YES completion:nil];
}


// login with Sign Up
- (IBAction)acn_signUp:(id)sender {
    SignUpViewController *controller = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    [self presentViewController:controller animated:YES completion:nil];
}
@end
