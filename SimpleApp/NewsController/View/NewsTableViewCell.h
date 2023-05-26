//
//  NewsTableViewCell.h
//  SimpleApp
//
//  Created by 崔雪瑶 on 2023/2/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ListItem;


//自定义delegate实现cell和controller之间的通信
@protocol NewsTableViewCellDelegate <NSObject>

//点击“X”按钮时触发该delegate
-(void)tableViewCell:(UITableViewCell *)tableViewCell clickDelButton:(UIButton *)delBUtton;

@end

//新闻列表cell
@interface NewsTableViewCell : UITableViewCell

@property(nonatomic,weak,readwrite) id<NewsTableViewCellDelegate> delegate;

-(void) layoutTableViewCellWithItem:(ListItem *)item;

@end

NS_ASSUME_NONNULL_END
