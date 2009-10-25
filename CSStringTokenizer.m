//
//  CSStringTokenizer.m
//  CSStringTokenizer
//
//  Created by August Joki on 10/25/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import "CSStringTokenizer.h"
#import "CSStringToken.h"


@interface CSStringTokenizer ()

- (void)createTokenizer;

@end


@implementation CSStringTokenizer

#pragma mark -
#pragma mark Initializers

- (id)init {
  return [self initWithString:nil range:NSMakeRange(0, 0) options:kCFStringTokenizerUnitWord locale:[NSLocale autoupdatingCurrentLocale]];
}


- (id)initWithString:(NSString *)string {
  return [self initWithString:string range:NSMakeRange(0, string.length) options:kCFStringTokenizerUnitWord locale:[NSLocale autoupdatingCurrentLocale]]; 
}


- (id)initWithString:(NSString *)string range:(NSRange)range {
  return [self initWithString:string range:range options:kCFStringTokenizerUnitWord locale:[NSLocale autoupdatingCurrentLocale]];
}


- (id)initWithString:(NSString *)string options:(CSStringTokenizerOptions)options {
  return [self initWithString:string range:NSMakeRange(0, string.length) options:options locale:[NSLocale autoupdatingCurrentLocale]];
}


- (id)initWithString:(NSString *)string locale:(NSLocale *)locale {
  return [self initWithString:string range:NSMakeRange(0, string.length) options:kCFStringTokenizerUnitWord locale:locale];
}


- (id)initWithString:(NSString *)string range:(NSRange)range options:(CSStringTokenizerOptions)options {
  return [self initWithString:string range:range options:options locale:[NSLocale autoupdatingCurrentLocale]];
}


- (id)initWithString:(NSString *)string range:(NSRange)range locale:(NSLocale *)locale {
  return [self initWithString:string range:range options:kCFStringTokenizerUnitWord locale:locale]; 
}


- (id)initWithString:(NSString *)string options:(CSStringTokenizerOptions)options locale:(NSLocale *)locale {
  return [self initWithString:string range:NSMakeRange(0, string.length) options:options locale:locale];
}


- (id)initWithString:(NSString *)string range:(NSRange)range options:(CSStringTokenizerOptions)options locale:(NSLocale *)locale {
  if (self = [super init]) {
    self.string = string;
    self.range = range;
    self.options = options;
    self.locale = locale;
    [self createTokenizer];
    self.tokenType = CSStringTokenTypeRangeAndString;
    
    [self addObserver:self forKeyPath:@"string" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"range" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"options" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"locale" options:NSKeyValueObservingOptionNew context:NULL];
  }
  return self;
}


#pragma mark -
#pragma mark Factories


+ (id)tokenizer {
  return [[[self alloc] init] autorelease];
}


+ (id)tokenizerWithString:(NSString *)string {
  return [[[self alloc] initWithString:string] autorelease];
}


+ (id)tokenizerWithString:(NSString *)string range:(NSRange)range {
  return [[[self alloc] initWithString:string range:range] autorelease];
}


+ (id)tokenizerWithString:(NSString *)string options:(CSStringTokenizerOptions)options {
  return [[[self alloc] initWithString:string options:options] autorelease];
}


+ (id)tokenizerWithString:(NSString *)string locale:(NSLocale *)locale {
  return [[[self alloc] initWithString:string locale:locale] autorelease];
}


+ (id)tokenizerWithString:(NSString *)string range:(NSRange)range options:(CSStringTokenizerOptions)options {
  return [[[self alloc] initWithString:string range:range options:options] autorelease];
}


+ (id)tokenizerWithString:(NSString *)string range:(NSRange)range locale:(NSLocale *)locale {
  return [[[self alloc] initWithString:string range:range locale:locale] autorelease];
}


+ (id)tokenizerWithString:(NSString *)string options:(CSStringTokenizerOptions)options locale:(NSLocale *)locale {
  return [[[self alloc] initWithString:string options:options locale:locale] autorelease];
}


+ (id)tokenizerWithString:(NSString *)string range:(NSRange)range options:(CSStringTokenizerOptions)options locale:(NSLocale *)locale {
  return [[[self alloc] initWithString:string range:range options:options locale:locale] autorelease];
}


#pragma mark -
#pragma mark Properties


#ifdef TARGET_IPHONE_SIMULATOR
@synthesize string = _string;
@synthesize range = _range;
@synthesize options = _options;
@synthesize locale = _locale;
@synthesize fetchesSubTokens = _fetchesSubTokens;
@synthesize tokenType = _tokenType;
#else
@synthesize string, range, options, locale, fetchesSubTokens, tokenType;
#endif


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"string"] || [keyPath isEqualToString:@"range"]) {
    CFStringTokenizerSetString(tokenizer, (CFStringRef)self.string, CFRangeMake(self.range.location, self.range.length));
  }
  else if ([keyPath isEqualToString:@"options"] || [keyPath isEqualToString:@"locale"]) {
    CFRelease(tokenizer);
    [self createTokenizer];
  }
}


#pragma mark -
#pragma mark Memory Management


- (void)dealloc {
  [self removeObserver:self forKeyPath:@"string"];
  [self removeObserver:self forKeyPath:@"range"];
  [self removeObserver:self forKeyPath:@"options"];
  [self removeObserver:self forKeyPath:@"locale"];
  self.string = nil;
  self.locale = nil;
  [super dealloc];
}


#pragma mark -
#pragma mark Other Class Methods


- (NSString *)bestStringLanguage {
  return [[self class] bestStringLanguage:self.string];
}


+ (NSString *)bestStringLanguage:(NSString *)string {
  return [self bestStringLanguage:string range:NSMakeRange(0, string.length)];
}


+ (NSString *)bestStringLanguage:(NSString *)string range:(NSRange)range {
  return [(NSString *)CFStringTokenizerCopyBestStringLanguage((CFStringRef)string, CFRangeMake(range.location, range.length)) autorelease];
}


#ifndef TARGET_OS_IPHONE
+ (CSStringTokenizerOptions)supportedOptionsForLanguage:(NSString *)language {
  return CFStringTokenizerGetSupportedOptionsForLanguage((CFStringRef)language);
}
#endif


#pragma mark -
#pragma mark Tokens


- (CSStringToken *)tokenForCharacterAtIndex:(NSUInteger)index {
  CFStringTokenizerTokenType mask = CFStringTokenizerGoToTokenAtIndex(tokenizer, index);
  return [CSStringToken tokenFromTokenizer:tokenizer withString:self.string withMask:mask withType:self.tokenType fetchSubTokens:self.fetchesSubTokens];
}


#pragma mark -
#pragma mark Private


- (void)createTokenizer {
  CFRange rng = CFRangeMake(self.range.location, self.range.length);
  tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, (CFStringRef)self.string, rng, self.options, (CFLocaleRef)self.locale);
}


@end
