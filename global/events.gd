extends Node

# 回合阶段信号
signal player_turn
signal spell_select
signal spell_effect
signal turn_end

# 用户操作信号
# 回合结束按钮被触发
signal player_turn_end
# 传入输入信号
signal spells_on_hands(lefthand:String,rightHand:String)

# 输入处理完毕信号
signal input_process_success

# 发送即将释放的法术信号
signal selected_spell(spell:Spell)

# 选中目标信号
signal selected_target(character: Character)

# 选中法术或对象阶段结束信号
signal select_end
# 法术生效结束信号
signal effect_end
