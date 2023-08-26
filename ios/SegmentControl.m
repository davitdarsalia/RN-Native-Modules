#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <objc/runtime.h>

@interface RNSegmentedControl : RCTViewManager
@end

@implementation RNSegmentedControl

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(values, NSArray)

- (UIView *)view {
  UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] init];
  [segmentedControl addTarget:self action:@selector(changeEvent:forEvent:) forControlEvents:UIControlEventValueChanged];
  return segmentedControl;
}

- (void)setValues:(NSArray *)values forView:(UIView *)view {
  UISegmentedControl *segmentedControl = (UISegmentedControl *)view;
  [segmentedControl removeAllSegments];
  for (NSInteger i = 0; i < [values count]; i++) {
    [segmentedControl insertSegmentWithTitle:values[i] atIndex:i animated:NO];
  }
}

- (void)changeEvent:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
  NSInteger selectedIndex = sender.selectedSegmentIndex;
  RCTBubblingEventBlock onChange = objc_getAssociatedObject(sender, "onChange");
  if (!onChange) {
    return;
  }

  onChange(@{
    @"nativeEvent": @{
        @"selectedSegmentIndex": @(selectedIndex),
    },
  });
}

- (void)setOnChange:(RCTBubblingEventBlock)onChange forView:(UIView *)view {
  UISegmentedControl *segmentedControl = (UISegmentedControl *)view;
  objc_setAssociatedObject(segmentedControl, "onChange", onChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
