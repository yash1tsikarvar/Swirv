//
//  inviteViewController.m
//  LinkUp
//
//  Created by Yash sikarvar on 22/07/15.
//  Copyright (c) 2015 Yash sikarvar. All rights reserved.
//

#import "inviteViewController.h"
#import "InviteViewCell.h"
#import "WhomToFollowControllerViewController.h"
#import "HomeViewController.h"

@interface inviteViewController ()
{
BOOL key ;
BOOL selectall;
    IBOutlet UIButton *btn_selectall;
    NSMutableArray *count;
    int flag;//thig flag used for user choose any interest or not
    IBOutlet UIActivityIndicatorView *spinner;
}
@end

@implementation inviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tbleVw.backgroundView = nil;
    flag = 0;
    key=NO;
    selectall=NO;
    CGFloat width = 0.3f;
    navView.frame = CGRectInset(navView.frame, -width, -width);
    navView.layer.borderWidth = width;
    navView.layer.borderColor = [UIColor grayColor].CGColor;
    tbleVw.tableFooterView = [UIView new];
    tbleVw.backgroundColor=[UIColor clearColor];
    [tbleVw registerNib:[UINib nibWithNibName:@"InviteViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    self.user = [[NSMutableArray alloc] init];
     [self getInterest];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Get interest list from server
-(void)getInterest
{
    if([AppDelegate networkAvailable])
        
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            
            
            spinner.hidden=NO;
            
            [spinner startAnimating];
            
            
            NSString *url = [NSString stringWithFormat:@"%@registration/interests",baseurl];
            
            
            id response =[HttpUtility makeGetConnectionRequestWithURL:url withAuthorization:YES];
            
            
            
            NSLog(@"response=%@",response);
            
            
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                
                
                [spinner stopAnimating];
                
                spinner.hidden=YES;
                
                
                
                if(response!=nil)
                    
                {
                    
                    if([[response valueForKey:@"success"] intValue] == 1)
                        
                    {
                        [[AppDelegate alloc] stopVideo];
                        self.user = [response valueForKey:@"interests"];
                        count = [[NSMutableArray alloc]initWithCapacity:self.user.count];
                        for (int i=0; i<self.user.count; i++) {
                            count[i]=@"NO";
                        }
                        [tbleVw reloadData];
                        
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
                
                
                
                
                
            });
            
            
            
        });
        
    }
    
    else
        
    {
        
        [self popUp:@"Check Internet connection"];
        
    }
    
    
    

}

#pragma UITableView Delegate -

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [self.user count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(InviteViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[InviteViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"cellIdentifier"];
    }
    if(indexPath.row%2==0)
    {
        cell.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    }
    
    cell.selectionStyle=NO;
    NSDictionary *dic = [self.user objectAtIndex:indexPath.row];
    

    cell.name.text=[dic valueForKey:@"name"];

    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
-(void)viewDidLayoutSubviews
{
    if ([tbleVw respondsToSelector:@selector(setSeparatorInset:)]) {
        [tbleVw setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tbleVw respondsToSelector:@selector(setLayoutMargins:)]) {
        [tbleVw setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    InviteViewCell *cell = (InviteViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    UIImage* checkImage = [UIImage imageNamed:@"select.png"];
    NSData *checkImageData = UIImagePNGRepresentation(checkImage);
    NSData *checkImageData1 = UIImagePNGRepresentation(cell.imgV_tick.image);

    if( [checkImageData isEqualToData:checkImageData1])
    {
        UIImage *img = [UIImage imageNamed:@""];
        [cell.imgV_tick setImage:img];
        count[indexPath.row]=@"NO";
        flag--;

    }
    else
    {
    UIImage *img = [UIImage imageNamed:@"select.png"];
    [cell.imgV_tick setImage:img];
    count[indexPath.row]=@"YES";
        flag++;

    }
    if(flag>0)
    {
        [btnSkipAndNext setTitle:@"Next" forState:UIControlStateNormal];
    }
    else
    {
        [btnSkipAndNext setTitle:@"Skip" forState:UIControlStateNormal];
    }
}
//Save interests on server which is choose by user
- (IBAction)acn_send:(id)sender {
    
    if(flag>0)
    {
    
   NSString * interest_id= @" ";
    NSString *interest;
    for (int i=0; i<count.count; i++) {
        NSLog(@"index=%d  %@",i,count[i]);
        
        
        if([count[i] isEqualToString:@"YES"])
        {
            NSDictionary * dic = [self.user objectAtIndex:i];
             interest_id = [NSMutableString stringWithFormat:@"%@,%@",interest_id,[dic valueForKey:@"id"]];
            interest = [interest_id substringFromIndex:2];
        }
        NSLog(@"interest_ids =%@",interest);
    }
    
    if([AppDelegate networkAvailable])
        
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            
            
            spinner.hidden=NO;
            
            [spinner startAnimating];
            
            NSString *url = [NSString stringWithFormat:@"%@registration/saveInterests",baseurl];
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:interest,@"interests", nil];
            id response =[HttpUtility makePostConnectionRequestWithURL:url andPostData:dic withAuthorization:YES];
            
            
            
            NSLog(@"response=%@",response);
            
            
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                
                
                [spinner stopAnimating];
                
                spinner.hidden=YES;
                
                
                
                if(response!=nil)
                    
                {
                    
                    if([[response valueForKey:@"success"] intValue] == 1)
                        
                    {
                        
                        WhomToFollowControllerViewController *controller = [[WhomToFollowControllerViewController alloc] initWithNibName:@"WhomToFollowControllerViewController" bundle:nil];
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
                
                
                
                
                
            });
            
            
            
        });
        
    }
    
    else
        
    {
        [self popUp:@"Check Internet connection"];
        
    }
    
    }
    else
    {
        HomeViewController *controller = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        [self presentViewController:controller animated:YES completion:nil];
    }
    

}

//- (IBAction)acn_cancel:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.user removeAllObjects];
//}

//- (IBAction)acn_selectall:(id)sender {
//    if(!selectall)
//    {
//    selectall=YES;
//    [btn_selectall setTitle:@"Deselect all" forState:UIControlStateNormal];
//    [tbleVw reloadData];
//    }
//    else{
//        selectall=NO;
//        [btn_selectall setTitle:@"Select all" forState:UIControlStateNormal];
//        [tbleVw reloadData];
//    }
//    
//}

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
