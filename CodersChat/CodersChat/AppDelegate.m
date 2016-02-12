//
//  AppDelegate.m
//  CodersChat
//
//  Created by GlobalLogic on 12/02/16.
//  Copyright © 2016 GlobalLogic. All rights reserved.
//

#import "AppDelegate.h"
#import "Utility.h"
#import "Reachability.h"

AppDelegate *appDelegate;

@interface AppDelegate ()

@property (strong, nonatomic, readwrite) NSString *latestDeviceToken;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - AlertDialogProgressViewDelegate methods implementation
-(void)startActivityIndicator{
    [self startActivityIndicator:nil withText:NSLocalizedString(@"Data Uploading...", nil)];
}
-(void)startActivityIndicator:(UIView *)view withText:(NSString *)text{
    
    if(_alertDialogProgressView == nil){
        _alertDialogProgressView = [[AlertDialogProgressView alloc] initWithView:appDelegate.window];
    }
    [appDelegate.window addSubview:_alertDialogProgressView];
    _alertDialogProgressView.delegate = self;
    _alertDialogProgressView.detailsLabelText = text;
    _alertDialogProgressView.taskInProgress = YES;
    [_alertDialogProgressView show:YES];
}

-(void)stopActivityIndicator{
    if (_alertDialogProgressView.taskInProgress == YES) {
        [_alertDialogProgressView hide:YES];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.diaspark.care4today.ShoppingAppDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DBModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Zargow.sqlite"];
    NSString *storeFilePath = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"Zargow.sqlite"];
    NSLog(@" path %@", storeFilePath);
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:storeFilePath]){
        
    }
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES,NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}



#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (BOOL) resetApplicationModel {
    
    @try{
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *storePath = [[Utility getDocumentPath] stringByAppendingPathComponent:@"Zargow.sqlite"];
        NSError *error;
        [manager removeItemAtPath:storePath error:&error];
        
        //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kApplicationIsFirstTimeRunKey];
        // NSLog(@"Turned ON the first-time run flag...");
        
        NSError *_error = nil;
        NSURL *_storeURL = [NSURL fileURLWithPath:storePath];
        NSPersistentStore *_store = [self.persistentStoreCoordinator persistentStoreForURL:_storeURL];
        
        //
        // Remove the SQL store and the file associated with it
        //
        if ([self.persistentStoreCoordinator removePersistentStore:_store error:&_error]) {
            [[NSFileManager defaultManager] removeItemAtPath:_storeURL.path error:&_error];
        }
        
        if (_error) {
            NSLog(@"Failed to remove persistent store: %@", [_error localizedDescription]);
            NSArray *_detailedErrors = [[_error userInfo] objectForKey:NSDetailedErrorsKey];
            if (_detailedErrors != nil && [_detailedErrors count] > 0) {
                for (NSError *_detailedError in _detailedErrors) {
                    NSLog(@" DetailedError: %@", [_detailedError userInfo]);
                }
            }
            else {
                NSLog(@" %@", [_error userInfo]);
            }
            //            return NO;
        }
        
        
        _persistentStoreCoordinator = nil;
        _managedObjectContext = nil;
        
        //
        // Rebuild the application's managed object context
        //
        [self managedObjectContext];
        
        return YES;
    }
    
    @catch (NSException * e) {
        
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
    deviceTokenString=[deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceTokenString=[deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString=[deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"Device Token %@",deviceTokenString);
    self.latestDeviceToken =  deviceTokenString;
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error  {
    NSLog(@"Device Token %@",@"error");
    
    self.latestDeviceToken = nil;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        self.networkStatus = FALSE;
        //No internet
    }
    else if (status == ReachableViaWiFi)
    { self.networkStatus = TRUE;
        //WiFi
    }
    else if (status == ReachableViaWWAN)
    {
        self.networkStatus = TRUE;
        //3G
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkChanged" object:nil];
}


@end
