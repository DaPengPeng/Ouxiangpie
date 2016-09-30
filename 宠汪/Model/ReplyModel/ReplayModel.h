//
//  ReplyModel.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/3.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "BaseModel.h"

@interface ReplayModel : BaseModel

@property (nonatomic, copy) NSString *rId, *rMId, *rUId, *rContent;

@property (nonatomic, retain) NSDate *createdAt;

@end
