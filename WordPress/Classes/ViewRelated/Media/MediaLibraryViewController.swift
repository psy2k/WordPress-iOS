import UIKit
import Gridicons
import SVProgressHUD
import WordPressShared
import WPMediaPicker

/// Displays the user's media library in a grid
///
class MediaLibraryViewController: UIViewController {
    let blog: Blog

    fileprivate let pickerViewController: WPMediaPickerViewController
    fileprivate let pickerDataSource: MediaLibraryPickerDataSource

    fileprivate var selectedAsset: Media? = nil

    lazy fileprivate var searchBarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy fileprivate var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.hidesNavigationBarDuringPresentation = true
        controller.dimsBackgroundDuringPresentation = false

        WPStyleGuide.configureSearchBar(controller.searchBar)
        controller.searchBar.delegate = self
        controller.searchBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return controller
    }()

    var searchQuery: String? = nil

    // MARK: - Initializers

    init(blog: Blog) {
        self.blog = blog
        self.pickerViewController = WPMediaPickerViewController()
        self.pickerDataSource = MediaLibraryPickerDataSource(blog: blog)

        super.init(nibName: nil, bundle: nil)

        configurePickerViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        unregisterChangeObserver()
    }

    private func configurePickerViewController() {
        pickerViewController.mediaPickerDelegate = self
        pickerViewController.allowCaptureOfMedia = false
        pickerViewController.filter = .videoOrImage
        pickerViewController.allowMultipleSelection = false
        pickerViewController.showMostRecentFirst = true
        pickerViewController.dataSource = pickerDataSource
    }

    // MARK: - View Loading

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Media", comment: "Title for Media Library section of the app.")

        definesPresentationContext = true
        automaticallyAdjustsScrollViewInsets = false

        updateNavigationItemButtonsForEditingState()

        addMediaPickerAsChildViewController()
        addSearchBarContainer()
        addSearchBar()

        registerChangeObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let searchQuery = searchQuery,
            !searchQuery.isEmpty {

            // If we deleted the last asset, then clear the search
            if pickerDataSource.numberOfAssets() == 0 {
                clearSearch()
            } else {
                searchController.searchBar.text = searchQuery
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        selectedAsset = nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if searchController.isActive {
            searchQuery = searchController.searchBar.text
            searchController.isActive = false
        }
    }

    private func updateNavigationItemButtonsForEditingState() {
        if isEditing {
            navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editTapped)), animated: true)
            navigationItem.setRightBarButton(UIBarButtonItem(image: Gridicon.iconOfType(.trash), style: .plain, target: self, action: #selector(trashTapped)), animated: true)
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.setLeftBarButton(nil, animated: true)
            if blog.supports(.mediaDeletion) {
                navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped)), animated: true)
            } else {
                navigationItem.setRightBarButton(nil, animated: true)
            }
        }
    }

    private func addMediaPickerAsChildViewController() {
        pickerViewController.willMove(toParentViewController: self)
        view.addSubview(pickerViewController.view)
        pickerViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pickerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        addChildViewController(pickerViewController)
        pickerViewController.didMove(toParentViewController: self)
    }

    private func addSearchBarContainer() {
        view.addSubview(searchBarContainer)

        NSLayoutConstraint.activate([
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarContainer.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            searchBarContainer.bottomAnchor.constraint(equalTo: pickerViewController.view.topAnchor)
        ])

        let searchBarHeight = searchController.searchBar.bounds.height

        let heightConstraint = searchBarContainer.heightAnchor.constraint(equalToConstant: searchBarHeight)
        heightConstraint.priority = UILayoutPriorityDefaultLow
        heightConstraint.isActive = true

        let expandedHeightConstraint = searchBarContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: searchBarHeight)
        expandedHeightConstraint.priority = UILayoutPriorityRequired
        expandedHeightConstraint.isActive = true
    }

    private func addSearchBar() {
        searchBarContainer.layoutIfNeeded()

        searchBarContainer.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
    }

    // MARK: - Actions

    @objc private func editTapped() {
        isEditing = !isEditing

        pickerViewController.allowMultipleSelection = isEditing

        pickerViewController.clearSelectedAssets(true)
    }

    @objc private func trashTapped() {
        let message: String
        if pickerViewController.selectedAssets.count == 1 {
            message = NSLocalizedString("Are you sure you want to permanently delete this item?", comment: "Message prompting the user to confirm that they want to permanently delete a media item. Should match Calypso.")
        } else {
            message = NSLocalizedString("Are you sure you want to permanently delete these items?", comment: "Message prompting the user to confirm that they want to permanently delete a group of media items.")
        }

        let alertController = UIAlertController(title: nil,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addCancelActionWithTitle(NSLocalizedString("Cancel", comment: ""))
        alertController.addDestructiveActionWithTitle(NSLocalizedString("Delete", comment: "Title for button that permanently deletes one or more media items (photos / videos)"), handler: { action in
            self.deleteSelectedItems()
        })

        present(alertController, animated: true, completion: nil)
    }

    private func deleteSelectedItems() {
        guard pickerViewController.selectedAssets.count > 0 else { return }
        guard let assets = pickerViewController.selectedAssets.copy() as? [Media] else { return }

        let updateProgress = { (progress: Progress?) in
            let fractionCompleted = progress?.fractionCompleted ?? 0
            SVProgressHUD.showProgress(Float(fractionCompleted), status: NSLocalizedString("Deleting...", comment: "Text displayed in HUD while a media item is being deleted."))
        }

        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)

        // Initialize the progress HUD before we start
        updateProgress(nil)

        let service = MediaService(managedObjectContext: ContextManager.sharedInstance().mainContext)
        service.deleteMultipleMedia(assets,
                                    progress: updateProgress,
                                    success: { [weak self] in
                                        SVProgressHUD.showSuccess(withStatus: NSLocalizedString("Deleted!", comment: "Text displayed in HUD after successfully deleting a media item"))
                                        self?.isEditing = false
        }, failure: { error in
            SVProgressHUD.showError(withStatus: NSLocalizedString("Unable to delete all media items.", comment: "Text displayed in HUD if there was an error attempting to delete a group of media items."))
        })
    }

    override var isEditing: Bool {
        didSet {
            updateNavigationItemButtonsForEditingState()
        }
    }

    // MARK: - Media Library Change Observer

    private var mediaLibraryChangeObserverKey: NSObjectProtocol? = nil

    private func registerChangeObserver() {
        assert(mediaLibraryChangeObserverKey == nil)
        mediaLibraryChangeObserverKey = pickerDataSource.registerChangeObserverBlock({ [weak self] _, _, _, _, _ in
            guard let strongSelf = self else { return }

            strongSelf.updateNavigationItemButtonsForCurrentAssetSelection()

            // If we're presenting an item and it's been deleted, pop the
            // detail view off the stack
            if let navigationController = strongSelf.navigationController,
                navigationController.topViewController != strongSelf,
                let asset = strongSelf.selectedAsset,
                asset.isDeleted {
                _ = strongSelf.navigationController?.popToViewController(strongSelf, animated: true)
            }
        })
    }

    private func unregisterChangeObserver() {
        if let mediaLibraryChangeObserverKey = mediaLibraryChangeObserverKey {
            pickerDataSource.unregisterChangeObserver(mediaLibraryChangeObserverKey)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension MediaLibraryViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            pickerDataSource.searchQuery = searchController.searchBar.text
            pickerViewController.collectionView?.reloadData()
        }
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        clearSearch()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearch()
    }

    func clearSearch() {
        searchQuery = nil
        pickerDataSource.searchQuery = nil
        pickerViewController.collectionView?.reloadData()
    }
}

