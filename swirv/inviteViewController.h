//
//  inviteViewController.h
//  LinkUp
//
//  Created by Yash sikarvar on 22/07/15.
//  Copyright (c) 2015 Yash sikarvar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface inviteViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>
{
    
    IBOutlet UIButton *btnSkipAndNext;
    IBOutlet UITableView *tbleVw;
    IBOutlet UIView *navView;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
- (IBAction)acn_send:(id)sender;
- (IBAction)acn_cancel:(id)sender;
@property (strong, nonatomic) NSMutableArray * user;

@end
