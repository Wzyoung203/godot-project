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
signal selected_target(character: Role)
# 左手法术选择完毕
signal left_selected

# 选中法术或对象阶段结束信号
signal select_end
# 法术生效结束信号
signal effect_end

# 本回合无可用法术信号
signal no_valid_spell

# 法术事件创建成功
signal event_creat_success

# 一般事件信息
signal normal_event(message: String)

# ai操作信号
# ai本回合输入信号
signal ai_gestures(lefthand:String,rightHand:String)
# 生物列表变动（目前仅用于更新ai的目标队列）
signal creature_changed(creatures:Array[Role])
# 本回合ai使用的法术及目标
signal ai_cur_spells_targets(spells:Array[Spell],targets:Array[Role])
# ai行为结束信号
signal ai_behaviour_finished
# ai事件建立信号
signal ai_events_created
