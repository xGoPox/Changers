//
//  CHAInformationViewController.m
//  Changers
//
//  Created by Denis on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAInformationViewController.h"
#import "CHAInformationTableViewCell.h"

@interface CHAInformationViewController () <UITableViewDelegate, UITableViewDataSource>
- (IBAction)backButtonTapHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) CHAInformationTableViewCell *cellPrototype;
@property (nonatomic, strong) CHAInformationTableViewCell *headerCellPrototype;
@end

@implementation CHAInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"CHAInformation" ofType:@"plist"];
    self.data = [NSArray arrayWithContentsOfFile:plistPath];
    self.table.backgroundColor = [UIColor clearColor];
    self.headerCellPrototype = [self.table dequeueReusableCellWithIdentifier:@"headerCell"];
    self.cellPrototype = [self.table dequeueReusableCellWithIdentifier:@"transportCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHAInformationTableViewCell *cell = indexPath.row ? self.cellPrototype : self.headerCellPrototype;
    [self configureCell:cell froRowAtIndexPath:indexPath];
//    [self.cellPrototype layoutSubviews];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"transportCell";
    if (indexPath.row == 0) {
        cellIdentifier = @"headerCell";
    }
    CHAInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell froRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CHAInformationTableViewCell*)cell froRowAtIndexPath:(NSIndexPath*)indexPath {
    NSDictionary *dataDictionary = [self.data objectAtIndex:indexPath.row];
    cell.title.text = [dataDictionary valueForKey:@"title"];
    cell.subTitle.text = [dataDictionary valueForKey:@"subtitle"];
    NSString *imageName = [dataDictionary valueForKey:@"icon"];
    if (imageName.length)
        cell.iconImageView.image = [UIImage imageNamed:imageName];
}

- (IBAction)backButtonTapHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
