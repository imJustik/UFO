import SpriteKit

class GameStates {
    var score: Int
    var highScore: Int
    
    class var sharedInstance: GameStates {
        struct Singleton {
            static let instance = GameStates()
        }
        
        return Singleton.instance
    }
    
    init() {
        score = 0
        highScore = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        highScore = defaults.integerForKey("highScore")
    }
    
    func saveState() {
        // Update highScore if the current score is greater
        highScore = max(score, highScore)
        
        // Store in user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highScore, forKey: "highScore")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}