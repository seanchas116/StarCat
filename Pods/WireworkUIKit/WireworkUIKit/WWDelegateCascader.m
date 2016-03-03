#import "WWDelegateCascader.h"

@implementation WWDelegateCascader

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = anInvocation.selector;
    if (_first && [_first respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:_first];
    }
    if (_second && [_second respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:_second];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (_first && [_first respondsToSelector:aSelector]) {
        return YES;
    }
    if (_second && [_second respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [_first methodSignatureForSelector:selector];
    }
    if (!signature) {
        signature = [_second methodSignatureForSelector:selector];
    }
    return signature;
}

@end
