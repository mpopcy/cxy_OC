//
//  AppDelegate.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/14.
//

#import "RecommendSectionController.h"
#import "Screen.h"
#import "VideoCollectionViewCell.h"
#import "ListItem.h"


@interface RecommendSectionController ()

@property(nonatomic, copy, readwrite) ListItem *listItem;

@end

@implementation RecommendSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(SCREEN_WIDTH, 200);
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {

    VideoCollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[VideoCollectionViewCell class] forSectionController:self atIndex:index];
//    [cell layoutWithVideoCoverUrl:_listItem.picUrl videoUrl:@""];
    [cell layoutWithVideoCoverUrl:@"videoCover" videoUrl:@""];

    return cell;
}

#pragma mark -

- (void)didUpdateToObject:(id)object {
    if (object && [object isKindOfClass:[ListItem class]]) {
        self.listItem = object;
    }
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    //
}

@end
