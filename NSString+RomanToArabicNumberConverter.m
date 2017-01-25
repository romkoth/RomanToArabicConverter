//
//  NSString+RomanToArabicNumberConverter.m
//  OpenCVTutorial
//
//  Created by Roman Bobelyuk on 1/25/17.
//  Copyright © 2017 Paul Sholtz. All rights reserved.
//

#import "NSString+RomanToArabicNumberConverter.h"

@implementation NSString (RomanToArabicNumberConverter)

- (int)romanToArabic:(NSString *)romanNumber{
    
    //create dictionary with roman and arabic values
    NSDictionary* romanArabic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"I",
                                 [NSNumber numberWithInt:5], @"V",
                                 [NSNumber numberWithInt:10], @"X",
                                 [NSNumber numberWithInt:50], @"L",
                                 [NSNumber numberWithInt:100], @"C",
                                 [NSNumber numberWithInt:500], @"D",
                                 [NSNumber numberWithInt:1000], @"M", nil];
    NSMutableArray *result = [NSMutableArray array];
    
    //validate roman string using regular expression
    if ([self romanNumberIsValid:romanNumber]) {
        
        //go throught romanString
        for (NSInteger charIdx=0; charIdx < romanNumber.length; charIdx++){
            
            //get roman and arabic values from dictionary
            NSString *romanianChar = [NSString stringWithFormat:@"%c", [romanNumber characterAtIndex:charIdx]];
            NSNumber *arabicNumber = [romanArabic objectForKey:romanianChar] ;
            
            //add first element to result arrray
            if (result.count == 0){
                [result addObject:arabicNumber];
                
            }else{
            //add next elements to result array
                if ([[result lastObject] intValue] < [arabicNumber intValue]){
                    //value of current arabic number is higher,than preivous, and we substruct it from previous arabic value (example "IX")
                    NSNumber *smallerArabicNumber = [NSNumber numberWithInt:([arabicNumber intValue] - [(NSNumber *)[result lastObject] intValue])];
                    [result removeLastObject];
                    [result addObject:smallerArabicNumber];
                }else{
                    //value of current arabic number is lower, than previous, and we just adding it (example "XI")
                    [result addObject:arabicNumber];
                }
            }
        }
    }else{
        NSLog(@"roman string number is not valid");
        return -1;
    }
    
    //add all arabic numbers in result array
    int sum = 0;
    for (NSNumber *arabicNumber in result) {
        sum += [arabicNumber intValue];
    }
    return [[NSNumber numberWithInt:sum] intValue];
}

- (BOOL) romanNumberIsValid:(NSString *) romanNumber{
    //there are some rules hot to write roman numbers
    //we should use regular expressions to validate romanNumber string, to not allow write something like "XIIIII, IIVXXX"
    if (romanNumber.length >= 1) {
        NSString *searchedString = romanNumber;
        NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
        //use regular expression patter for roman numbers
        NSString *pattern = @"^M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$";
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        NSInteger match = [regex numberOfMatchesInString:romanNumber options:0 range:searchedRange];
        if (match == 0 ) {
            NSLog(@"dont match");
            return NO;
        }else{
            NSLog(@"match");
            return YES;
        }
    }else{
        return NO;
    }
    return YES;
}

@end
