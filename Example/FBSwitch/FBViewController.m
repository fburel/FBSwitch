//
//  FBViewController.m
//  FBSwitch
//
//  Created by florian Burel on 07/18/2016.
//  Copyright (c) 2016 florian Burel. All rights reserved.
//

#import "FBViewController.h"
#import "FBSwitch.h"

@interface FBViewController () <UITableViewDataSource>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * values;
@end

@implementation FBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds
                                                 style:UITableViewStylePlain];
    
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.values = [@[@YES, @NO, @YES, @NO] mutableCopy];
    
    CGRect headerFrame = CGRectMake(0, 0, self.view.bounds.size.width, 64.f);
    [self.view addSubview:[[UINavigationBar alloc]initWithFrame:headerFrame]];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:headerFrame];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellID = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellID];
        FBSwitch * ctrl = [FBSwitch new];
        [ctrl addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = ctrl;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"value %ld", (long)indexPath.row];
    [(FBSwitch *) cell.accessoryView setOn:[self.values[indexPath.row] boolValue]];
    return cell;
}

- (void) switchValueDidChange:(FBSwitch *)sender
{
    id cell = sender;
    while (![cell isKindOfClass:[UITableViewCell class]]) {
        cell = [cell superview];
    }
    
    NSIndexPath * ip = [self.tableView indexPathForCell:cell];
    
    self.values[ip.row] = @(sender.isOn);
    [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
