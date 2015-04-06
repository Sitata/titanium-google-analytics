/**
 * Copyright (c) 2012 by Matt Tuttle
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "AnalyticsGoogleModule.h"
#import "AnalyticsGoogleTrackerProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation AnalyticsGoogleModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"6bdae9d9-4154-4d21-aacf-c0f95b193dae";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"analytics.google";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];

    // Dispatch any stored tracking events
    if (![NSThread isMainThread])
    {
        TiThreadPerformOnMainThread(^{
            optOut = [[GAI sharedInstance] optOut];
            dryRun = [[GAI sharedInstance] dryRun];
            dispatchInterval = [[GAI sharedInstance] dispatchInterval];
        }, NO);
    } else {
            optOut = [[GAI sharedInstance] optOut];
            dryRun = [[GAI sharedInstance] dryRun];
            dispatchInterval = [[GAI sharedInstance] dispatchInterval];
    }
}

-(void)shutdown:(id)sender
{
	[super shutdown:sender];

    // Dispatch any stored tracking events
    if (![NSThread isMainThread])
    {
        TiThreadPerformOnMainThread(^{
            [[GAI sharedInstance] dispatch];
        }, NO);
    } else {
        [[GAI sharedInstance] dispatch];
    }
}

#pragma mark Cleanup

-(void)dealloc
{
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

-(id)getTracker:(id)args
{
    NSString *trackingId;
    ENSURE_ARG_AT_INDEX(trackingId, args, 0, NSString);

	return [[[AnalyticsGoogleTrackerProxy alloc] initWithTrackingId:trackingId] autorelease];
}

-(id)defaultTracker
{
    return [[AnalyticsGoogleTrackerProxy alloc] initWithDefault];
}

-(id)optOut
{
    return [NSNumber numberWithBool:optOut];
}

-(void)setOptOut:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    optOut = [TiUtils boolValue:value];
    [[GAI sharedInstance] setOptOut:optOut];
}

-(id)dryRun
{
    return [NSNumber numberWithBool:dryRun];
}

-(void)setDryRun:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    dryRun = [TiUtils boolValue:value];
    [[GAI sharedInstance] setDryRun:dryRun];
}

-(id)dispatchInterval
{
    return [NSNumber numberWithDouble:dispatchInterval];
}

-(void)setDispatchInterval:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    [GAI sharedInstance].dispatchInterval = dispatchInterval = [value doubleValue];
}

-(void)setTrackUncaughtExceptions:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    [GAI sharedInstance].trackUncaughtExceptions = [value boolValue];
}

@end
