//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
//var any = Any(str)
//any.text
let playerDefaultTiles = ["a":0,"b":0]

//playerDefaultTiles["a"]! <= 0 && playerDefaultTiles["b"]! <= 0
let out = !(playerDefaultTiles["a"]! <= 0 && playerDefaultTiles["b"]! <= 0)
print("phase one is \(out) blue left = \( playerDefaultTiles["a"]!)  red left = \( playerDefaultTiles["b"]!)")