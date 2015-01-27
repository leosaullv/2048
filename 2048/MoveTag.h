//
//  MoveTag.h
//  2048
//
//  Created by admin on 14/11/26.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoveTag : NSObject

@property(nonatomic,copy)NSMutableArray *selectTag;
@property(nonatomic,copy)NSMutableArray *waitTag;
-(void)moveTagInitWithSelectTag:(NSMutableArray *)selectTag;


@end
