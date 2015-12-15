//
//  WhomToFollowControllerViewController.m
//  swirv
//
//  Created by Yash sikarvar on 11/12/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import "WhomToFollowControllerViewController.h"
#import "WhoToFollowCell.h"
#import "HomeViewController.h"

@interface WhomToFollowControllerViewController ()
{
    NSMutableArray *arrPeople;
     NSMutableArray *count;
}

@end

@implementation WhomToFollowControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [tbleVw registerNib:[UINib nibWithNibName:@"WhoToFollowCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    arrPeople= [[NSMutableArray alloc]init];
    [self getWhomToFollow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrPeople count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(WhoToFollowCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhoToFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[WhoToFollowCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"cellIdentifier"];
    }
    if(indexPath.row%2==0)
    {
        cell.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    }
    
    cell.selectionStyle=NO;
    
    
    NSDictionary *dic = [arrPeople objectAtIndex:indexPath.row];
    
    cell.lbl_name.text = [dic valueForKey:@"name"];
    NSString * url = [NSString stringWithFormat:@"%@/%@",baseurl,[dic valueForKey:@"avatar_url"]];
    
    [cell.imgVw_profile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] completed:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.lbl_following.text= [NSString stringWithFormat:@"%@",[dic valueForKey:@"num_following"]];
    cell.lbl_followers.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"num_followers"]];
   // NSDictionary *dic = [self.user objectAtIndex:indexPath.row];
    
    
    
    //cell.name.text=[dic valueForKey:@"name"];
    
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
    
    
    return 49;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WhoToFollowCell *cell = (WhoToFollowCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    //    InviteViewCell *cell1 = (InviteViewCell*)[tableView cellForRowAtIndexPath:1];
    
    UIImage* checkImage = [UIImage imageNamed:@"select.png"];
    NSData *checkImageData = UIImagePNGRepresentation(checkImage);
    NSData *checkImageData1 = UIImagePNGRepresentation(cell.imgVw_check.image);
    
    if( [checkImageData isEqualToData:checkImageData1])
    {
        UIImage *img = [UIImage imageNamed:@""];
        [cell.imgVw_check setImage:img];
        count[indexPath.row]=@"NO";
        
    }
    else
    {
        UIImage *img = [UIImage imageNamed:@"select.png"];
        [cell.imgVw_check setImage:img];
        count[indexPath.row]=@"YES";
        
        
    }
}


-(void) getWhomToFollow
{
    if([AppDelegate networkAvailable])
        
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            
            
//            spinner.hidden=NO;
//            
//            [spinner startAnimating];
            
            NSString *url = [NSString stringWithFormat:@"%@registration/peopleToFollow",baseurl];
            
           
            id response =[HttpUtility makeGetConnectionRequestWithURL:url withAuthorization:YES];
            
            
            
            NSLog(@"response=%@",response);
            
            
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                
                
//                [spinner stopAnimating];
//                
//                spinner.hidden=YES;
                
                
                
                if(response!=nil)
                    
                {
                    
                    if([[response valueForKey:@"success"] intValue] == 1)
                        
                    {
                        
                        arrPeople = [response valueForKey:@"people"];
                        count = [[NSMutableArray alloc]initWithCapacity:arrPeople.count];
                        for (int i=0; i<arrPeople.count; i++) {
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
    //    spinner.hidden=NO;
    //    [spinner startAnimating];
}

-(void) stopAnimation
{
    //    [spinner stopAnimating];
    //    spinner.hidden=YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)acn_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)acn_next:(id)sender {
    HomeViewController *controller = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
