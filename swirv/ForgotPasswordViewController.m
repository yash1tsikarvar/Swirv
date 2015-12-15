//
//  ForgotPasswordViewController.m
//  swirv
//
//  Created by Yash sikarvar on 28/11/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()
{
    int dis;// used to calculate how much far UIVIew from origin (0,0)
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dis=0;
    spinner.hidden=YES;

    UIImage *imgEmail = [UIImage imageNamed:@"email.png"];
    [self rectFrame:txtfld_email image:imgEmail];

    // Do any additional setup after loading the view from its nib.
}
//Insert image on left view of UITextField
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

//calculate height how much view need to animate
#pragma- UITextfield Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect frame = screen.bounds;
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//dismiss forgot password view
- (IBAction)acn_SignIn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//User provide email id to server for recover their credential
- (IBAction)acn_submit:(id)sender {
    
    
    BOOL isValidEmail = [self NSStringIsValidEmail:txtfld_email.text];
    
    if(isValidEmail)
    {
        NSString *url = [NSString stringWithFormat:@"%@forgot_password",baseurl];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:txtfld_email.text,@"email", nil];
        
        if([AppDelegate networkAvailable])
        {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
                id response = [HttpUtility makePostConnectionRequestWithURL:url andPostData:dic withAuthorization:NO];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [NSThread detachNewThreadSelector:@selector(stopAnimation) toTarget:self withObject:nil];
                    if(response!=nil)
                    {
                        if([[response valueForKey:@"success"] intValue]==1)
                        {
                            [self popUp:[response valueForKey:@"message"]];
                         
                        }
                        else
                        {
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
            
            [self popUp:@"Check Internet Connection"];
            
        }
        
    }
    else
    {
        
        [self popUp:@"Please provide valid email address"];

    }

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

// show popUp method
-(void)popUp:(NSString *)str
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
@end
