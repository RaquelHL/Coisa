# Cöisa
Implementation of a Entity Component System for the LÖVE framework, with 
some other features to speed up game development. "Coisa", meaning "thing"
in portuguese, is the name it's used to refer to an entity.

### Example
This example shows the simplest usage of Coisa, just adding a texture on 
the screen with the built-in components `Position` and `Sprite`:
```lua
require("lib.coisa.coisaCore")

function love.load()
    testScene = Scene("testScene")    -- Creates the scene "testScene"
    cCore.loadScene(testScene)        -- Loads the scene

    tile = Coisa(                     -- Creates a new coisa
        Position(200, 140),           -- At position [200,140]
        Sprite(R.texture.tile)        -- With the texture resource tile.png
end

-- forward update and draw callbacks to coisa
function love.update(dt)
    cCore.update(dt)
end
function love.draw()
    cCore.draw()
end
```

###Structure

![Structure](https://i.imgur.com/eLLx4ms.png)

`CoisaCore` manages everything. It keeps one scene loaded at a time, which can be a menu, loading screen, 
game level, etc. A `Scene` maintains a list of Coisas, which are game entities, and a Coisa maintains a 
list of Components. Everything in the game is a Coisa, the player, the enemy, walls, ground, etc. Each
coisa is defined by its components, for example, a wall has a position, a texture and can't let things 
pass through it. For that, it needs to have the components `Position`, `Sprite` and `BoxCollider`. But 
components aren't directly responsible for these behaviors , they only store information. Acting on this
information is the role of Scripts, they're the ones to manipulate Coisas. For example, the `Renderer` 
script is interested with Coisas with the `Sprite` component. It reads the texture info stored on the 
component and renders it on the screen.  

A player however can be more complex:
- It can have an animation when moving. The `Animation` component stores info about the animation 
itself, while the `Animator` script changes the sprite so the animation flows
- It needs to be controlled, so a component can store stuff like his speed while a script updates 
its position
- The player needs to control it via inputs, another component, another script, and so on..

Other stuff in the game will need different behavior, so this system makes it easy to create new components
and scripts, which will be explained in more detail in a bit.


### coisaCore
It's the system's core. It keeps track of all the scenes and scripts created, loads scenes, creates coisas
in the currently loaded scene and makes the connections between components and scripts interested in said
components.

__`cCore.loadScene(s)`__
Load the scene `s`. All scripts and coisas are reseted.
- `s`: The scene to be loaded (table)

__`cCore.update(dt)`__
Needs to be called on `update`, necessary for the system to function.
- `dt`: deltaTime, the time elapsed between frames

__`cCore.draw()`__
Needs to be called on `draw`, necessary for the system to function.

### Scene
Used to manage the game state. It holds a list of coisas. It can also hold game logic specific for a scene.

__`Scene(name)`__
Creates a new scene and registers it on coisaCore
- `name`: name of the new scene (string)

Returns a table with the new scene

#### Supported callbacks:
__`:init()`__
Called once when the scene is first loaded

__`:enter()`__
Called every time a scene is loaded

__`:exit()`__
Called every time the scene is unloaded

__`:draw()`__
Same as love.draw()

__`:update(dt)`__
Same as love.update(dt)

__`:lateUpdate(dt)`__
Called every frame after all the scripts ran their `update()`

### Coisa
A game entity which holds components.

__`Coisa(...components)`__
Creates a new coisa in the current scene
`...components`: any number of components for the coisa to be initialized with
Returns a table of the created coisa

__`:addComponent(component)`__ 

__`:removeComponent(component)`__

__`:destroy()`__

### `Component`
Defines what the coisa is, holds information that will be used by scripts

__`Component(handle, properties)`__
Creates a new component
`handle`: component identifier, will be used to access the component in a Coisa
`properties`: Table of properties that the component can hold

Example:
```lua
Character = Component("char", {    -- Creates a new component Character
    speed = 10,                    -- with properties speed and jumpHeight
    jumpHeight = 3                 -- with default values 10 and 3
})

-- Create a coisa with the created component 
player = Coisa("player", Character({ speed = 20 }))    

-- Modify a value in the component utilizing it's handle 'char' 
player.char.jumpHeight = 4
```
### `Script`
Holds the game logic. A script acts upon Coisas with specific components, which 
are specified when creating the script. CoisaCore handles connecting scripts 
with relevant Coisas, so the script itself can contain only game logic.

__`Script(requirements)`__
Creates a new script and register it on cCore.
`requirements`: Table with components required by this script

__Callbacks:__
__`:init(c)`__
Called when a new coisa `c` is created

__`:updateOnce(dt)`__
Called once every `update`, unrelated to registered coisas

__`:update(c, dt)`__
Called every `update` for every registered coisa `c`

__`:lateUpdateOnce(dt)`__
Called once every `update`, unrelated to registered coisas, after all `update` calls 
are done

__`:lateUpdate(c, dt)`__
Called every `update` for every registered coisa `c`, after all `update` calls are
done 

__`:draw(c)`__
Called every `draw` for every registered coisa `c`

__`:drawBefore()`__
Called once every `draw` before calling `draw` for every coisa

__`:drawAfter()`__
Called once every `draw` after calling `draw` for every coisa

__`:onRemoval(c)`__
Called when unregistering a coisa from this script, either because it was destroyed or 
one of the required components was removed

Example:
```lua
-- A simple renderer
Renderer = Script({ Sprite, Position })    -- We can only render a coisa if it has a Sprite component

function Renderer:draw(c)
    love.graphics.setColor(c.sprite.color:value())
    love.graphics.draw(c.sprite.texture, c.pos.x, c.pos.y)
end
```

## Extra features
The ECS system is already explained. The features described next are general utilities
for making games with it.

### ResourceManager
Its role is to end the problem with redundancy when dealing with resources. For
example, if the same texture is used in two different parts fo the game, each part
will create its own `Image` resource from the texture, since they don't know about 
each other.
What ResourceManager does is maintain a table with all the game's resources. By using
`ResourceMgr.get`, you will make sure that a resource will be reused if possible or 
created if it doesn't exist yet. For syntax sugar, it's also possible to get resources
by using `ResourceManager.[type].[name]` instead of 
`ResourceManager.get([type], [name])`, for example `R.texture.bullet` instead of 
`R.get("texture", "bullet")`.

**`ResourceManager.get(type, name)`**
Returns the resource `name` of type `type`, either a cached one or a new one

**`ResourceManager.add(type, name)`**
Adds the resource `name` of type `type` if it doesn't already exist.

__Supported types:__
**`texture`**: A image resource. It tries to find the file in the folder indicated by
`ResourceManager.textureFolder`, which is `textures` by default.

**`animSheet`**: Lua file with animations info.  
Structure: 
```lua
->animSheet.lua
return {
    {
        name = "name",
    	texture = [spritesheet],
    	size = [amount of frames],
    	timestep = [time in seconds between frames],
    	loop = [boolean, if should return to start after ending],
    	tilewidth = [quad's width],
    	tileheight = [quad's height],
    	frames = {
    		{quad = love.graphics.newQuad(...)},
    		...
    	}
    },
    ...
}
```

**`anim`**: Animation created by loading a `animSheet` file.

**`scene`**: Lua file that returns a `Scene`. ResourceManager will try to find it
in the folder indicated by `ResourceManager.sceneFolder`, which is `scenes` by default.
