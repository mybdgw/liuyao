//
//  LYStudyViewController.m
//  LYApp
//
//  Created by lichanghong on 16/6/23.
//  Copyright © 2016年 lichanghong. All rights reserved.
//

#import "LYStudyViewController.h"
#import "HttpUtil.h"
#import "GuaManager.h"
#import "LYTitleCell.h"

@interface LYStudyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation LYStudyViewController
{
    IBOutlet NSObject *_backButton;
    NSMutableArray    *_guaItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0,1)]];
    [self loadData];
    _guaItems = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)loadData
{
    __weak LYStudyViewController *wself = self;
    [HttpUtil doLoadGuaItemsSuccess:^(id json) {
        if (json) {
            NSString *errorno = json[@"errno"];
            if ([errorno intValue]==0) {
                NSArray *datalist = json[@"data"];
                if (datalist && datalist.count>0) {
                    _guaItems = [datalist mutableCopy];
                    [wself.tableView reloadData];
                }
                else
                {
                    NSLog(@"jkfjdll data nil ");
                    [LYToast showToast:@"服务器错误,请联系管理员(10060)"];
                }
            }
        }
        else
            NSLog(@"resultsdfsfdaaa = %@",json);
    } failure:^(NSString *errmsg) {
        NSLog(@"lll = %@",errmsg);
        [LYToast showToast:errmsg];
    }];
}

- (IBAction)handleAction:(id)sender {
    if (sender == _backButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _guaItems.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYTitleCell *cell;
    static NSString *CellIdentifier = @"LYLearnCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = [_guaItems objectAtIndex:indexPath.row];
    NSArray *guaa = [dic[@"g_gua"]componentsSeparatedByString:@":"];

    int guaindex = [[guaa firstObject]intValue];
    int bianguaindex = [guaa[1] intValue];
    NSDictionary *guaNames = [[GuaManager shareManager].guaNames objectAtIndex:guaindex];
    NSDictionary *bguaNames = [[GuaManager shareManager].guaNames objectAtIndex:bianguaindex];
    NSArray      *timestr = [dic[@"g_date"] componentsSeparatedByString:@":"];
    NSString *sex = [dic[@"g_gender"] isEqualToString:@"0"]?@"先生":@"女士";
    cell.titleLabel.text = [NSString stringWithFormat:@"一位%@ 问:%@",sex,dic[@"g_question"]];

    if (timestr.count > 3 && [guaNames allKeys].count>0) {
        NSString *time=   [NSString stringWithFormat:@"%@年%@月%@日%@时",timestr[0],timestr[1],timestr[2],timestr[3]];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@起卦  %@ 之 %@ 卦",time,                                                    [[guaNames allKeys]lastObject],[[bguaNames allKeys]lastObject]];
    }
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
