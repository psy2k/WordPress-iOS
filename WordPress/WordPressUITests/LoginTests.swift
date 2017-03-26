import XCTest

class LoginTests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        XCUIApplication().launch()
        app = XCUIApplication()

        // Logout first if needed
        logoutIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        logoutIfNeeded()
        super.tearDown()
    }

    func testSimpleLogin() {
        simpleLogin(username: WordPressTestCredentials.oneStepUser, password: WordPressTestCredentials.oneStepPassword)

        waitForElementToAppear(element: app.tabBars[ elementStringIDs.mainNavigationBar ])
    }

    func testUnsuccessfulLogin() {
        simpleLogin(username: WordPressTestCredentials.oneStepUser, password: "password")

        waitForElementToAppear(element: app.images[ "icon-alert" ])
        app.buttons.element(boundBy: 1).tap()
    }

    func testSelfHostedLoginWithoutJetPack() {
        loginSelfHosted(username: WordPressTestCredentials.selfHostedUser, password: WordPressTestCredentials.selfHostedPassword, url: WordPressTestCredentials.selfHostedSiteURL)

        waitForElementToAppear(element: app.tabBars[ elementStringIDs.mainNavigationBar ], timeout: 10)

        logoutSelfHosted()
    }

    func testCreateAccount() {
        let username = "\(WordPressTestCredentials.oneStepUser)\(arc4random())"
        app.buttons["Create Account"].tap()

        let emailAddressField = app.textFields["Email Address"]
        emailAddressField.tap()
        emailAddressField.typeText("\(username)@gmail.com")

        let usernameField = app.textFields["Username"]
        usernameField.tap()
        usernameField.typeText(username)

        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText(WordPressTestCredentials.oneStepPassword)
    }
}
