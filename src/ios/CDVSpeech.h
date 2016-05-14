#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>

@interface CDVSpeech : CDVPlugin <AVSpeechSynthesizerDelegate>
{

}
@property (nonatomic, strong) NSString *currentCallbackId; //当前回调的ID
@property(nonatomic, assign) float _rate;   //语速
@property(nonatomic, assign) float _volume; //音量
@property(nonatomic, assign) float _pitchMultiplier;  //音调

-(void)play:(CDVInvokedUrlCommand*) command;

@end


