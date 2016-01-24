import Foundation
import XCTest
@testable import WordPress

class SiteManagementServiceTests : XCTestCase
{
    let contextManager = TestContextManager()
    var mockRemoteService: MockSiteManagementServiceRemote!
    var siteManagementService: SiteManagementServiceTester!
    
    class MockSiteManagementServiceRemote : SiteManagementServiceRemote
    {
        var deleteSiteCalled = false
        var successBlockPassedIn:(() -> Void)?
        var failureBlockPassedIn:((NSError) -> Void)?
        
        override func deleteSite(siteID: NSNumber, success: (() -> Void)?, failure: (NSError -> Void)?) {
            deleteSiteCalled = true
            successBlockPassedIn = success
            failureBlockPassedIn = failure
        }
        
        func reset() {
            deleteSiteCalled = false
            successBlockPassedIn = nil
            failureBlockPassedIn = nil
        }
    }
    
    class SiteManagementServiceTester : SiteManagementService
    {
        let mockRemoteApi = MockWordPressComApi()
        lazy var mockRemoteService: MockSiteManagementServiceRemote = {
            return MockSiteManagementServiceRemote(api: self.mockRemoteApi)
        }()
        
        override func siteManagementServiceRemoteForBlog(blog: Blog) -> SiteManagementServiceRemote {
            return mockRemoteService
        }
    }
    
    override func setUp() {
        super.setUp()
  
        siteManagementService = SiteManagementServiceTester(managedObjectContext: contextManager.mainContext)
        mockRemoteService = siteManagementService.mockRemoteService
    }
    
    func insertBlog(context: NSManagedObjectContext) -> Blog {
        let blog = NSEntityDescription.insertNewObjectForEntityForName("Blog", inManagedObjectContext: context) as! Blog
        blog.xmlrpc = "http://mock.blog/xmlrpc.php"
        blog.url = "http://mock.blog/"
        blog.dotComID = 999999

        try! context.obtainPermanentIDsForObjects([blog])
        try! context.save()

        return blog
    }
 
    func testDeleteSiteCallsServiceRemoteDeleteSite() {
        let context = contextManager.mainContext
        let blog = insertBlog(context)
        
        mockRemoteService.reset()
        siteManagementService.deleteSiteForBlog(blog, success: nil, failure: nil)
        XCTAssertTrue(mockRemoteService.deleteSiteCalled, "Remote DeleteSite should have been called")
    }
    
    func testDeleteSiteCallsSuccessBlock() {
        let context = contextManager.mainContext
        let blog = insertBlog(context)
        
        let expectation = expectationWithDescription("Delete Site success expectation")
        mockRemoteService.reset()
        siteManagementService.deleteSiteForBlog(blog,
            success: {
                expectation.fulfill()
            }, failure: nil)
        mockRemoteService.successBlockPassedIn?()
        waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    func testDeleteSiteRemovesExistingBlogOnSuccess() {
        let context = contextManager.mainContext
        let blog = insertBlog(context)
        let blogObjectID = blog.objectID
        
        XCTAssertFalse(blogObjectID.temporaryID, "Should be a permanent object")
        
        let expectation = expectationWithDescription(
            "Remove Blog success expectation")
        mockRemoteService.reset()
        siteManagementService.deleteSiteForBlog(blog,
            success: {
                expectation.fulfill()
            }, failure: nil)
        mockRemoteService.successBlockPassedIn?()
        waitForExpectationsWithTimeout(2, handler: nil)
        
        let shouldBeRemoved = try? context.existingObjectWithID(blogObjectID)
        XCTAssertNil(shouldBeRemoved, "Blog was not removed")
    }
    
    func testDeleteSiteCallsFailureBlock() {
        let context = contextManager.mainContext
        let blog = insertBlog(context)
        
        let testError = NSError(domain:"UnitTest", code:0, userInfo:nil)
        let expectation = expectationWithDescription("Delete Site failure expectation")
        mockRemoteService.reset()
        siteManagementService.deleteSiteForBlog(blog,
            success: nil,
            failure: { error in
                XCTAssertEqual(error, testError, "Error not propagated")
                expectation.fulfill()
            })
        mockRemoteService.failureBlockPassedIn?(testError)
        waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    func testDeleteSiteDoesNotRemoveExistingBlogOnFailure() {
        let context = contextManager.mainContext
        let blog = insertBlog(context)
        let blogObjectID = blog.objectID
        
        XCTAssertFalse(blogObjectID.temporaryID, "Should be a permanent object")
        
        let testError = NSError(domain:"UnitTest", code:0, userInfo:nil)
        let expectation = expectationWithDescription(
            "Remove Blog success expectation")
        mockRemoteService.reset()
        siteManagementService.deleteSiteForBlog(blog,
            success: nil,
            failure: { error in
                XCTAssertEqual(error, testError, "Error not propagated")
                expectation.fulfill()
            })
        mockRemoteService.failureBlockPassedIn?(testError)
        waitForExpectationsWithTimeout(2, handler: nil)
        
        let shouldNotBeRemoved = try? context.existingObjectWithID(blogObjectID)
        XCTAssertNotNil(shouldNotBeRemoved, "Blog was removed")
    }
}
