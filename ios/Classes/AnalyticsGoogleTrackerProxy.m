/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "AnalyticsGoogleTrackerProxy.h"


@implementation AnalyticsGoogleTrackerProxy

-(id)initWithDefault
{
    if (self = [super init])
    {
        if (![NSThread isMainThread])
        {
            TiThreadPerformOnMainThread(^{
                tracker = [[GAI sharedInstance] defaultTracker];
//                trackingId = [tracker trackingId];
            }, NO);
        }
    }
    return self;
}

-(id)initWithTrackingId:(NSString*)value
{
    if (self = [super init])
    {
        trackingId = [[NSString alloc] initWithString:value];
        if (![NSThread isMainThread])
        {
            TiThreadPerformOnMainThread(^{
                tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];
            }, NO);
        }
    }
    return self;
}

-(void)dealloc
{
    RELEASE_TO_NIL(tracker);
    RELEASE_TO_NIL(trackingId);
    [super dealloc];
}

#pragma mark Public APIs

-(NSNumber*)anonymizeIP {
    return [NSNumber numberWithBool:anonymizeIP];
}

-(void)setAnonymizeIP:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    anonymizeIP = [TiUtils boolValue:value];
    [tracker set:kGAIAnonymizeIp value:(anonymizeIP ? @"1" : @"0")];
}

// https://developers.google.com/analytics/devguides/collection/ios/v3/user-id
-(void)setUser:(id)args
{
    NSString *userId;
    NSString *category;
    NSString *action;

    ENSURE_ARG_FOR_KEY(userId, args, @"userId", NSString);
    ENSURE_ARG_FOR_KEY(category, args, @"category", NSString);
    ENSURE_ARG_FOR_KEY(action, args, @"action", NSString);

    [tracker set:@"&uid"
           value:userId];
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:category
                                                                           action:action
                                                                            label:nil
                                                                            value:nil];
    [self handleCustomFields:builder jshash:args];
    [tracker send:[builder build]];
}


// https://developers.google.com/analytics/devguides/collection/ios/v3/events
-(void)trackEvent:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *category;
    NSString *action;
    NSString *label;
    NSNumber *value;

    ENSURE_ARG_FOR_KEY(category, args, @"category", NSString);
    ENSURE_ARG_FOR_KEY(action, args, @"action", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(label, args, @"label", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(value, args, @"value", NSNumber);

    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:category
                                                                           action:action
                                                                            label:label
                                                                            value:value];
    [self handleCustomFields:builder jshash:args];
    [tracker send:[builder build]];
}

// https://developers.google.com/analytics/devguides/collection/ios/v3/social
-(void)trackSocial:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *network;
    NSString *action;
    NSString *target;

    ENSURE_ARG_FOR_KEY(network, args, @"network", NSString);
    ENSURE_ARG_FOR_KEY(action, args, @"action", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(target, args, @"target", NSString);
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createSocialWithNetwork:network
                                                                           action:action
                                                                           target:target];
    [self handleCustomFields:builder jshash:args];
    [tracker send:[builder build]];


}

// https://developers.google.com/analytics/devguides/collection/ios/v3/usertimings
-(void)trackTiming:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *category;
    NSNumber *time;
    NSString *name;
    NSString *label;

    ENSURE_ARG_FOR_KEY(category, args, @"category", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(name, args, @"name", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(label, args, @"label", NSString);
    ENSURE_ARG_FOR_KEY(time, args, @"time", NSNumber);

    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:category
                                                                          interval:time
                                                                              name:name
                                                                             label:label];
    [self handleCustomFields:builder jshash:args];
    [tracker send:[builder build]];
}

// https://developers.google.com/analytics/devguides/collection/ios/v3/screens
-(void)trackScreen:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *screenName;

    ENSURE_ARG_FOR_KEY(screenName, args, @"screenName", NSString);

    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:screenName];

    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
    [self handleCustomFields:builder jshash:args];
    [tracker send:[builder build]];
}

