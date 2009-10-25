//
//  CSStringToken.h
//  CSStringTokenizer
//
//  Created by August Joki on 10/25/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

enum {
  CSStringTokenTypeNone,
  CSStringTokenTypeString,
  CSStringTokenTypeRange,
  CSStringTokenTypeRangeAndString
};

typedef NSUInteger CSStringTokenType;


@interface CSStringToken : NSObject {
#if defined(TARGET_IPHONE_SIMULATOR) || (!defined(__LP64__) && !defined(TARGET_OS_IPHONE))
  CSStringTokenType _type;
  NSString *_string;
  NSRange _range;
  NSString *_latinTranscription;
  NSString *_language;
  BOOL _hasSubTokens;
  NSArray *_subTokens;
  BOOL _containsNumbers;
  BOOL _containsNonLetters;
  BOOL _isCJWord;
#endif
}

@property(readonly) CSStringTokenType type;
@property(readonly, copy) NSString *string;
@property(readonly) NSRange range;
@property(readonly, copy) NSString *latinTranscription;
@property(readonly, copy) NSString *language;
@property(readonly) BOOL hasSubTokens;
@property(readonly, retain) NSArray *subTokens;
@property(readonly) BOOL containsNumbers;
@property(readonly) BOOL containsNonLetters;
@property(readonly) BOOL isCJWord;

- (id)initFromTokenizer:(CFStringTokenizerRef)tokenizer withString:(NSString *)string withMask:(CFStringTokenizerTokenType)mask withType:(CSStringTokenType)type fetchSubTokens:(BOOL)fetchSubTokens;
- (id)initWithString:(NSString *)string andRange:(NSRange)range;

+ (id)tokenFromTokenizer:(CFStringTokenizerRef)tokenizer withString:(NSString *)string withMask:(CFStringTokenizerTokenType)mask withType:(CSStringTokenType)type fetchSubTokens:(BOOL)fetchSubTokens;
+ (id)tokenWithString:(NSString *)string andRange:(NSRange)range;

@end
