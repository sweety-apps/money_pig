/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

@class _SDWebImageManager;
@class UIImage;

@protocol SDWebImageManagerDelegate <NSObject>

@optional

- (void)webImageManager:(_SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image;
- (void)webImageManager:(_SDWebImageManager *)imageManager didFailWithError:(NSError *)error;

@end
