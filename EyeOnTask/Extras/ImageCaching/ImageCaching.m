//
//  ImageCaching.m
//  PrenatalYoga
//
//  Created by Vishal Paliwal on 04/11/16.
//  Copyright © 2016 Dawnsuntech. All rights reserved.
//

#import "ImageCaching.h"

@implementation ImageCaching
@synthesize imageCache=_imageCache;

static ImageCaching *shareImageInterface = nil;

+ (ImageCaching*)sharedInterface{
    @synchronized(self)  {
        if (shareImageInterface == nil)  {
            shareImageInterface  = [[self alloc] init];
        }
    }
    return shareImageInterface;
}

- (NSCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSCache alloc]init];
    }
    return _imageCache;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shareImageInterface == nil)
        {
            shareImageInterface = [super allocWithZone:zone];
            return shareImageInterface;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)setImage:(UIImage *)image withID:(NSString *)imgID{
    
    UIImage *img = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.7)];
    [self.imageCache setObject:img forKey:imgID];
}

-(UIImage *)getImage:(NSString *)key{
    return [self.imageCache objectForKey:key];
}

-(void)clean{
//    if (self.imageCache.count>10000) {
//        [self.imageCache removeAllObjects];
//        self.imageCache = nil;
//    }
}

@end
