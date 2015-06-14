//
//  ViewController.m
//  Drawing
//
//  Created by MAEDA HAJIME on 2015/06/14.
//  Copyright (c) 2014年 MAEDA HAJIME. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    // タッチ座標（始点、終点）
    CGPoint _posFrom;
    CGPoint _posTo;
    
}

// キャンバス
@property (weak, nonatomic) IBOutlet UIImageView *ivCanvus;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 画面タッチ時
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
    
    // タッチ座標（始点）を保存
    _posFrom = [[touches anyObject] locationInView:self.ivCanvus];
    //NSLog(@"%@", NSStringFromCGPoint(_posFrom));
    
}

// 画面ドラッグ
- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event {
    
    // タッチ座標（終点）を保存
    _posTo = [[touches anyObject] locationInView:self.ivCanvus];
    //NSLog(@"%@", NSStringFromCGPoint(_posTo));
    
    // オフスクリーン（画面外の描画領域）の作成
    UIGraphicsBeginImageContext(self.ivCanvus.frame.size);
    [self.ivCanvus.image drawInRect:self.ivCanvus.frame];
    
    // 線描画
    {
        // グラフィックコンテキスト
        CGContextRef ct = UIGraphicsGetCurrentContext();
        
        // 設定（線スタイル（太さ））
        CGFloat penWidth = (CGFloat)5.0;
        CGContextSetLineWidth(ct, penWidth);
        
        // 設定（線スタイル（色））
        UIColor *penColor = [UIColor blueColor];
        CGContextSetStrokeColorWithColor(ct, penColor.CGColor);
        
        // 設定（線端の形状：線を丸める）
        CGLineCap penCap = kCGLineCapRound;
        CGContextSetLineCap(ct, penCap);
        
        // 設定（線（始点、終点））;
        CGContextMoveToPoint(ct, _posFrom.x, _posFrom.y);
        CGContextAddLineToPoint(ct, _posTo.x, _posTo.y);
        
        CGContextStrokePath(ct);
        
    }
    
    // オフスクリーン内容を反映
    self.ivCanvus.image =
        UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // タッチ座標（始点）を再設定
    _posFrom = _posTo;
    
}

// ファーストレスポンダ化可能の設定（シェイク検知に必要）
- (BOOL)canBecomeFirstResponder {
    
    return YES;

}

// モーション終了時
- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event {
    
    // シェイクの判定
    if (event.type == UIEventTypeMotion &&
        motion == UIEventSubtypeMotionShake) {
        
//        {
//        // フォトアルバム保存
//        SEL cmp = @selector(image:didFinishSavingWithError:contextInfo:);
//        UIImageWriteToSavedPhotosAlbum(self.ivCanvus.image,
//                                       self,
//                                       cmp,
//                                       nil);
//        }
        
        // ファイルに保存　サンドボックス ドキュメントフォルダー
        {
            
            NSString *pth01 = (NSString *)
            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, // ドキュメントディレクトリー
                                                            NSUserDomainMask, // User
                                                            YES) lastObject];
            NSString *pth02 = [pth01 stringByAppendingPathComponent:@"Image01.png"];
        
            NSData *dat = UIImagePNGRepresentation(self.ivCanvus.image);
            [dat writeToFile:pth02 atomically:YES];
        
            
            //NSLog(@"%@", pth01); // ドキュメントフォルダー先
            // /Users/hajime/Library/Application Support/iPhone Simulator/7.1/Applications/6AB95173-64CA-45EC-B727-9D468413F329/Library/Documentation
            // Drawingを右クリックの中にアプリが存在する
            // /Users/hajime/Library/Application Support/iPhone Simulator/7.1/Applications/6AB95173-64CA-45EC-B727-9D468413F329/
        
            NSLog(@"%@", pth02); // ドキュメントフォルダー先
            // /Users/hajime/Library/Application Support/iPhone Simulator/7.1/Applications/6AB95173-64CA-45EC-B727-9D468413F329/Library/Documentation/Image01.png
        }
    }
}

- (void) image:(UIImage *)image
            didFinishSavingWithError:(NSError *)error
                         contextInfo:(void *)contextInfo {
     // エラー判定
//    if (!error) {
//        NSLog(@"保存完了");
//    } else {
//        NSLog(@"保存エラー");
//    }
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"確認" message:@"保存完了"
                              delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];
}

// 画面クリア
- (IBAction)ClearAction:(id)sender {
    
    // 画面をクリアします。
    self.ivCanvus.image = nil;

}

@end
