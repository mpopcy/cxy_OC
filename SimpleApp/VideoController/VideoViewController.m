//
//  VideoViewController.m
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/14.
//  视频滚动列表用UICollectionView实现

#import "VideoViewController.h"
#import "VideoCoverView.h"
#import "VideoToolBar.h"

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation VideoViewController

-(instancetype)init{
    self=[super init];
    if(self){
        self.tabBarItem.title=@"video";
        self.tabBarItem.image=[UIImage imageNamed:@"icon.bundle/video@2x.png"];
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"icon.bundle/video_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初始化时需要设置frame(在屏幕中的大小)和layout
    //设置一个默认的layout（继承自UICollectionViewLayout），在layout中设置每个cell的attributes，将layout赋给UICollectionView，完成自定义所有cell布局样式
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //flowLayout的三个属性，横向间距，纵向间距，item大小
    flowLayout.minimumLineSpacing=10;
    flowLayout.minimumInteritemSpacing=10;
    flowLayout.itemSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.width /16*9 + VideoToolBarHeight);
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    //ios11之后新加的contentInsetAdjustmentBehavior属性，可以选择是否自动自动适配上边栏距离，不设置的话默认是自动适配
    collectionView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    
    //加delegate
    collectionView.delegate=self;
    collectionView.dataSource=self;
    
    //collectionView初始化后①要注册cell类型，以用于重用
    [collectionView registerClass:[VideoCoverView class] forCellWithReuseIdentifier:@"VideoCoverView"];
    
    //把新建的view粘贴到self的view中才能显示
    [self.view addSubview:collectionView];
    
}

//dataSource的两个方法，一个获取cell数量，一个根据indexPath获取cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCoverView" forIndexPath:indexPath];
//    cell.backgroundColor=[UIColor lightGrayColor];
    //可以在每个cell上粘贴subview，展示和处理相关逻辑
    
    //
    if([cell isKindOfClass:[VideoCoverView class]]){
        //http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
        //调用cell的layout方法展示cell
        [((VideoCoverView *)cell) layoutWithVideoCoverUrl:@"icon.bundle/videoCover@3x.png" videoUrl:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    }
    
    return cell;
}

//系统默认的流式布局flowLayout提供delegate，可以自定义每一个cell的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.item%3==0)
//        return CGSizeMake(self.view.frame.size.width, 100);
//    else
//        return CGSizeMake((self.view.frame.size.width-10)/2, 300);
//}

@end
