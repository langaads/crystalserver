# Sistema de Rebirth - Crystal Server 15.11

## Descrição
Sistema que permite aos jogadores resetar seu level para ganhar skill tries em uma habilidade específica.

## Como Funciona

### Requisitos
- **Level mínimo**: 100
- **NPC**: Quentin (localizado em Thais)

### Recompensas
1. **Skill Tries**: 1% da experiência total do jogador é convertida em skill tries da habilidade escolhida
2. **Tibia Coins**: 1 Tibia Coin para cada level sacrificado (level atual - 1)
3. **Contador de Rebirths**: Cada rebirth é contabilizado no perfil do jogador

### Skills Disponíveis
- Sword (Espada)
- Club (Clava)
- Axe (Machado)
- Distance (Distância)
- Shield (Escudo)
- Fishing (Pesca)
- Magic (Magic Level)

### Como Usar

1. Fale com o NPC **Quentin** em Thais
2. Digite `rebirth` para iniciar o diálogo
3. Confirme que deseja fazer o rebirth
4. Escolha a skill que deseja aumentar
5. Confirme sua escolha final

**ATENÇÃO**: Esta ação é irreversível! Você perderá todo seu level e experiência.

### Comandos Adicionais

- `rebirth info` - Mostra informações sobre seu status de rebirth, incluindo:
  - Level atual
  - Experiência total
  - Quantidade de rebirths realizados
  - Tibia Coins que receberá
  - Se você pode fazer rebirth

## Configuração

As configurações do sistema podem ser alteradas no arquivo:
`data-global/scripts/custom/rebirth.lua`

### Configurações Disponíveis

```lua
Rebirth.Config = {
	expToSkillPercent = 1,  -- Porcentagem da exp convertida (padrão: 1%)
	coinsPerLevel = 1,      -- Tibia Coins por level (padrão: 1)
	minLevel = 100,         -- Level mínimo para rebirth (padrão: 100)
}
```

## Storage

O contador de rebirths é salvo no storage:
- **ID**: 50000 (Global.Storage.RebirthSystem)
- **Definido em**: `data/libs/core/global_storage.lua`

## Arquivos Modificados

1. `data-global/scripts/custom/rebirth.lua` - Lógica do sistema
2. `data-global/npc/quentin.lua` - Diálogo com o NPC
3. `data/libs/core/global_storage.lua` - Definição do storage

## Exemplos

### Exemplo 1: Jogador Level 150
- **Experiência Total**: 13.032.051
- **Skill Tries Recebidos**: ~651.602 (1% da exp * 0.05)
- **Tibia Coins Recebidos**: 149 (150 - 1)
- **Resultado**: Retorna ao level 1 com skill tries na habilidade escolhida

### Exemplo 2: Jogador Level 300
- **Experiência Total**: 123.660.097
- **Skill Tries Recebidos**: ~6.183.004 (1% da exp * 0.05)
- **Tibia Coins Recebidos**: 299 (300 - 1)
- **Resultado**: Retorna ao level 1 com skill tries na habilidade escolhida

## Notas Importantes

1. O sistema reseta o jogador para **level 1**
2. **Toda a experiência** é removida
3. Apenas a skill escolhida recebe os tries
4. O contador de rebirths é permanente
5. Não há limite de vezes que um jogador pode fazer rebirth
6. Para Magic Level, a conversão usa `addManaSpent` em vez de `addSkillTries`

## Suporte

Para problemas ou sugestões, entre em contato com a administração do servidor.
