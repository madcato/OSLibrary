//
//  ABHTTPAPIClient.m
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//

#import "ABHTTPAPIClient.h"


static NSString * const kOSAPIBaseURLString = @"http://localhost:3000/";

static NSString * const kPSAPIApplicationId = @"YOUR_APPLICATION_ID";
static NSString * const kOSAPIKey = @"YOUR_API_KEY";

@implementation ABHTTPAPIClient

+ (ABHTTPAPIClient *)sharedClient {
    static ABHTTPAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[ABHTTPAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kOSAPIBaseURLString]];
    });

    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
//        [self setDefaultHeader:@"X-Parse-Application-Id" value:kOSAPIApplicationId];
//        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kOSAPIKey];
    }

    return self;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;

    NSString* className2 = className;
    if([className isEqualToString:@"Person"]) {
        className2 = @"people";
    }
    request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@.json", className2] parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *paramters = nil;
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

        NSString *jsonString = [dateFormatter stringFromDate:updatedDate];
        paramters = [NSDictionary dictionaryWithObject:jsonString forKey:@"updated_at"];
    }

    request = [self GETRequestForClass:className parameters:paramters];
    return request;
}

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;

    NSString* className2 = className;
    if([className isEqualToString:@"Person"]) {
        className2 = @"people";
    }
    request = [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@.json", className2] parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId {

    NSString* className2 = className;
    if([className isEqualToString:@"Person"]) {
        className2 = @"people";
    }
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"%@/%@.json", className2, objectId] parameters:nil];
    return request;
}

@end
