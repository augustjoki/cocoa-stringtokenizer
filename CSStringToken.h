//
//  CSStringToken.h
//  CSStringTokenizer
//
//  Created by August Joki on 10/25/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

@interface CSStringToken : NSObject {
  NSString *string;
  NSRange range;
  NSString *latinTranslation;
  NSString *language;
  BOOL hasSubTokens;
  NSArray *subTokens;
  BOOL containsNumbers;
  BOOL containsNonLetters;
  BOOL isCJWord;
}

@property(readonly) NSString *string;
@property(readonly) NSRange range;
@property(readonly) NSString *latinTranslation;
@property(readonly) NSString *language;
@property(readonly) BOOL hasSubTokens;
@property(readonly) NSArray *subTokens;
@property(readonly) BOOL containsNumbers;
@property(readonly) BOOL containsNonLetters;
@property(readonly) BOOL isCJWord;

@end
