//
//  CHAInformationTableViewCell.h
//  Changers
//
//  Created by Denis on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAInformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
