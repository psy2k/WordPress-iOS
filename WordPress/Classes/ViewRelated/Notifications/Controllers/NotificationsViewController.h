#import <UIKit/UIKit.h>



/**
 *  @class      NotificationsViewController
 *  @brief      The purpose of this class is to render the collection of Notifications, associated to the main
 *              WordPress.com account found in the system.
 *  @details    This class relies on both, Simperium and WPTableViewHandler to automatically receive
 *              new Notifications that might be generated, and render them onscreen.
 *              Plus, we provide a simple mechanism to render the details for a specific Notification,
 *              given its remote identifier. This is specially useful when dealing with events derived from
 *              interactions with Push Notifications OS banners.
 */

@interface NotificationsViewController : UITableViewController

/**
 *  @brief      This instance will push the Details View associated with a given Notification ID.
 *  @details    If the Notification is unavailable at the point in which this call is executed, we'll hold for
 *              the time interval specified by the `NotificationsSyncTimeout` constant.
 *              Whenever the notification is sync'ed, if the timeout hasn't yet elapsed, we'll proceed pushing
 *              the details view. Otherwise, the event will be discarded.
 *
 *  @param      notificationID      The simperiumKey of the Notification that should be rendered onscreen.
 */

- (void)showDetailsForNoteWithID:(NSString *)notificationID;

@end
