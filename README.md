# Cöisa
Implementação no LÖVE de um sistema entidade/componente, junto com outras funcionalidades que facilitam o desenvolvimento de jogos.

### Exemplo
```lua
require("lib.treco.trecoCore")

function love.load()
	testeScene = Scene("testeScene")    --Cria uma scene "testeScene"
	cCore.loadScene(testeScene)        --Carrega a scene

	caixa = Treco("caixa", {    -- Cria um treco chamado caixa
		Position({x = 200, y = 140}),     --Na posição [200,140]
		Sprite({texture = R.texture.tile})})    --Com a textura tile.png
end

function love.update(dt)
	cCore.update(dt)
end

function love.draw()
	cCore.draw()
end
```
Neste exemplo, simplesmente desenhamos uma textura(tile.png) na posição [200, 140]. Parece que estamos apenas complicando, mas à medida em que o código ficar mais complexo essa estrutura vai acabar na verdade simplificando os trecos.


### Estrutura
----------
![Estrutura](http://imgur.com/WmhH9em.png)

Basicamente, o sistema deixa uma `Scene` ativa por vez, que funciona como um estado de jogo(menu, loading, jogo, etc). Uma `Scene` mantem uma lista de `Treco`, que são "entidades de jogo", que por sua vez mantem uma lista de `Component`. Tudo no jogo é um treco, o personagem, o inimigo, a parede, o chão, etc. Cada treco é definido pelos componentes que ele tem. Por exemplo, o chão tem uma posição, uma textura, e não pode deixar outros trecos passarem por ele. Para isso, ele pode ter os componentes `Position`, `Sprite` e `BoxCollider`. Mas os componentes não são responsáveis por estas funções, eles apenas guardam informações específicas sobre o treco a qual pertencem. É aí que entra o `Script`, que age sobre os trecos que são relevantes para ele. O script `Renderer`, por exemplo, se interessa pelos trecos com o componente `Sprite`, e desenha a textura delas na tela.


Um personagem já é um treco mais complexo:
- Ele pode ter uma animação quando ele está andando. Um componente `Animation` indica qual é a animação do treco, enquanto um script `Animator` manipula trecos com esse componente, mudando o sprite atual para o frame da animação
- Ele precisa ser controlavel(andar, pular, morrer...). Com outro componente, que vai guardar coisas como a velocidade do personagem, um script pode pegar e atualizar a posição atual do treco
- O jogador precisa controlar o personagem. Outro componente e outro script, para verificar a entrada do jogador.

Outros trecos no jogo vão precisar realizar outras funções. Por isso, o sistema deixa fácil a criação de novos componentes . Mais adiante isso será explicado com mais detalhes.


### trecoCore
É o núcleo do sistema. Ele tem registrado todas as scenes e scripts criados. A partir dele se carrega as scenes. Quando um treco novo é criado, ele coloca o treco na scene atual, e verifica com os scripts carregados se alguém quer o treco recém criado.

__`cCore.loadScene(s)`__
Carrega a scene `s`. Todos scripts são atualizados, tirando os trecos da scene antiga e carregando os trecos da scene atual.
`s`: A scene a ser carregada(table)
`s`: Nome da scene a ser carregada(string)

__`cCore.update(dt)`__
Necessário para chamar as callbacks `update` nas scenes e scripts
`dt`: deltaTime

__`cCore.draw()`__
Necessário para chamar as callbacks `draw` nas scenes e scripts

### Scene
A ideia é existir uma para cada estado de jogo(menu, loading, jogo, etc). Guarda uma lista de trecos. Nela é pessível colocar uma lógica de jogo mais geral.

__`Scene(nome)`__
Cria uma nova scene e a registra no trecoCore
`nome`: nome para a nova scene
Retorna a table da nova scene

Callbacks suportadas:
__`:init()`__
É chamada na primeira vez que a scene é carregada

__`:enter()`__
É chamada todas as vezes em que a scene é carregada

__`:exit()`__
É chamada quando a scene é descarregada

__`:draw()`__
Mesmo que love.draw()

__`:update(dt)`__
Mesmo que love.update(dt)

__`:lateUpdate(dt)`__
É chamado a todo update depois que todos os scripts já executaram

### Treco
Uma entidade no jogo, ou seja, qualquer treco individual no jogo (personagem, inimigo, chão, parede, etc). Serve como um recipiente para componentes.

__`Treco(nome, <componentes>)`__
Cria um novo treco na scene atual
`nome`: Nome do novo treco
`componentes`: Uma table com componentes iniciais para esse treco
Retorna a table do treco criado

__`:addComponent(comp)`__ 

__`:removeComponent(comp)`__

__`:destroy()`__

### `Component`
Serve para definir o que o treco é.

__`Component(handle, propriedades)`__
Cria um novo componente
`handle`: Nome da variavel que vai conter este componente no treco
`propriedades`: Table com as prorpiedades que o componente tem

Exemplo:
```lua
Character = Component("char", {    --Cria um novo componente Character
    speed = 10,                    --Com as prorpiedades speed e jumpHeight
    jumpHeight = 3                 --Cujos valores padrão são 10 e 3
})

--Cria um treco com o componente criado, modificando o valor de speed
player = Treco("player", Character({speed = 20}))    

--Modifica um valor do componente depois de ele ter sido criado
player.char.jumpHeight = 4
```
### `Script`
São neles que a maior parte lógica do jogo fica. Um script tem interesse em trecos com determinados componentes. Então, todos os trecos que se encaixam nas especificações do script são passados para as callbacks dele, para que ele os manipule como quiser.

__`Script(req)`__
Cria um novo script e já o registra no cCore.
`req`: Table com os componentes requeridos por esse script

__Callbacks suportadas:__
__`:init(t)`__
Chamada quando um novo treco `t` é criado

__`:updateOnce(dt)`__
Chamada uma vez a cada update(), independente se o script tem ou não trecos

__`:update(t, dt)`__
Chamada para cada treco `t` do script, a cada update()

__`:lateUpdateOnce(dt)`__
Chamada uma vez a cada update() depois de todos os updates, independente se o script tem ou não trecos

__`:lateUpdate(c, dt)`__
Chamada para cada treco `t` do script, a cada update() depois de todos os updates

__`:draw(c)`__
Chamada para cada treco `t` do script, a cada draw()

__`:drawBefore()`__
Chamada uma vez antes de chamar qualquer draw dos trecos

__`:drawAfter()`__
Chamada uma vez depois de chamar todos os draw dos trecos

__`:onRemoval(c)`__
Chamada ao remover o treco `t` do script, seja porque o treco foi destruída ou porque ela não se encaixa mais nos requerimentos do scripts

Exemplo:
```lua
--Um simples renderizador
Renderer = Script({Sprite})    --Só posso renderizar se o treco tiver um sprite pra renderizar

function Renderer:draw(c)    --Para cada treco com sprite, a cada draw...
	love.graphics.setColor(c.sprite.color:value())    --Seta a cor
	love.graphics.draw(c.sprite.texture, c.pos.x, c.pos.y)    --Desenha o sprite
end
```


### ResourceManager
Foi criado para acabar com o problema de redundância na criação de recursos. Imagine, por exemplo, uma textura que é usada em duas partes diferentes de um jogo. Cada parte não sabe da existência da outra, então cada uma cria uma nova `Image` da textura, o que é dispendioso.
O que o ResourceManager faz é manter uma tabela com todos os recursos do jogo. Assim, quando uma parte do jogo quer uma textura, ele chama o `ResourceMgr.get`, que retorna a textura se ela já existe, ou cria a textura, coloca na tabela de recursos, e a retorna. Quando a outra parte do jogo precisar dessa mesma textura, o ResourceManager vai retornar a mesma que ele já tinha criado antes.
Para deixar o código mais limpo, também é possível usar ResourecManager.type.name, por exemplo:
`R.texture.bullet`
Que é equivalente a:
`R.get("texture", "bullet")`

**`ResourceManager.get(type, name)`**
Verifica a existencia do recurso do tipo `type` e nome `name`, tenta criar o recurso caso ele não exista, e retorna o recurso

**`ResourceManager.add(type, name)`**
Vai adicionar o recurso do tipe `type` e nome `name` caso ele não exista.

__Tipos suportados:__
**`texture`**: Textura normal. O ResourceManager tenta achar a textura dentro da pasta na variável `ResourceManager.textureFolder`, que é `textures` por padrão.

**`animSheet`**: Arquivo lua de informação sobre animações em sprites. 
Estrutura: 
```lua
->animSheet.lua
return {
    {
        name = "nome da animação",
    	texture = [Image da spritesheet],
    	size = [quantidade de frames],
    	timestep = [segundos entre frames],
    	loop = [se volta pro começo ao chegar ao fim],
    	tilewidht = [largura do quad],
    	tileheight = [altura do quad],
    	frames = {
    		{quad = love.graphics.newQuad(...)},
    		...
    	}
    },
    ...
}
```

**`anim`**: Animação criada anteriormente ao carregar um `animSheet`

**`scene`**: Arquivo lua que retorna uma `Scene`. O ResourceManager procura na pasta na variável `ResourceManager.sceneFolder`, que é `scenes` por padrão.
