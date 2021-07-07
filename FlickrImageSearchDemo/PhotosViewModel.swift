//
//  PhotosViewModel.swift
//  FlickrImageSearchDemo
//
//  Created by Parth on 06/07/21.
//

import Foundation
import FlickrAPIClient

class PhotosViewModel {

    var photos = [Photo]()
    
    var currentPage = 1
    var totalPages: Int64 = 0

    //TODO: Though it is static for now in code, to be optimised in future to take user input by adding search capacity
    let searchTerm = "river"

    let screenTitle = "Flickr Photos"

    func reloadMoreData(completed: () -> Void) {
        if let photosModel = FlickrPhotosSearchClient().getPhotos(searchText: searchTerm, page: currentPage), photosModel.error == nil {
            totalPages = photosModel.photos?.pages ?? 0
            if currentPage > totalPages {
                completed()
                //TODO: Add alert view or way to notify user that there are no more photos for this search term
            }
            else{
                photos.append(contentsOf: photosModel.photos?.photo ?? [Photo]())
                completed()
            }
            currentPage = currentPage + 1
        }
    }
}
