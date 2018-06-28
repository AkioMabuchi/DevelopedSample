//
//  Opponent.swift
//  Marubatsu
//
//  Created by 馬渕明雄 on 2018/06/09.
//  Copyright © 2018年 Akio Mabuchi. All rights reserved.
//

import Foundation

//このクラスはインスタンスを生成しないので、インスタンス変数やインスタンスメソッドはない。
class Opponent{
    private static var encode:[Int] = [0,1,2,3,4,5,6,7,8,9]
    private static var decode:[Int] = [0,1,2,3,4,5,6,7,8,9]
    private static var board:[Int] = [0,0,0,0,0,0,0,0,0,0]
    private static var count:Int = 0
    
    class func initialize(){
        let temporaryEncode:[ArraySlice<Int>] = [[1,2,3,4,5,6,7,8,9],[1,4,7,2,5,8,3,6,9],[7,4,1,8,5,2,9,6,3],[3,2,1,6,5,4,9,8,7],[9,8,7,6,5,4,3,2,1],[9,6,3,8,5,2,7,4,1],[3,6,9,2,5,8,1,4,7],[7,8,9,4,5,6,1,2,3]]
        let temporaryDecode:[ArraySlice<Int>] = [[1,2,3,4,5,6,7,8,9],[1,4,7,2,5,8,3,6,9],[3,6,9,2,5,8,1,4,7],[3,2,1,6,5,4,9,8,7],[9,8,7,6,5,4,3,2,1],[9,6,3,8,5,2,7,4,1],[7,4,1,8,5,2,9,6,3],[7,8,9,4,5,6,1,2,3]]
        let rand:Int = Int(arc4random_uniform(8))
        
        encode[1...9] = temporaryEncode[rand]
        decode[1...9] = temporaryDecode[rand]
    }
    
    class func setBoard(_ s:ArraySlice<Int>){
        let temporaryBoard:ArraySlice<Int> = s;
        count = 0
        for i in 1...9{
            board[encode[i]] = temporaryBoard[i]
            if temporaryBoard[i] != 0{
                self.count += 1
            }
        }
    }
    
    class func getChoice() -> Int{
        //敵(味方)がリーチ状態かどうかを確認するローカルメソッド、リーチ状態ならビンゴになる空きマスのインデックス番号を返し、そうでないならnilを返す。
        func checkReached(_ s:Int) -> Int?{
            let occupied1:[Int] = [1,1,1,1,1,1,2,2,2,3,3,3,3,4,4,4,5,5,5,5,6,7,7,8]
            let occupied2:[Int] = [2,3,4,5,7,9,3,5,8,5,6,7,9,5,6,7,6,7,8,9,9,8,9,9]
            let vacant:[Int] = [3,2,7,9,4,5,1,8,5,7,9,5,6,6,5,1,4,3,2,1,3,9,8,7]
            for i in 0...23{
                if board[occupied1[i]] == s, board[occupied2[i]] == s, board[vacant[i]] == 0{
                    return vacant[i]
                }
            }
            return nil
        }
        var choice:Int = 0
        //置けるマスをランダムに選択する。
        repeat{
            choice = Int(arc4random_uniform(9)) + 1
        }while board[choice] != 0
        //非人工知能の思考回路、拡張性を考慮してtrueのif文を用意した。
        if true{
            switch count{
            case 0://先攻第一手
                if arc4random_uniform(10) <= 6{
                    choice = 1
                }else if arc4random_uniform(10) <= 6{
                    choice = 5
                }else{
                    choice = 2
                }
            case 1://後攻第一手
                if board[5] == 0{
                    choice = 5
                }else{
                    choice = 1
                }
            case 2://先攻第二手
                let frontSecondOpponent:[Int] = [1,1,1,1,1,1,1,1,5,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2]
                let frontSecondPlayer:[Int] = [2,3,4,5,6,7,8,9,1,2,3,4,6,7,8,9,1,3,4,5,6,7,8,9]
                let frontSecondChoice:[Int] = [5,7,2,8,5,2,5,3,2,1,7,2,1,8,1,3,5,6,1,4,3,1,7,3]
                for i in 0...23{
                    if board[frontSecondOpponent[i]] == 2, board[frontSecondPlayer[i]] == 1{
                        if i == 3, arc4random_uniform(2) == 1{
                            choice = 9
                        }else{
                            choice = frontSecondChoice[i]
                        }
                    }
                }
            case 3://後攻第二手
                let backSecondOpponent:[Int] = [5,5,1,5,5,5,5,5,5,5,5,5,5,5,5,5,5]
                let backSecondPlayer1:[Int] = [1,3,5,1,3,3,4,2,2,1,6,2,2,6,4,2,4]
                let backSecondPlayer2:[Int] = [9,7,9,8,8,4,9,7,9,6,7,4,6,8,8,8,6]
                let backSecondChoice:[Int] = [2,2,3,4,6,1,7,6,4,9,3,1,1,9,1,1,1]
                for i in 0...16{
                    if board[backSecondOpponent[i]] == 2, board[backSecondPlayer1[i]] == 1, board[backSecondPlayer2[i]] == 1{
                        choice = backSecondChoice[i]
                    }
                }
            case 4://先攻第三手
                let frontThirdOpponent1:[Int] = [1,1,1,1,1,1,2,5,5,2,5,2,2,2,2,2,2,2,2,2,2,2]
                let frontThirdOpponent2:[Int] = [5,7,2,8,8,3,5,7,7,5,8,6,6,6,6,4,4,3,7,7,7,7]
                let frontThirdPlayer1:[Int] = [2,3,3,2,5,2,1,3,3,4,2,1,3,3,3,5,5,1,4,5,6,8]
                let frontThirdPlayer2:[Int] = [9,4,4,5,9,9,8,4,8,8,7,3,4,8,9,6,8,6,8,8,8,9]
                let frontThirdChoice:[Int] = [4,9,5,7,4,7,7,8,1,1,1,5,5,5,5,1,1,5,3,1,1,1]
                for i in 0...21{
                    if board[frontThirdOpponent1[i]] == 2, board[frontThirdOpponent2[i]] == 2, board[frontThirdPlayer1[i]] == 1, board[frontThirdPlayer2[i]] == 1{
                        choice = frontThirdChoice[i]
                    }
                }
            case 5://後攻第三手
                if board[4] == 2, board[5] == 2, board[1] == 1, board[6] == 1, board[8] == 1{
                    if arc4random_uniform(5) <= 3{
                        choice = 9
                    }else{
                        choice = 7
                    }
                }else if board[5] == 2, board[6] == 2, board[3] == 1, board[4] == 1, board[8] == 1{
                    if arc4random_uniform(5) <= 3{
                        choice = 1
                    }else{
                        choice = 2
                    }
                }
            default:
                break
            }
        }
        //プレイヤーがリーチ状態か確認し、そうならばリーチを止めるマスに置く
        if let reached = checkReached(1){
            choice = reached
        }
        //コンピュータがリーチ状態か確認し、そうならばビンゴを完成させるマスに置く
        if let reached = checkReached(2){
            choice = reached
        }
        return decode[choice]
    }
}
