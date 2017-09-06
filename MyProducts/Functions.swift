//
//  Functions.swift
//  MyProducts
//
//  Created by Jack Ily on 06/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import Foundation

func documentDirectory() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
}
