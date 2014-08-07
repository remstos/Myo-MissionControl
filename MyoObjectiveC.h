//
//  MyoObjectiveC.h
//  OSXGestureControl
//
//  Created by Remi Santos on 05/08/2014.
//  Copyright (c) 2014 Chris Willingham. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Myo;

#pragma mark - MYOPOSE
typedef enum MyoPoseType {
    MyoPoseTypeFist = 0,
    MyoPoseTypeFingersSpread = 1,
    MyoPoseTypeWaveIn = 2,
    MyoPoseTypeWaveOut = 3,
    MyoPoseTypeThumbToPinky = 4
} MyoPoseType;
@interface MyoPose : NSObject
@property (nonatomic)MyoPoseType poseType;
@end

@interface MyoVector : NSObject
{
    float _data[3];
}
@property (nonatomic, readonly, getter=x)float x;
@property (nonatomic, readonly, getter=y)float y;
@property (nonatomic, readonly, getter=y)float z;
@property (nonatomic, readonly, getter=magnitude)float magnitude;

-(id)init;
-(id)initWithX:(float)x y:(float)y z:(float)z;
-(float)x;
-(float)y;
-(float)z;
-(float)magnitude;
-(float)productWithVector:(MyoVector*)rhs;
-(MyoVector*)normalized;
-(MyoVector*)crossProductWithVector:(MyoVector*)rhs;
-(float)angleWithVector:(MyoVector *)rhs;
@end

#pragma mark - MYODELEGATE
@protocol MyoDelegate <NSObject>
@optional
-(void)myoOnArmLost:(Myo*)myo;
-(void)myoOnArmRecognized:(Myo*)myo;
-(void)myoOnPair:(Myo*)myo;
-(void)myoOnConnect:(Myo*)myo;
-(void)myoOnDisconnect:(Myo*)myo;
-(void)myo:(Myo*)myo onPose:(MyoPose *)pose;
-(void)myo:(Myo*)myo onOrientationDataWithRoll:(int)roll pitch:(int)pitch yaw:(int)yaw;
-(void)myo:(Myo*)myo onAccelerometerDataWithVector:(float)vector;
-(void)myo:(Myo*)myo onGyroscopeDataWithVector:(float)vector;
-(void)myo:(Myo*)myo onRssi:(int8_t)rssi;
@end


#pragma mark - MyoVibrationType
typedef enum MyoVibrationType {
    MyoVibrationTypeShort = 0,
    MyoVibrationTypeMedium = 1,
    MyoVibrationTypeLong = 2
} MyoVibrationType;

#pragma mark - MYO
@interface Myo : NSObject
- (instancetype)initWithApplicationIdentifier:(NSString*)identifier;
-(BOOL)connectMyoWaiting:(int)milliseconds;
-(void)startUpdate;
-(void)stopUpdate;
-(void)vibrateWithType:(MyoVibrationType)type;

@property (nonatomic) int updateTime;
@property (nonatomic, assign) id<MyoDelegate> delegate;
@end
