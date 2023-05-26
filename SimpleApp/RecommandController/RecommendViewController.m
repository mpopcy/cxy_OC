//
//  RecommendViewController.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/16.
//

#import "RecommendViewController.h"
#import "RecommendSectionController.h"
#import "ListLoader.h"

@interface RecommendViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,IGListAdapterDataSource>

@property(nonatomic, strong, readwrite) UICollectionView *collectionView;
@property(nonatomic, strong, readwrite) IGListAdapter *listAdapter;
@property(nonatomic, strong, readwrite) ListLoader *listLoader;
@property (nonatomic, strong, readwrite) NSArray *dataArray;

@end

@implementation RecommendViewController

-(instancetype)init{
    self=[super init];
    if(self){
        self.tabBarItem.title=@"recommand";
        self.tabBarItem.image=[UIImage imageNamed:@"icon.bundle/like@2x.png"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"icon.bundle/like_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
//    //创建scrollView，设置其显示大小等于屏幕大小
//    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.backgroundColor=[UIColor lightGrayColor];
//    //设置可滚动区域的大小为横向五屏宽
//    scrollView.contentSize=CGSizeMake(self.view.bounds.size.width * 5, self.view.bounds.size.height);
//    scrollView.delegate=self;
//    //在scrollView上创建五个uiView
//    NSArray *colorArray=@[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor],[UIColor systemPinkColor]];
//    for(int i=0;i<5;i++){
//        [scrollView addSubview:({
//            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//
//            //在非UIControl上识别用户操作并响应，添加一个view，创建tapGesture，设置响应函数，再用view调用创建的gesture
//            [view addSubview:({
//                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
//                view.backgroundColor=[UIColor yellowColor];
//                UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
//                tapGesture.delegate=self;
//                [view addGestureRecognizer:tapGesture];
//                view;
//            })];
//
//
//            view.backgroundColor=[colorArray objectAtIndex:i];
//            view;
//        })];
//    }
//    scrollView.pagingEnabled=YES;
//    [self.view addSubview:scrollView];
    
    self.listLoader = [[ListLoader alloc] init];
    
    [self.view addSubview:({
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView;
    })];
    
    _listAdapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new]
                                           viewController:self
                                         workingRangeSize:0];
    
    _listAdapter.dataSource = self;
    _listAdapter.scrollViewDelegate = self;
    _listAdapter.collectionView = _collectionView;
    
    __weak typeof(self)wself = self;
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<ListItem *> * _Nonnull dataArray) {
        __strong typeof(wself) strongSelf = wself;
        strongSelf.dataArray = dataArray;
        [strongSelf.listAdapter reloadDataWithCompletion:nil];
    }];
}

#pragma mark - UISCROLLVIEW DELEGATE
//scrollView delegate的部分方法实现
//scrollView发生滚动时会回调该方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scrollView Scrolling - %@",@(scrollView.contentOffset.x));
}// any offset changes

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //开始拖拽
    NSLog(@"begin dragging");
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //结束拖拽
    NSLog(@"end dragging");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //用户拖拽手势停止后开始减速，页面停止时回调该函数
}   // called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //结束减速，页面停止时回调该函数
}      // called when scroll view grinds to a halt


//tapGesture的触发方法
-(void)viewClick{
    NSURL *urlScheme=[NSURL URLWithString:@"TestScheme://"];
    
    //先判断需要拉起的APP是否在本机已安装
    //IOS9之后需要添加白名单，只能判断白名单中的APP是否安装，如果不在白名单中，也返回NO
    BOOL canOpenURL=[[UIApplication sharedApplication] canOpenURL:urlScheme];
    //点击跳转到另一个APP
    [[UIApplication sharedApplication] openURL:urlScheme options:nil completionHandler:^(BOOL success){
        NSLog(@"jump to test scheme-->");
    }];
    
    NSLog(@"viewClick");
}

//UIGestureRecognizerDelegate的方法实现举例
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //是否执行当前手势
    return YES;
}

#pragma mark - IGList
- (NSArray<id <IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataArray;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [RecommendSectionController new];
}

- (nullable UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
