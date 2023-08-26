#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>

@interface Time : RCTViewManager
@end

@implementation Time

RCT_EXPORT_MODULE();

- (UIView *)view {
  UIDatePicker *picker = [[UIDatePicker alloc] init];

  if (@available(iOS 14, *)) {
    picker.preferredDatePickerStyle = UIDatePickerStyleWheels; 
  }

  return picker;
}

RCT_CUSTOM_VIEW_PROPERTY(date, NSDate, UIDatePicker) {
  [view setDate:json ? [RCTConvert NSDate:json] : defaultView.date];
}

RCT_CUSTOM_VIEW_PROPERTY(minimumDate, NSDate, UIDatePicker) {
  [view setMinimumDate:json ? [RCTConvert NSDate:json] : defaultView.minimumDate];
}

RCT_CUSTOM_VIEW_PROPERTY(maximumDate, NSDate, UIDatePicker) {
  [view setMaximumDate:json ? [RCTConvert NSDate:json] : defaultView.maximumDate];
}

RCT_CUSTOM_VIEW_PROPERTY(mode, NSString, UIDatePicker) {
  if ([json isEqualToString:@"date"]) {
    [view setDatePickerMode:UIDatePickerModeDate];
  } else if ([json isEqualToString:@"time"]) {
    [view setDatePickerMode:UIDatePickerModeTime];
  } else if ([json isEqualToString:@"datetime"]) {
    [view setDatePickerMode:UIDatePickerModeDateAndTime];
  } else {
    [view setDatePickerMode:UIDatePickerModeDate];
  }
}

@end
