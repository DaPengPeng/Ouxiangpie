//
//  PrivateMessageModel.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/26.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "BaseModel.h"

@interface PrivateMessageModel : BaseModel

@property (nonatomic, retain) NSNumber *type;//0发出的消息，1接收的消息

@property (nonatomic, copy) NSString *text;//内容

@end