// MARK: - WPMediaPickerViewControllerDelegate

extension MediaLibraryViewController: WPMediaPickerViewControllerDelegate {
    func mediaPickerController(_ picker: WPMediaPickerViewController, didFinishPickingAssets assets: [Any]) {

    }

    func mediaPickerController(_ picker: WPMediaPickerViewController, previewViewControllerFor asset: WPMediaAsset) -> UIViewController? {
        return mediaItemViewController(for: asset)
    }

    func mediaPickerController(_ picker: WPMediaPickerViewController, shouldSelect asset: WPMediaAsset) -> Bool {
        if isEditing { return true }

        if let viewController = mediaItemViewController(for: asset) {
            navigationController?.pushViewController(viewController, animated: true)
        }

        return false
    }

    func mediaPickerController(_ picker: WPMediaPickerViewController, didSelect asset: WPMediaAsset) {
        updateNavigationItemButtonsForCurrentAssetSelection()
    }

    func mediaPickerController(_ picker: WPMediaPickerViewController, didDeselect asset: WPMediaAsset) {
        updateNavigationItemButtonsForCurrentAssetSelection()
    }

    func updateNavigationItemButtonsForCurrentAssetSelection() {
        if isEditing {
            // Check that our selected items haven't been deleted – we're notified
            // of changes to the data source before the collection view has
            // updated its selected assets.
            guard let assets = (pickerViewController.selectedAssets.copy() as? [Media]) else { return }
            let existingAssets = assets.filter({ !$0.isDeleted })

            navigationItem.rightBarButtonItem?.isEnabled = (existingAssets.count > 0)
        }
    }

    private func mediaItemViewController(for asset: WPMediaAsset) -> UIViewController? {
        if isEditing { return nil }

        guard let asset = asset as? Media else {
            return nil
        }

        selectedAsset = asset

        return MediaItemViewController(media: asset, dataSource: pickerDataSource)
    }
}
