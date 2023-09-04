//
//  Leg.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/31/23.
//

import Foundation


final class Leg {
    var r: Vector = .init(x: 0, y: 0, z: 0)
    var servoPin: Vector = .init(x: 0, y: 0, z: 0)
    var target: Vector = .init(x: 270.3, y: 0, z: 0)
    var radius: Float = 0
    
    var roll: Float = 0
    var pitch: Float = 0
    var yaw: Float = 0
    
    init(r: Vector, servoPin: Vector, target: Vector, radius: Float, roll: Float, pitch: Float, yaw: Float) {
        self.r = r
        self.servoPin = servoPin
        self.target = target
        self.radius = radius
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
    
    init(r: Vector, servoPin: Vector) {
        self.r = r
        self.servoPin = servoPin
    }
    
    func CalcIK() {
        
        let l1: Float = sqrt(pow(target.x , 2) + pow(target.z , 2)) - self.r.x
        let l2: Float = target.z
        let l3: Float = sqrt(pow(l1 , 2) + pow(l2 , 2))
        
        let phi1: Float = acos((pow(self.r.y , 2) + pow(l3 , 2) - pow(self.r.z , 2)) / (2 * self.r.y * l3))
        let phi2: Float = atan2(l2, l1)
        let phi3: Float = acos((pow(self.r.z , 2) + pow(self.r.y , 2) - pow(l3 , 2)) / (2 * self.r.z * self.r.y))
        
        var theta1: Float = atan2(target.y, target.x)
        var theta2: Float = (phi1 + phi2)
        var theta3: Float = (Float.pi - phi3 - (Float.pi / 6))
        
        
        if (theta1.isNaN || theta2.isNaN || theta2.isNaN)
        {
            //             Serial.println("NaN ERROR HAHA");
            return
        }
        
        theta1 = (theta1 * (400 / Float.pi)) + 230
        theta2 = -(theta2 * (400 / Float.pi)) + 230
        theta3 = -(theta3 * (400 / Float.pi)) + 230
        
        rotateJoint(servoPin.x, theta1)
        rotateJoint(servoPin.y, theta2)
        rotateJoint(servoPin.z, theta3)
        
    }
    
    func rotateJoint(_ pin: Float, _ angle: Float) {
        if (angle < 30) {
            //            Serial.println("angle not reaching full potential");
        }
        //        let newAngle = constrain(angle, 30, 450);
        
        if (pin < 16) {
            //            pwmA.Servo(pin, angle);
        } else {
            //            pwmB.Servo(pin-16, angle);
        }
        //        delay(10);
    }
    
    func lerp(_ pos: inout Vector, _ t: Float, _ start: Vector, _ finish: Vector) {
        
        /*
         * offset: if true then an offset will be applied
         * dir: if equal to 1 then direction is positive, if equal to 0 then diection is negative
         */
        let px = start.x + t * (finish.x - start.x)
        let py = start.y + t * (finish.y - start.y)
        let pz = start.z + t * (finish.z - start.z)
        
        pos = .init(x: px, y: py, z: pz)
    }
    
    static func calibrateLeg(leg: Leg) {
        let len = leg.r.x + leg.r.y + leg.r.z
        
        leg.target.x = len - 0.01  // if its just len then the IK will throw a nan error as
        leg.target.y = 0
        leg.target.z = 0
        
        leg.CalcIK();
    }
    
    func cubicBezier( pos: inout Vector, t: Float, start: Vector, controlA: Vector, controlB: Vector, finish: Vector) {
        /*
         * offset: if true then an offset will be applied
         * dir: if equal to 1 then direction is positive, if equal to 0 then diection is negative
         */
        var start_to_controlA: Vector = .init(x: 0, y: 0, z: 0)
        lerp(&start_to_controlA, t, start, controlA)
        
        var controlA_to_controlB: Vector = .init(x: 0, y: 0, z: 0)
        lerp(&controlA_to_controlB, t, controlA, controlB);
        
        var controlB_to_finish: Vector = .init(x: 0, y: 0, z: 0)
        lerp(&controlB_to_finish, t, controlB, finish);
        
        var interpolatorA: Vector = .init(x: 0, y: 0, z: 0)
        lerp(&interpolatorA, t, start_to_controlA, controlA_to_controlB);
        
        var interpolatorB: Vector = .init(x: 0, y: 0, z: 0)
        lerp(&interpolatorB, t, controlA_to_controlB, controlB_to_finish);
        
        lerp(&pos, t, interpolatorA, interpolatorB);
    }
    
    func updateHyperParameters(bot: Robot, l1: inout Leg, l2: inout Leg, l3: inout Leg, l4: inout Leg, l5: inout Leg, l6: inout Leg) {
        if (bot.radius != l1.radius)
          {
            l1.radius = bot.radius;
            l2.radius = bot.radius;
            l3.radius = bot.radius;
            l4.radius = bot.radius;
            l5.radius = bot.radius;
            l6.radius = bot.radius;
          }
          if (bot.roll != l1.roll)
          {
            l1.roll = bot.roll;
            l2.roll = bot.roll;
            l3.roll = bot.roll;
            l4.roll = bot.roll;
            l5.roll = bot.roll;
            l6.roll = bot.roll;
          }
          if (bot.pitch != l1.pitch)
          {
            l1.pitch = bot.pitch;
            l2.pitch = bot.pitch;
            l3.pitch = bot.pitch;
            l4.pitch = bot.pitch;
            l5.pitch = bot.pitch;
            l6.pitch = bot.pitch;
          }
          if (bot.yaw != l1.yaw)
          {
            l1.yaw = bot.yaw;
            l2.yaw = bot.yaw;
            l3.yaw = bot.yaw;
            l4.yaw = bot.yaw;
            l5.yaw = bot.yaw;
            l6.yaw = bot.yaw;
          }
    }
}
