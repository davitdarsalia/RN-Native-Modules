#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

// BackgroundTimer class inherits from RCTEventEmitter and implements RCTBridgeModule
@interface BackgroundTimer : RCTEventEmitter <RCTBridgeModule>
@property (nonatomic, strong) NSTimer *timer; // NSTimer instance to manage the timer
@property (nonatomic, assign) NSInteger counter; // Counter to keep track of time
@end

@implementation BackgroundTimer

// Export this native module to JavaScript
RCT_EXPORT_MODULE();

// Declare the JavaScript events this module will emit
- (NSArray<NSString *> *)supportedEvents
{
  return @[@"onTimerUpdate"];
}

// Start the timer
RCT_EXPORT_METHOD(startTimer)
{
  self.counter = 0; // Reset counter
  // Create a background queue
  dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  // Dispatch timer task to the background queue
  dispatch_async(backgroundQueue, ^{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateCounter)
                                                userInfo:nil
                                                 repeats:YES];
    // Add timer to the current run loop
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    // Start the run loop
    [[NSRunLoop currentRunLoop] run];
  });
}

// Stop the timer
RCT_EXPORT_METHOD(stopTimer)
{
  [self.timer invalidate]; // Invalidate the timer
  self.timer = nil; // Remove timer instance
}

// Update the counter and emit event to JavaScript
- (void)updateCounter
{
  self.counter += 1; // Increment counter
  // Emit updated counter value to JavaScript
  [self sendEventWithName:@"onTimerUpdate" body:@{@"counter": @(self.counter)}];
}

@end
