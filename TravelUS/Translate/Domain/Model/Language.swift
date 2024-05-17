//
//  Language.swift
//  TravelUS
//
//  Created by Hugues Fils on 10/05/2024.
//

enum Language: String, CaseIterable, Identifiable {
  case french = "fr"
  case english = "en"
  var id: Self { self }
}
