import 'general/scene/scene-manager'

addScene('main', 'game/scenes/main-scene', 'MainScene')
addScene('game', 'game/scenes/game-scene', 'GameScene')

SceneManager:switch('main')