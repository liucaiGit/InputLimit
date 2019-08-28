##  UITextView UITextField限制输入字数以及精准剩余字数显示
在日常项目开发中，我们经常用到UITextView UITextField这两个控件，今天我们来讲讲如何方便简单的限制这两个控件的输入字数以及精准显示剩余字数。

之前在项目中遇到了UITextView的限制输入以及剩余字数显示，因为项目比较老，也有写好的限制输入功能，但是当这两种功能需要同时实现时，需要在原来的基础上添加很多重复的代码，刚好最近也闲下来了，就准备自己动手写写。

首先我们先拿UITextView来说吧，UITextView主要用于多行文本的输入，为了限制它的输入字数，我使用的方法是自定义一个textView，自定义的textView自身实现UITextViewDelegate方法，子类的属性有以下几个：

```
@property (nonatomic, assign) NSInteger tvLimitNumber;//最大输入字数

@property (nonatomic, assign, getter=isForbidSystemEmoji) BOOL shouldForbidSystemEmoji;//是否禁止系统表情输入

@property (nonatomic, assign) BOOL returnKeyDone;//return键点击效果是否完成输入

@property (nonatomic, weak) id<BWTextViewDelegate> tvDelegate;//自定义代理方法
```
为了实现限制输入字数，所用到的主要是以下两个代理方法：

```
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)textViewDidChange:(UITextView *)textView;
```
第一个代理方法可以实时的获取到当前输入的每一个字符，并且控制是否将输入的字符加入到最后的字符串中，我们在代理方法中实现以下内容来限制输入的字符是否加入到最后的字符串中：

```
//最大限制数量小于0 则不做限制数量限制
    if (self.tvLimitNumber <= 0) {
        return YES;
    }
    //获取高亮部分
    UITextRange *markedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:markedRange.start offset:0];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (markedRange && position) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:markedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:markedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < self.tvLimitNumber) {
            return YES;
        } else {
            return NO;
        }
    }
```
在第二个代理方法中，我们需要实现的是判断textView中的文本是否超过限制字数，如果超出则截取出子串并赋值给textView.text，实现文本的限制:
    
```
//若限制数量小于等于0 则不对输入做限制
    if (self.tvLimitNumber <= 0) {
        //执行自定义代理方法
        [self textViewValueDidChanged:textView];
        return;
    }
    NSString *lang = [[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    //获取高亮部分
    UITextRange *range = [textView markedTextRange];
    UITextPosition *start = range.start;
    UITextPosition*end = range.end;
    NSInteger selectLength = [textView offsetFromPosition:start toPosition:end];
    //存在高亮则不计算高度
    if (range && selectLength) {
        return;
    }
    if ([lang isEqualToString:@"zh-Hans"]) {
        NSInteger contentLength = textView.text.length - selectLength;
        if (contentLength >= self.tvLimitNumber) {
            textView.text = [textView.text substringToIndex:self.tvLimitNumber];
            //文字数量超出最大限制数量
        }
    } else {
        if (textView.text.length >= self.tvLimitNumber) {
            textView.text = [textView.text substringToIndex:self.tvLimitNumber];
            //文字数量超出最大限制数量
        }
    }
    //执行自定义代理方法
    [self textViewValueDidChanged:textView];
```
为了让在外部也能实现UITextView的代理方法，自定义的textView添加一个协议，协议的大致内容都是UITextViewDelegate中的内容，这样就不用担心无法在外部不能自定义一些操作了，自定义的代理方法主要有以下几种：

```
- (void)bwTextViewDidChanged:(UITextView *)textView;

 - (BOOL)bwTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

 - (BOOL)bwTextViewShouldBeginEditing:(UITextView *)textView;

 - (BOOL)bwTextViewShouldEndEditing:(UITextView *)textView;

 - (void)bwTextViewDidBeginEditing:(UITextView *)textView;

 - (void)bwTextViewDidEndEditing:(UITextView *)textView;
```
接下来讲讲UITextField，实现的原理是一样的，不过UITextFieldDelegate中并没有暴露出类似UITextView:- (void)textViewDidChange:(UITextView *)textView这样的方法，为了实现类似的功能，我在自定义的UITextField中添加了UITextField内容变化的事件，并在监听方法中实现截取子串的操作，这里将通知注释掉是因为在实际开发中，前一个页面如果也使用了BWTextField，而通知又是一对多的形式，会造成两个BWTextField互相错乱：
    

```
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.shouldForbidSystemEmoji = YES;
        self.returnKeyDone = YES;
        //添加通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
        [self addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
```
```
- (void)textFieldDidChanged {
    //若限制数量小于等于0 则不对输入做限制
    if (self.tfLimitNumber <= 0) {
        //执行自定义代理方法
        [self bwTextFieldDidChanged:self];
        return;
    }
    NSString *lang = [[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    //获取高亮部分
    UITextRange *range = [self markedTextRange];
    UITextPosition *start = range.start;
    UITextPosition*end = range.end;
    NSInteger selectLength = [self offsetFromPosition:start toPosition:end];
    //存在高亮则不计算高度
    if (range && selectLength) {
        return;
    }
    if ([lang isEqualToString:@"zh-Hans"]) {
        NSInteger contentLength = self.text.length - selectLength;
        if (contentLength >= self.tfLimitNumber) {
            self.text = [self.text substringToIndex:self.tfLimitNumber];
            //文字数量超出最大限制数量
        }
    } else {
        if (self.text.length >= self.tfLimitNumber) {
            self.text = [self.text substringToIndex:self.tfLimitNumber];
            //文字数量超出最大限制数量
        }
    }
    //执行自定义代理方法
    [self bwTextFieldDidChanged:self];
}
```
以上就是自定义UITextView UITextField实现限制输入字数以及精准获取剩余字数的功能，实现这类功能只需要初始化时设定需要限制的字数即可，减少了重复实现代理方法的代码，大大的增加了代码的美观以及封装性。

[代码请戳这里](https://github.com/liucaiGit/InputLimit)