// https://developers.google.com/analytics/devguides/collection/ios/v3/ecommerce
-(void)trackTransaction:(id)args
{

    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *transactionId;
    NSString *affiliation;
    NSNumber *revenue;
    NSNumber *tax;
    NSNumber *shipping;
    NSString *currency;

    ENSURE_ARG_FOR_KEY(transactionId, args, @"transactionId", NSString);
    ENSURE_ARG_FOR_KEY(affiliation, args, @"affiliation", NSString);
    ENSURE_ARG_FOR_KEY(revenue, args, @"revenue", NSNumber);
    ENSURE_ARG_FOR_KEY(tax, args, @"tax", NSNumber);
    ENSURE_ARG_FOR_KEY(shipping, args, @"shipping", NSNumber);
    ENSURE_ARG_OR_NIL_FOR_KEY(currency, args, @"currency", NSString);

    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTransactionWithId:transactionId
                                                                      affiliation:affiliation
                                                                          revenue:revenue
                                                                              tax:tax
                                                                         shipping:shipping
                                                                     currencyCode:currency];
    [self handleCustomFields:builder jshash:args];
    [tracker send:[builder build]];
}

// https://developers.google.com/analytics/devguides/collection/ios/v3/ecommerce
-(void)trackTransactionItem:(id)args
{

    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *transactionId;
    NSString *name;
    NSString *sku;
    NSString *category;
    NSNumber *price;
    NSNumber *quantity;
    NSString *currency;

    ENSURE_ARG_FOR_KEY(transactionId, args, @"transactionId", NSString);
    ENSURE_ARG_FOR_KEY(name, args, @"name", NSString);
    ENSURE_ARG_FOR_KEY(sku, args, @"sku", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(category, args, @"category", NSString);
    ENSURE_ARG_FOR_KEY(price, args, @"price", NSNumber);
    ENSURE_ARG_FOR_KEY(quantity, args, @"quantity", NSNumber);
    ENSURE_ARG_OR_NIL_FOR_KEY(currency, args, @"currency", NSString);

    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createItemWithTransactionId:transactionId
                                                                                 name:name
                                                                                  sku:sku
                                                                             category:category
                                                                                price:price
                                                                             quantity:quantity
                                                                         currencyCode:currency];
    [self handleCustomFields:builder jshash:args];
    [tracker send:[builder build]];
}

-(void)trackException:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);

    NSString *description;
    NSString *fatalStr;
    BOOL fatal;

    ENSURE_ARG_OR_NIL_FOR_KEY(fatalStr, args, @"fatalStr", NSString);
    fatal = [TiUtils boolValue:fatalStr def:NO];
    ENSURE_ARG_OR_NIL_FOR_KEY(description, args, @"description", NSString);

    [tracker send:[[GAIDictionaryBuilder
        createExceptionWithDescription: description  withFatal: fatal] build]];
}

// Allow for manual dispatching of events when dispatchInterval is set to 0
-(void)dispatchAnalyticsEvents:(id)args
{
    ENSURE_UI_THREAD_0_ARGS;
    [[GAI sharedInstance] dispatch];
}

-(id)trackingId
{
    return trackingId;
}



-(id<GAITracker>)tracker
{
    return tracker;
}


// Common way to deal with adding customDimension and customMetric fields
-(void) handleCustomFields:(GAIDictionaryBuilder*) builder jshash:(id)args
{
    NSString *key;
    NSString *val;
    NSNumber *metricVal;
    NSDictionary *customDimension;
    NSDictionary *customMetric;


    ENSURE_ARG_OR_NIL_FOR_KEY(customDimension, args, @"customDimension", NSDictionary);
    if ([customDimension count]) {
        for(key in customDimension) {
            val = [customDimension objectForKey: key];
            ENSURE_TYPE(val, NSString);
            [builder set:val forKey:[GAIFields customDimensionForIndex:[key integerValue]]];
        }
    }

    ENSURE_ARG_OR_NIL_FOR_KEY(customMetric, args, @"customMetric", NSDictionary);
    if ([customMetric count]) {
        for(key in customMetric) {
            metricVal = [customMetric objectForKey: key];
            ENSURE_TYPE(metricVal, NSNumber);
            [builder set:[metricVal stringValue] forKey:[GAIFields customMetricForIndex:[key integerValue]]];
        }
    }

}

-(id)enableAdvertisingFeatures
{
    return tracker.allowIDFACollection;
}

-(void)setEnableAdvertisingFeatures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    tracker.allowIDFACollection = [value boolValue];
}

@end
