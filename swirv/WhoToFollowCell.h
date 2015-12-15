//
//  WhoToFollowCell.h
//  swirv
//
//  Created by Yash sikarvar on 11/12/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhoToFollowCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgVw_profile;
@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet UIImageView *imgVw_check;
@property (strong, nonatomic) IBOutlet UILabel *lbl_followers;
@property (strong, nonatomic) IBOutlet UILabel *lbl_following;

@end
