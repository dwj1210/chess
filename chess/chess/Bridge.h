//
//  Bridge.h
//  chess
//
//  Created by dwj1210 on 2022/7/20.
//

#ifndef Bridge_h
#define Bridge_h

#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

static __attribute__((always_inline)) void AntiDebug() {
#ifdef __arm64__
        asm volatile("mov x4, x0\n"
                     "mov X0, #31\n"
                     "mov X1, #0\n"
                     "mov X2, #0\n"
                     "mov X3, #0\n"
                     "mov w16, #26\n"
                     "svc #0x80\n"
                     "mov x0, x4\n");
#endif
}

@interface WebScriptObject: NSObject
@end

@interface WebView
- (WebScriptObject *)windowScriptObject;
@end

@interface UIWebDocumentView: UIView
- (WebView *)webView;
@end

#endif /* Bridge_h */
