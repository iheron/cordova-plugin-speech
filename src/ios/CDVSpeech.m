#import "CDVSpeech.h"

@implementation CDVSpeech

NSString * const CONST_EVENT = @"event";
NSString * const CONST_CODE = @"code";
NSString * const CONST_MESSAGE = @"message";
NSString * const CONST_VOLUME = @"volume";
NSString * const CONST_RESULTS = @"results";
NSString * const CONST_PROGRESS = @"progress";

AVSpeechSynthesizer * _speaker;
AVSpeechSynthesisVoice * _voice;
AVSpeechUtterance * _utterance;

// 自动生成setter、getter
@synthesize _volume;
@synthesize _rate;
@synthesize _pitchMultiplier;

- (void)pluginInitialize
{
    self._volume = 1.0;
    self._rate = 0.5;
    self._pitchMultiplier = 0.8;
    _speaker = [[AVSpeechSynthesizer alloc] init]; //AVSpeechSynthesizer.alloc().init()
    _voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-TW"]; //设置语言 AVSpeechSynthesisVoice.voiceWithLanguage("zh-TW")
    _speaker.delegate = self;
}

- (void)fireEvent:(NSString*)event
{
    if (self.currentCallbackId) {
        NSDictionary* info = [NSDictionary dictionaryWithObject:event forKey:CONST_EVENT];
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
        [result setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:result callbackId:self.currentCallbackId];
    }
}


// 播放声音
- (void)play:(CDVInvokedUrlCommand*) command;
{
    // save the callback id
    self.currentCallbackId = command.callbackId;
    
    // 获取html传过来的message值
    NSDictionary *params = [command.arguments objectAtIndex:0];
    if (!params)
    {
        [self failWithCallbackID:command.callbackId withMessage:@"参数格式错误"];
        return ;
    }
    
    NSDictionary *text = [params objectForKey:@"text"];
    if(text) // [a b] a.b()
    {
        _utterance = [[AVSpeechUtterance alloc] initWithString:text];//设置要朗读的字符串
        _utterance.voice = _voice;
        _utterance.volume = (float)[[params objectForKey:@"volume"] floatValue]; //设置音量（0.0~1.0）默认为1.0
        _utterance.rate = (float)[[params objectForKey:@"rate"] floatValue];  //设置语速
        _utterance.pitchMultiplier = self._pitchMultiplier;  //设置语调
        [_speaker speakUtterance:_utterance];
    }
}

- (void)cancel:(CDVInvokedUrlCommand*) command;
{
    if (_speaker.isSpeaking)
    {
        [_speaker stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [self fireEvent:@"onStart"];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [self fireEvent:@"onStop"];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{

}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{

}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{

}

- (void)successWithCallbackID:(NSString *)callbackID
{
    [self successWithCallbackID:callbackID withMessage:@"OK"];
}

- (void)successWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

- (void)failWithCallbackID:(NSString *)callbackID withError:(NSError *)error
{
    [self failWithCallbackID:callbackID withMessage:[error localizedDescription]];
}

- (void)failWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

@end