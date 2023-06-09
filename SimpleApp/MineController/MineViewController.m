//
//  MineViewController.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/25.
//

#import "MineViewController.h"
#import "SDWebImage.h"
#import "Login.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) UIView *tableViewHeaderView;
@property(nonatomic,strong,readwrite) UIImageView *headerImageView;

@end

@implementation MineViewController

-(instancetype)init{
    self=[super init];
    if(self){
        self.tabBarItem.title=@"mine";
        self.tabBarItem.image=[UIImage imageNamed:@"icon.bundle/home@2x.png"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"icon.bundle/home_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:({
        _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView;
    })];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"mineTableViewCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mineTableViewCell"];
    }
    
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(!_tableViewHeaderView){
        _tableViewHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _tableViewHeaderView.backgroundColor=[UIColor whiteColor];
        
        [_tableViewHeaderView addSubview:({
            _headerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 140)];
            _headerImageView.backgroundColor=[UIColor whiteColor];
            _headerImageView.contentMode=UIViewContentModeScaleAspectFit;
            _headerImageView.clipsToBounds=YES;
            _headerImageView.userInteractionEnabled=YES;
            _headerImageView;
        })];
        
        [_tableViewHeaderView addGestureRecognizer:({
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapImage)];
            tapGesture;
        })];
    }
    return _tableViewHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if(![[Login sharedLogin] isLogin]){
        [_headerImageView setImage:[UIImage imageNamed:@"icon.bundle/icon.png"]];
    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[Login sharedLogin].avatarUrl]];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        cell.textLabel.text=[[Login sharedLogin] isLogin] ? [Login sharedLogin].nick:@"昵称";
    }else{
        cell.textLabel.text=[[Login sharedLogin] isLogin] ? [Login sharedLogin].address:@"地区";
    }
}

#pragma mark - click head
//点击头像：没有登陆的话去登陆，登录成功后reload数据；如果是登录状态点击头像，退出登录
- (void)_tapImage {

    __weak typeof(self) weakSelf = self;
    if (![[Login sharedLogin] isLogin]) {
        //没有登录的时候拉起登录
        [[ Login sharedLogin] loginWithFinishBlock:^(BOOL isLogin) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            //SDK流程之后判断是否登录成功
            if (isLogin) {
                [strongSelf.tableView reloadData];
            }
        }];
    }else{
        //已经登录的退出登录
        [[Login sharedLogin] logOut];
        [self.tableView reloadData];
    }
}
    
@end
    
