//
//  ViewController.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/14.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
//#import "DetailViewController.h"
#import "DelCellView.h"
#import "ListLoader.h"
#import "ListItem.h"
#import "Mediator.h"
#import "SearchBar.h"
#import "Screen.h"
#import "CommentManager.h"

@interface NewsViewController () <UITableViewDataSource,UITableViewDelegate,NewsTableViewCellDelegate>

@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) NSArray *dataArray;
@property(nonatomic,strong,readwrite) ListLoader *listLoader;

@end

@implementation NewsViewController

//重载初始化函数
-(instancetype)init{
    self=[super init];
    if(self){
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //创建一个与UIViewController大小相同的tableView
    //初始化时需要设置frame
    _tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    
    //dataSource是UITableview的delegate模式的一种，再实现require中的两个函数即可
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    self.listLoader=[[ListLoader alloc] init];
    
    //block需要处理循环引用的问题
    __weak typeof(self) wself=self;
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<ListItem *> * _Nonnull dataArray){
        __strong typeof(wself)strongSelf=wself;
        //将dataArray赋值给当前view的dataArray属性
        strongSelf.dataArray=dataArray;
        //刷新列表
        [strongSelf.tableView reloadData];
        
        NSLog(@"loadListDataWithFinishBlock");
    }];
    
    //搜索条
    self.navigationController.navigationBar.barTintColor=[UIColor redColor];
    [self.tabBarController.navigationItem setTitleView:({
        SearchBar *searchBar=[[SearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-UI(20), self.navigationController.navigationBar.bounds.size.height-17)];
        searchBar;
    })];
    
    
    
//    [self.view addSubview:({
//            UILabel *label=[[UILabel alloc] init];
//            label.text=@"hello";
//            label.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
//            label;
//        })];
//    self.view.backgroundColor=[UIColor whiteColor];
//    UIView *view=[[UIView alloc] init];
//    view.backgroundColor=[UIColor redColor];
//    view.frame=CGRectMake(150, 150, 100, 100);
//    [self.view addSubview:view];
//
//    //点击view响应到pushController方法
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushController)];
//    [view addGestureRecognizer:tapGesture];
}

//点击顶部灰色长条，弹出输入长文字的的框以及键盘
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor=[UIColor redColor];
//    [self.tabBarController.navigationItem setTitleView:({
//        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-UI(20), self.navigationController.navigationBar.bounds.size.height)];
//        button.backgroundColor=[UIColor grayColor];
//        [button addTarget:self action:@selector(_showCommentView) forControlEvents:UIControlEventTouchUpInside];
//        button;
//    })];
//}

#pragma mark - UITableViewDelegate
//UITableViewDelegate中的部分函数的实现
//通过indexPath指定(返回)cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
//指定当点击一个cell时会触发哪些操作的函数
//option+command+/ 出现函数注释
/// <#Description#>
/// @param tableView <#tableView description#>
/// @param indexPath <#indexPath description#>
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell后跳转到一个新的UIViewController，即将新页面push到navigationController的栈中
    ListItem *item=[self.dataArray objectAtIndex:indexPath.row];
//    DetailViewController *controller=[[DetailViewController alloc] initWithUrlString:item.articleUrl];
    
    //target-action组件化管理cell和detail新闻页面
//    __kindof UIViewController *detailController=[Mediator detailViewControllerWithUrl:item.articleUrl];
    
    //新展示的页面标题设置为cell的索引indexPath
//    detailController.title=[NSString stringWithFormat:@"%@",@(indexPath.row)];
//    [self.navigationController pushViewController:detailController animated:YES];
    
    //URL scheme组件化的调用
    [Mediator openUrl:@"detail://" params:@{@"url":item.articleUrl,@"controller":self.navigationController}];
    
    //使用key-value记录文章的已读状态，key是文章ID(正常开发应当有一个hasRead的属性，设置为key),value是对应文章array中文章ID对应的文章的已读or未读状态
    //在展示cell时判断文章的已读状态，展示不同的效果
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:item.title];
    
}

//dataSource的require中的两个函数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //在滚动列表时，每当有cell要进入可视区时都会回调该函数，先去系统默认的回收池，根据id取cell，看能否取到
    //调用dequeueReusableCellWithIdentifier方法
    NewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"id"];
    //若没有取到cell，自己创建一个cell
    if(!cell){
        //定义每一个indexPath的cell的样式，然后返回cell
        //默认提供四种样式
        cell=[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate=self;
    }
    //每次生成cell都调用布局函数，给cell中的各个label赋值
    [cell layoutTableViewCellWithItem:[self.dataArray objectAtIndex:indexPath.row]];
    
    
    
    return cell;
}

//实现自定义delegate：NewsTableViewCellDelegate的方法
-(void)tableViewCell:(UITableViewCell *)tableViewCell clickDelButton:(UIButton *)delBUtton{
//    DelCellView *delView=[[DelCellView alloc] initWithFrame:self.view.bounds];
//    //点击的button在cell中，要获取button在window中的坐标，需要进行转换
//    CGRect rect=[tableViewCell convertRect:delBUtton.frame toView:nil];
//
//    //block需要处理循环引用的问题
//    __weak typeof(self) wself=self;
//    [delView showDelViewFromPoint:rect.origin clickBlock:^{
//        __strong typeof(wself)strongSelf=wself;
////        [strongSelf.dataArray removeLastObject];
//        //在tableView中删除当前cell
//        [strongSelf.tableView deleteRowsAtIndexPaths:@[[strongSelf.tableView indexPathForCell:tableViewCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
//    NSLog(@"NewsTableViewCellDelegate");
}

//-(void)pushController{
//    //设置navigationBar的上边栏，标题、分享图标
//    UIViewController *viewController=[[UIViewController alloc] init];
//    viewController.view.backgroundColor=[UIColor whiteColor];
//    viewController.navigationItem.title=@"title";
//    viewController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:nil];
//
//    //调用自己的navigationController，push一个新的controller，达到切换页面的效果
//    [self.navigationController pushViewController:viewController animated:YES];
//}

-(void)_showCommentView{
    [[CommentManager sharedManager] showCommentView];
}

@end
