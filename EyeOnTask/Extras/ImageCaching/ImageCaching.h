//
//  ImageCaching.h
//  PrenatalYoga
//
//  Created by Vishal Paliwal on 04/11/16.
//  Copyright © 2016 Dawnsuntech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCaching : NSObject
@property (nonatomic,strong) NSCache *imageCache;
+(ImageCaching *)sharedInterface;
-(void)setImage:(UIImage *)image withID:(NSString *)imgID;
-(UIImage *)getImage:(NSString *)key;
-(void)clean;
@end
