#import <UIKit/UIKit.h>



@class Notification;

typedef void (^NotificationDetailsDeletionCompletionBlock)(BOOL success);
typedef void (^NotificationDetailsDeletionActionBlock)(NotificationDetailsDeletionCompletionBlock onCompletion);
typedef void (^NotificationDetailsDeletionRequestBlock)(NotificationDetailsDeletionActionBlock onUndoTimeout);



/**
 *  @class      NotificationDetailsViewController
 *  @brief      This class will render a given Notification entity, onscreen.
 *  @details    Whenever the Notification is remotely updated, this class will automatically take care of
 *              refreshing the User Interface for you.
 */

@interface NotificationDetailsViewController : UIViewController <UIViewControllerRestoration>

/**
 *  @brief      Whenever the user performs a destructive action, the Deletion Request Callback will be called,
 *              and a closure that will effectively perform the deletion action will be passed over.
 *              In turn, the Deletion Action block also expects (yet another) block as a parameter, to be called
 *              in the eventuallity of a failure.
 *  @details    This mechanism has been implemented so that the presenter ViewController can allow the user to
 *              undo the destructive action, before it's effectively executed.
 */

@property (nonatomic, copy) NotificationDetailsDeletionRequestBlock onDeletionRequestCallback;

/**
 *	@brief		This method renders the details view, for any given notification/
 *  @details    You should only call this method once. It will take care of attaching any required subviews,
 *              in order to properly render the Notification's details.
 *
 *	@param		notification    The Notification to display.
 */

- (void)setupWithNotification:(Notification *)notification;

@end
