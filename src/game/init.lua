import 'general/scene/scene-manager'
import 'general/graphics/screen'

Screen.width = love.graphics.getWidth()
Screen.height = love.graphics.getHeight()

addScene('main', 'game/scenes/main-scene', 'MainScene')
addScene('game', 'game/scenes/game-scene', 'GameScene')

SceneManager.switch('main')