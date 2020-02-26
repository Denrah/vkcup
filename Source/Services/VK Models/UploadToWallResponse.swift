//
//  UploadToWallResponse.swift
//  VKCup
//

import Foundation

struct UploadToWallResponse: Codable {
  let fileID: Int?
  
  enum CodingKeys: String, CodingKey {
    case fileID = "id"
  }
}
