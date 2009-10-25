//
//  CSStringTokenizer.h
//  CSStringTokenizer
//
//  Created by August Joki on 10/25/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

typedef CFOptionFlags CSStringTokenizerOptions;

enum {
  CSStringTokenizerTokenTypeString,
  CSStringTokenizerTokenTypeRange
};

typedef NSUInteger CSStringTokenizerTokenType;

@class CSStringToken;

@interface CSStringTokenizer : NSObject {
  CFStringTokenizerRef _tokenizer;
  NSString *_string;
  NSRange _range;
  CSStringTokenizerOptions _options;
  NSLocale *_locale;
  BOOL _fetchesSubTokens;
  CSStringTokenizerTokenType _tokenType;
}

@property(copy) NSString *string;
@property(assign) NSRange range;
@property(assign) CSStringTokenizerOptions options;
@property(retain) NSLocale *locale;
@property(assign) BOOL fetchesSubTokens;
@property(assign) CSStringTokenizerTokenType tokenType;

- (id)initWithString:(NSString *)string;
- (id)initWithString:(NSString *)string range:(NSRange)range;
- (id)initWithString:(NSString *)string options:(CSStringTokenizerOptions)options;
- (id)initWithString:(NSString *)string locale:(NSLocale *)locale;
- (id)initWithString:(NSString *)string range:(NSRange)range options:(CSStringTokenizerOptions)options;
- (id)initWithString:(NSString *)string range:(NSRange)range locale:(NSLocale *)locale;
- (id)initWithString:(NSString *)string options:(CSStringTokenizerOptions)options locale:(NSLocale *)locale;
- (id)initWithString:(NSString *)string range:(NSRange)range options:(CSStringTokenizerOptions)options locale:(NSLocale *)locale;

+ (id)tokenizer;
+ (id)tokenizerWithString:(NSString *)string;
+ (id)tokenizerWithString:(NSString *)string range:(NSRange)range;
+ (id)tokenizerWithString:(NSString *)string options:(CSStringTokenizerOptions)options;
+ (id)tokenizerWithString:(NSString *)string locale:(NSLocale *)locale;
+ (id)tokenizerWithString:(NSString *)string range:(NSRange)range options:(CSStringTokenizerOptions)options;
+ (id)tokenizerWithString:(NSString *)string range:(NSRange)range locale:(NSLocale *)locale;
+ (id)tokenizerWithString:(NSString *)string options:(CSStringTokenizerOptions)options locale:(NSLocale *)locale;
+ (id)tokenizerWithString:(NSString *)string range:(NSRange)range options:(CSStringTokenizerOptions)options locale:(NSLocale *)locale;

- (NSString *)bestStringLanguage;
+ (NSString *)bestStringLanguage:(NSString *)string;
+ (NSString *)bestStringLanguage:(NSString *)string range:(NSRange)range;

#ifndef TARGET_OS_IPHONE
+ (CSStringTokenizerOptions)supportedOptionsForLanguage:(NSString *)language;
#endif

- (CSStringToken *)tokenForCharacterAtIndex:(NSUInteger)index;

@end
