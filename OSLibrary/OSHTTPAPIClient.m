//
//  OSHTTPAPIClient.m
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//

#import "OSHTTPAPIClient.h"


static NSString * const kOSAPIBaseURLString = @"https://api.parse.com/1/";

static NSString * const kPSAPIApplicationId = @"YOUR_APPLICATION_ID";
static NSString * const kOSAPIKey = @"YOUR_API_KEY";

@implementation OSHTTPAPIClient

+ (OSHTTPAPIClient *)sharedClient {
    static OSHTTPAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[OSHTTPAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kOSAPIBaseURLString]];
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
    request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *paramters = nil;
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

        NSString *jsonString = [NSString
                                stringWithFormat:@"{\"updated_at\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [dateFormatter stringFromDate:updatedDate]];

        paramters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
    }

    request = [self GETRequestForClass:className parameters:paramters];
    return request;
}

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"classes/%@/%@", className, objectId] parameters:nil];
    return request;
}

@end
