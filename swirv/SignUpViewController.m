//
//  SignUpViewController.m
//  swirv
//
//  Created by Yash sikarvar on 28/11/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import "SignUpViewController.h"
#import "inviteViewController.h"

@interface SignUpViewController ()
{
    IBOutlet UIActivityIndicatorView *spinner;
    int dis;
    UIImage *image_profile;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dis=0;
    spinner.hidden=YES;
    UIImage *imgEmail = [UIImage imageNamed:@"email.png"];
    [self rectFrame:txtfld_email image:imgEmail];
  
    UIImage *imgPassword = [UIImage imageNamed:@"password.png"];
    [self rectFrame:txtfld_password image:imgPassword];
   
    UIImage *imgUser = [UIImage imageNamed:@"username.png"];
    [self rectFrame:txtfld_userName image:imgUser];

  
}

// Insert image on left view on UItextField
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

// Dissmiss present view
- (IBAction)acn_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Save User credential on server
- (IBAction)acn_signUp:(id)sender {
    // move up main view
    [self animateTextField:self.view up:NO distance:dis duration:0.1f];
    
    [txtfld_password resignFirstResponder];
   // [txtfld_lastName resignFirstResponder];
    [txtfld_userName resignFirstResponder];
    [txtfld_email resignFirstResponder];
  //  [txtfld_confirmPassword resignFirstResponder];
    dis= 0;
    
    // check all the valid condition
    if(txtfld_userName.text.length>0)
    {
        
            if(txtfld_email.text.length>0)
            {
                if(txtfld_password.text.length>0)
                {
                   
                        BOOL isValidEmail = [self NSStringIsValidEmail:txtfld_email.text];
                        if(isValidEmail)
                        {
                            
                           
                                if([AppDelegate networkAvailable])
                                {
                                    
                                    NSData *imageData = UIImageJPEGRepresentation(image_profile, 0.5);
                                  NSString *encodedString  = [imageData base64EncodedStringWithOptions:0];
                                    
                                    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:encodedString,@"avatar", txtfld_userName.text,@"name",txtfld_email.text,@"email",txtfld_password.text,@"password", nil];
                                    
                                    NSDictionary *user = [[NSDictionary alloc] initWithObjectsAndKeys:dic,@"user", nil];
                                    
                                    NSString *url = [NSString stringWithFormat:@"%@users.json",baseurl];
                                    
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                                        
                                        [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
                                        id response = [HttpUtility makePostConnectionRequestWithURL:url andPostData:user withAuthorization:NO];
                                        NSLog(@"response=%@",response);
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [NSThread detachNewThreadSelector:@selector(stopAnimation) toTarget:self withObject:nil];
                                            if(response!=nil)
                                            {
                                                if([[response valueForKey:@"success"] intValue] ==1 )
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
                                            else
                                            {
                                                
                                                [self popUp:@"Please try again"];
                                               
                                            }
                                        });});
                                }
                                else
                                {
                                    [self popUp:@"Check Internet connection"];
                                    
                                }
                            
                    
                        }
                        else{
                            
                            
                            [self popUp:@"Invalid Email"];
                           
                            
                        }
                    }
                    
                
                else
                {
                    [self popUp:@"Please enter password"];
                   
                }
            }
            else
            {
                [self popUp:@"Email can't be blank"];
            }
        }

        
    else
    {
        [self popUp:@"Name can't be blank"];
       
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

// Show pop Up message
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

// image picker
-(IBAction)addPhoto_tapAction:(id)sender {
    
   
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Choose image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From library",@"From camera", nil];
    
    [action showInView:self.view];
    
 
}

//action sheet show to the user
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1 ) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
            pickerView.delegate = self;
            pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerView animated:YES completion:nil];
        }
        
    }else if( buttonIndex == 0 ) {
        
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.delegate = self;
        [self presentViewController:pickerView animated:YES completion:nil];
        
    }
}
#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    image_profile = info[UIImagePickerControllerOriginalImage];
    UIImage *image = [UIImage imageNamed:@"uploaded.png"];
    [btn_addPhoto setImage:image forState:UIControlStateNormal];

}

@end
