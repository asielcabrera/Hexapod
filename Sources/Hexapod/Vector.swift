//
//  Vector.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/31/23.
//

import Foundation

final class Vector {
    var x: Float
    var y: Float
    var z: Float
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func rotatePoint(point: Vector, pivot: Vector, thetaRad: Float) -> Vector {
        let px: Float = (point.x - pivot.x) * cosf(thetaRad) - (point.y - pivot.y) * sinf(thetaRad) + pivot.x
        let py: Float = (point.x - pivot.x) * sinf(thetaRad) + (point.y - pivot.y) * cosf(thetaRad) + pivot.y
        let pz: Float = point.y
        
        return  .init(x: px, y: py, z: pz)
    }
    
    func meanO(_ point1: Vector, _ point2: Vector) -> Vector {
        let px: Float = (point1.x + point2.x) / 2
        let py: Float = (point1.y + point2.y) / 2
        let pz: Float = (point1.z + point2.z) / 2
       
        return  .init(x: px, y: py, z: pz)
    }
}
