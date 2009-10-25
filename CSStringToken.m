//
//  CSStringToken.m
//  CSStringTokenizer
//
//  Created by August Joki on 10/25/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import "CSStringToken.h"
#import "CSStringTokenizer.h"

@interface CSStringToken ()

@property(readwrite) CSStringTokenType type;
@property(readwrite, copy) NSString *string;
@property(readwrite) NSRange range;
@property(readwrite, copy) NSString *latinTranscription;
@property(readwrite, copy) NSString *language;
@property(readwrite) BOOL hasSubTokens;
@property(readwrite, retain) NSArray *subTokens;
@property(readwrite) BOOL containsNumbers;
@property(readwrite) BOOL containsNonLetters;
@property(readwrite) BOOL isCJWord;

@end

@implementation CSStringToken


#pragma mark -
#pragma mark Initializers


- (id)initWithString:(NSString *)string andRange:(NSRange)range {
  if (self = [super init]) {
    BOOL isString = NO;
    BOOL isRange = NO;
    if (string != nil) {
      isString = YES;
      self.string = string;
    }
    if (range.location != kCFNotFound) {
      isRange = YES;
      self.range = range;
    }
    
    if (isRange && isString) {
      self.type = CSStringTokenTypeRangeAndString;
    }
    else if (isRange) {
      self.type = CSStringTokenTypeRange;
    }
    else if (isString) {
      self.type = CSStringTokenTypeString;
    }
    else {
      self.type = CSStringTokenTypeNone;
    }
  }
  return self;
}


- (id)initFromTokenizer:(CFStringTokenizerRef)tokenizer withString:(NSString *)string withMask:(CFStringTokenizerTokenType)mask withType:(CSStringTokenType)type fetchSubTokens:(BOOL)fetchSubTokens {
  if (self = [super init]) {
    if (mask == kCFStringTokenizerTokenNone) {
      [self release];
      return nil;
    }
    
    if (mask & kCFStringTokenizerTokenHasHasNumbersMask) {
      self.containsNumbers = YES;
    }
    if (mask & kCFStringTokenizerTokenHasNonLettersMask) {
      self.containsNonLetters = YES;
    }
    if (mask & kCFStringTokenizerTokenIsCJWordMask) {
      self.isCJWord = YES;
    }
    if (mask & (kCFStringTokenizerTokenHasSubTokensMask | kCFStringTokenizerTokenHasDerivedSubTokensMask)) {
      self.hasSubTokens = YES;
    }
    
    
    self.type = type;
    BOOL isRange = (type == CSStringTokenTypeRange || type == CSStringTokenTypeRangeAndString);
    BOOL isString = (type == CSStringTokenTypeString || type == CSStringTokenTypeRangeAndString);
    
    CFRange cfRange = CFStringTokenizerGetCurrentTokenRange(tokenizer);
    NSRange range = NSMakeRange(cfRange.location, cfRange.length);
    if (isRange) {
      self.range = range;
    }
    if (isString) {
      self.string = [string substringWithRange:range];
    }
    
    CFTypeRef attr = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription);
    if (attr != NULL) {
      self.latinTranscription = (NSString *)attr;
      CFRelease(attr);
    }
    attr = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLanguage);
    if (attr != NULL) {
      self.language = (NSString *)attr;
      CFRelease(attr);
    }
    
    if (self.hasSubTokens && fetchSubTokens) {
      CFRange *ranges = NULL;
      CFIndex maxRangeLength = 0;
      NSMutableArray *strings = nil;
      if (isRange) {
        maxRangeLength = string.length;
        ranges = malloc(sizeof(CFRange)*maxRangeLength);
      }
      if (isString) {
        strings = [[NSMutableArray alloc] init];
      }
      
      CFIndex numRanges = CFStringTokenizerGetCurrentSubTokens(tokenizer, ranges, maxRangeLength, (CFMutableArrayRef)strings);
      
      CFIndex count;
      if (isRange) {
        count = numRanges;
      }
      else if (isString) {
        count = strings.count;
      }
      
      NSMutableArray *subTokens = [[NSMutableArray alloc] init];
      for (int ii = 0; ii < count; ii++) {
        NSRange range = NSMakeRange(kCFNotFound, 0);
        NSString *str = nil;
        if (isRange) {
          CFRange cfRange = ranges[ii];
          range = NSMakeRange(cfRange.location, cfRange.length);
        }
        if (isString) {
          id obj = [strings objectAtIndex:ii];
          str = obj;
        }
        
        CSStringToken *subToken = [CSStringToken tokenWithString:str andRange:range];
        [subTokens addObject:subToken];
      }
      
      self.subTokens = [NSArray arrayWithArray:subTokens];
      
      if (ranges != NULL) {
        free(ranges);
      }
      if (strings != nil) {
        [strings release];
      }
    }
  }
  return self;
}


#pragma mark -
#pragma mark Factories


+ (id)tokenWithString:(NSString *)string andRange:(NSRange)range {
  return [[[self alloc] initWithString:string andRange:range] autorelease];
}


+ (id)tokenFromTokenizer:(CFStringTokenizerRef)tokenizer withString:(NSString *)string withMask:(CFStringTokenizerTokenType)mask withType:(CSStringTokenType)type fetchSubTokens:(BOOL)fetchSubTokens {
  return [[[self alloc] initFromTokenizer:tokenizer withString:string withMask:mask withType:type fetchSubTokens:fetchSubTokens] autorelease];
}


#pragma mark -
#pragma mark Properties

#ifdef TARGET_IPHONE_SIMULATOR
@synthesize type = _type;
@synthesize string = _string;
@synthesize range = _range;
@synthesize latinTranscription = _latinTranscription;
@synthesize language = _language;
@synthesize hasSubTokens = _hasSubTokens;
@synthesize subTokens = _subTokens;
@synthesize containsNumbers = _containsNumbers;
@synthesize containsNonLetters = _containsNonLetters;
@synthesize isCJWord = _isCJWord;
#else
@synthesize type, string, range, latinTranslation, language, hasSubTokens, subTokens, containsNumbers, containsNonLetters, isCJWord;
#endif

@end
