//
//  MessageModel.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/3.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

@property (nonatomic, copy) NSString *mId, *mUId, *mContent, *mVideo, *mVideoCorImg;

@property (nonatomic, retain) NSNumber *mFavCount, *mReplayCount, *mPriseCount, *mType;

@property (nonatomic, retain) NSArray *mPhotos;

@property (nonatomic, retain) NSDate *createdAt;

@end
