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
    
    CFRange cfRange = CFStringTokenizerGetCurrentTokenRange(tokenizer);
    NSRange range = NSMakeRange(cfRange.location, cfRange.length);
    if (type == CSStringTokenTypeRange) {
      self.range = range;
    }
    else if (type == CSStringTokenTypeString) {
      self.string = [string substringWithRange:range];
    }
    self.type = type;
    
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
      CFRange *ranges;
      CFIndex maxRangeLength = 0;
      CFMutableArrayRef strings;
      if (type == CSStringTokenTypeRange) {
        maxRangeLength = string.length;
        strings = NULL;
      }
      else if (type == CSStringTokenTypeString) {
        ranges = NULL;
        strings = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
      }
      
      CFIndex numRanges = CFStringTokenizerGetCurrentSubTokens(tokenizer, ranges, maxRangeLength, strings);
      
      if (type == CSStringTokenTypeRange && numRanges > 0) {
        NSMutableArray *subTokens = [[NSMutableArray alloc] init];
        for (int ii = 0; ii < numRanges; ii++) {
          CFRange range = ranges[ii];
          NSValue *value = [NSValue valueWithRange:NSMakeRange(range.location, range.length)];
          [subTokens addObject:value];
        }
        self.subTokens = [NSArray arrayWithArray:subTokens];
        [subTokens release];
      }
      else if (type == CSStringTokenTypeString) {
        self.subTokens = [NSArray arrayWithArray:(NSMutableArray *)strings];
      }
      
      if (ranges != NULL) {
        free(ranges);
      }
      if (strings != NULL) {
        CFRelease(strings);
      }
    }
  }
  return self;
}


#pragma mark -
#pragma mark Factories


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
