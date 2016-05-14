# cordova-plugin-baidutts
### 没时间解释了

# 操作步骤
```
1. 下载这个包到本地
2. 安装插件 cordova plugin add /目录/cordova-plugin-speech
```

# 使用
```
// 播放声音 volume 0-1,rate 0-1
Speech.play({ text: text, volume: volumeVal, rate: rateVal });
// 监听开始事件
Speech.onStart(function(){//do});
// 监听结束事件
Speech.onStop(function(){//do});
// 停止播放
Speech.cancel();
```
