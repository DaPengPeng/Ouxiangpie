//
//  UserModel.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/3.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, copy) NSString *objectId, *uId, *uAlais, *uImage, *uEmail, *uPhoneNumber, *uPassWord, *uSex, *uName, *uInfo, *upCaseAlais, *firstWord;

@property (nonatomic, retain) NSNumber *uAttCount, *uFanCount;


@end
