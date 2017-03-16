//
//  NSString+Emoji.h
//  EmojiKeyBoard
//
//  Created by 晓琳 on 17/2/28.
//  Copyright © 2017年 xiaolin.han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

+ (NSDictionary *)getAllEmoji;

+ (NSString *)showChatWithEmojiContent:(NSString *)content;

+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

+ (BOOL)stringContainsEmoji:(NSString *)string;

- (BOOL)isEmoji;
@end
