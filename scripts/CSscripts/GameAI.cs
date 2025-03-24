using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
public partial class GameAI : Node
{
    private SpellTree spellTree;
    private String[] _gestures = {"f","p","s","w","d","c"};
    private Random random = new Random(); 
    private int simulationCount = 10000; // 蒙特卡罗模拟次数
    private int depth = 6; // 蒙特卡罗 搜索深度
    private int diseasen = 0;
    public GameAI()
    {
        spellTree = new SpellTree();
    }

    public string FindBestMove(string gameState, int turnStage)
    {
        
        GameStatus status = GameStatus.FromString(gameState);
        
        return FindBestMoveMonteCarlo(status);
        
        
        

    }

    // 蒙特卡洛 算法
    private string FindBestMoveMonteCarlo(GameStatus status)
    {
        
        TreeNode root = new TreeNode(status, ai: this, isCurrentPlayerMCTS: true); // AI 先行动
        for (int i = 0; i < simulationCount; i++)
        {
            // 选择
            TreeNode selectedNode = SelectNode(root);
            // GD.Print($"Simulation Start - P1Hp: {selectedNode.State.P1Hp}, P2Hp: {selectedNode.State.P2Hp}, Potential: {selectedNode.State.potentialScore}");
            // 扩展
            TreeNode expandedNode = ExpandNode(selectedNode);
            // GD.Print($"Simulation Start - P1Hp: {expandedNode.State.P1Hp}, P2Hp: {expandedNode.State.P2Hp}, Potential: {expandedNode.State.potentialScore}");
            // GD.Print($"Simulation Start - P2LeftHand: {expandedNode.Move.LeftGesture}, P2RightHand: {expandedNode.Move.LeftGesture}");

            // 模拟
            double score = Simulate(expandedNode.State, expandedNode.IsCurrentPlayerMCTS);

            // 反向传播
            Backpropagate(expandedNode, score);


        }

        // 选择访问次数最多的移动
        Move bestMove = root.Children.OrderByDescending(child => child.VisitCount).First().Move;
        // GD.Print(root.Children.OrderByDescending(child => child.VisitCount).First().TotalScore); 
        // GD.Print(root.Children.OrderByDescending(child => child.TotalScore).First().TotalScore); 
        return bestMove.ToString();
    }

    private void Backpropagate(TreeNode node, double score)
    {   
        while (node != null)
        {
            node.VisitCount++;
            node.TotalScore += score;
            node = node.Parent;
        }
    }

    private TreeNode ExpandNode(TreeNode node)
    {
        // 优先扩展能触发高评分法术的节点
        var sortedMoves = node.Moves
        .OrderByDescending(m => (m.LeftSpell?.Score ?? 0) + (m.RightSpell?.Score ?? 0))
        .ToList();
        foreach (var move in sortedMoves)
        {
            GameStatus currentState = node.State.Clone();
            //GD.Print($"Simulation Start1 - P1Hp: {currentState.P1Hp}, P2Hp: {currentState.P2Hp}, Potential: {currentState.potentialScore}");

            if (!node.Children.Any(child => child.State.Equals(ApplyMove(currentState, move, node.IsCurrentPlayerMCTS))))
            {
                //GD.Print($"Simulation Start2 - P1Hp: {currentState.P1Hp}, P2Hp: {currentState.P2Hp}, Potential: {currentState.potentialScore}");

                GameStatus newState = ApplyMove(currentState, move, node.IsCurrentPlayerMCTS);
                TreeNode newNode = new TreeNode(newState, node, move, ai: this, isCurrentPlayerMCTS: !node.IsCurrentPlayerMCTS);
                node.Children.Add(newNode);
                return newNode;
            }
        }
        return node; // 如果所有移动都已展开，则返回当前节点
    }

    private TreeNode SelectNode(TreeNode node)
    {
        while (node.Moves.Count == node.Children.Count) // 所有可能的移动都已展开
        {
            node = node.Children.OrderByDescending(child => 
                child.TotalScore  + Math.Sqrt(2.5 * Math.Log(node.VisitCount) / child.VisitCount)
            ).First();
        }
        return node;
    }

    private double Simulate(GameStatus state, bool isCurrentPlayerMCTS)
    {
        GameStatus simulationState = state.Clone();
        simulationState.P1Hp = 14;
        simulationState.P2Hp = 14;
        simulationState.potentialScore = 0;
        // GD.Print($"Simulation Start - P1Hp: {state.P1Hp}, P2Hp: {state.P2Hp}, Potential: {state.potentialScore}");
        int steps = 0;
        while (steps < depth)
        {
            var moves = GenerateMoves(simulationState, isCurrentPlayerMCTS);
            // 启发式选择：优先选择能触发法术的移动
            Move randomMove =moves[random.Next(moves.Count)];
            // Move randomMove = SelectHeuristicMove(moves, isCurrentPlayerMCTS);
            simulationState = ApplyMove(simulationState, randomMove, isCurrentPlayerMCTS);
            isCurrentPlayerMCTS = !isCurrentPlayerMCTS;
            steps++;
            // GD.Print($"Step {steps} - P1Hp: {simulationState.P1Hp}, P2Hp: {simulationState.P2Hp}, Potential: {simulationState.potentialScore}");
        }
        double score = Evaluate(simulationState);
        // GD.Print($"Simulation End - Score: {score}, P1Hp: {simulationState.P1Hp}, P2Hp: {simulationState.P2Hp}, P1Hp: {simulationState.P1IsDisease}, P2Hp: {simulationState.P2IsDisease},Potential: {simulationState.potentialScore}");
        return score;
    }

    private Move SelectHeuristicMove(List<Move> moves, bool isMCTSPlayer)
    {
        var spellMoves = moves.Where(m => m.LeftSpell != null || m.RightSpell != null).ToList();
        if (spellMoves.Count == 0) return moves[random.Next(moves.Count)];

        // 按法术总评分创建权重列表
        List<double> weights = new List<double>();
        foreach (var move in spellMoves)
        {
            double score = (move.LeftSpell?.Score ?? 0) + (move.RightSpell?.Score ?? 0);
            weights.Add(Math.Pow(score, 2)); // 使用平方加强高评分法术
        }

        // 加权随机选择
        double totalWeight = weights.Sum();
        double randomValue = random.NextDouble() * totalWeight;
        double cumulative = 0;
        for (int i = 0; i < spellMoves.Count; i++)
        {
            cumulative += weights[i];
            if (randomValue <= cumulative)
                return spellMoves[i];
        }
        return spellMoves.First();
    }
    
    // 应用移动并更新游戏状态
    private GameStatus ApplyMove(GameStatus status, Move move, bool isMCTSPlayer)
    {
        GameStatus newState = status.Clone(); 

        // 更新手势历史
        if (isMCTSPlayer)
        {
            newState.P2LeftHand += move.LeftGesture;
            newState.P2RightHand += move.RightGesture;
        }
        else
        {
            newState.P1LeftHand += move.LeftGesture;
            newState.P1RightHand += move.RightGesture;
        }


        // 应用法术效果
        ApplySpell(newState, move.LeftSpell, move.LeftTarget, isMCTSPlayer);
        ApplySpell(newState, move.RightSpell, move.RightTarget, isMCTSPlayer);

        return newState;
    }

    // 应用法术效果
    private void ApplySpell(GameStatus status, Spell spell, int target, bool isMCTSPlayer)
    {
        if (spell == null) return;
        if (isMCTSPlayer)   status.potentialScore += spell.Score;
        
        switch (spell.Sequence)
        {
            case "p":
                if (isMCTSPlayer)
                {
                    status.potentialScore += status.P1CreaturesAttacks * 20; // 阻挡召唤物伤害
                    status.P1CreaturesAttacks = 0; // 重置敌方召唤物
                }
                else
                {
                    status.potentialScore -= status.P2CreaturesAttacks * 20;
                    status.P2CreaturesAttacks = 0;
                }
                break;
            case "sd":
                if (target==0) status.P1Hp -= 1;
                else status.P2Hp -= 1;
                break;
            case "dffdd":
                if (target==0) status.P1Hp -= 5;
                else status.P2Hp -= 5;
                break;
            case "wfp":
                if (target==0) status.P1Hp -= 2;
                else status.P2Hp -= 2;
                break;
            case "wpfd":
                if (target==0) status.P1Hp -= 3;
                else status.P2Hp -= 3;
                break;
            case "fssdd":
                if (target==0) status.P1Hp -= 5;
                else status.P2Hp -= 5;
                break;
            
            case "sfw":
                if (target==0) status.P2CreaturesAttacks += 1;
                else status.P1CreaturesAttacks += 1;
                break;

            case "psfw":
                if (target==0) status.P2CreaturesAttacks += 2;
                else status.P1CreaturesAttacks += 2;
                break;

            case "fpsfw":
                if (target==0) status.P2CreaturesAttacks += 3;
                else status.P1CreaturesAttacks += 3;
                break;

            case "wfpsfw":
                if (target==0) status.P2CreaturesAttacks += 4;
                else status.P1CreaturesAttacks += 4;
                break;

            case "dfw":
                if (target==0){
                    status.P1Hp += 1;
                    if (status.P1Hp > 14){
                        status.P1Hp = 14;
                    }
                } else {
                    status.P2Hp += 1;
                    if (status.P2Hp > 14){
                        status.P2Hp = 14;
                    }
                }
                break;
	        case "dfpw":
                if (target==0){
                    status.P1Hp += 2;
                    if (status.P1Hp > 14){
                        status.P1Hp = 14;
                    }
                    if (status.P1IsDisease>0){
                        status.P1IsDisease = -1;
                    }
                } else {
                    status.P2Hp += 2;
                    if (status.P2Hp > 14){
                        status.P2Hp = 14;
                    }
                    if (status.P2IsDisease>0){
                        status.P2IsDisease = -1;
                        status.potentialScore += 100;
                    }
                }
                break;
            case "swwc":
                status.P1Hp -= 5;
                status.P2Hp -= 5;
                status.P1CreaturesAttacks = 0;
                status.P2CreaturesAttacks = 0;
                break;

            case "dsfffc":
                if (target==0){
                    status.P1IsDisease = 6;
                } else {
                    status.P2IsDisease = 6;
                }
            break;
        }
    }

    private List<Move> GenerateMoves(GameStatus status, bool isMCTSPlayer)
    {
        List<Move> moves = new List<Move>();
        // 获取玩家的手势历史
        string historyLeft  = isMCTSPlayer ? status.P2LeftHand : status.P1LeftHand;
        string historyRight  = isMCTSPlayer ? status.P2RightHand : status.P1RightHand;

        // 尝试所有手势组合
        foreach (var leftGesture in GetPriorityGestures(historyLeft))
        {

            foreach (var rightGesture in GetPriorityGestures(historyRight))
            {

                if (rightGesture == "p" && leftGesture == "p"){
                    continue;
                }
                if (rightGesture == "c" && leftGesture != rightGesture){
                    continue;
                }
                if (leftGesture == "c" && leftGesture != rightGesture){
                    continue;
                }
                // 更新手势历史
                string newLeftHand = historyLeft + leftGesture;
                string newRightHand = historyRight + rightGesture;
                // 获取可能的法术
                List<Spell> leftSpells = spellTree.SearchValidSpells(newLeftHand);
                List<Spell> rightSpells = spellTree.SearchValidSpells(newRightHand);

                // 为每个可能的法术组合生成 Move 对象
                foreach (var leftSpell in leftSpells.Concat(new[] { (Spell)null }))
                {
                    foreach (var rightSpell in rightSpells.Concat(new[] { (Spell)null }))
                    {
                        // 默认目标为 -1（无目标）
                        int target = 1;
                        if (isMCTSPlayer) target = 0;

                        int leftTarget = leftSpell != null ? target : -1;
                        int rightTarget = rightSpell != null ? target : -1;

                        if (leftSpell != null && (leftSpell.Sequence == "dfpw" || leftSpell.Sequence == "dfw" || leftSpell.Sequence == "p"))
                        {
                            leftTarget = 1 - target;
                        }

                        if (rightSpell != null && (rightSpell.Sequence == "dfpw" || rightSpell.Sequence == "dfw" || rightSpell.Sequence == "p"))
                        {
                            rightTarget = 1 - target;
                        }

                        // 如果有法术可用，则不选择空法术
                        if ((leftSpell != null || rightSpell != null) || (leftSpells.Count == 0 && rightSpells.Count == 0))
                        {
                            moves.Add(new Move(leftGesture, rightGesture, leftSpell, leftTarget, rightSpell, rightTarget));
                        }
                    }
                }
            }
        }

        moves = moves.OrderBy(x => random.Next()).ToList();   
        return moves;
    }

    private IEnumerable<string> GetPriorityGestures(string history)
    {
        Spell bestSpell = spellTree.GetBestMatch(history);
        if (bestSpell != null && history.Length < bestSpell.Sequence.Length) // 添加边界检查
        {
            // 计算距离完成还差几个手势
            int remaining = bestSpell.Sequence.Length - history.Length;
            
            // 优先选择下一个必需手势
            char nextChar = bestSpell.Sequence[history.Length];
            return _gestures
                .OrderByDescending(g => g == nextChar.ToString() ? 1.5f : 1f)
                .ThenBy(g => random.Next());
        }
        return _gestures.OrderBy(g => random.Next());
    }

   // 评估函数
    private int Evaluate(GameStatus status)
    {
        int score = 0;

        // 1. HP差值（权重：12）
        int hpDiff = status.P2Hp - status.P1Hp;
        score += hpDiff * 10;

        // 2. 召唤物伤害（动态权重：6 + 回合数/2）
        int p1SummonDmg = status.P1CreaturesAttacks * (status.P2IsDisease > 0 ? 3 : 2);
        int p2SummonDmg = status.P2CreaturesAttacks * (status.P1IsDisease > 0 ? 3 : 2);
        score += (p2SummonDmg - p1SummonDmg) * 6;

        //3. 疾病效果（剩余回合越多，奖励越高）
        if (status.P1IsDisease > 0)
            score += 10000; // 每剩余回合+8分
        if (status.P2IsDisease > 0)
            score -= 100 * 20;

        // 4. 法术构建进度奖励（权重：2）
        int progressBonus = 0;
        progressBonus += GetSpellProgressBonus(status.P2LeftHand);
        progressBonus += GetSpellProgressBonus(status.P2RightHand);
        score += progressBonus;

        // 5. 潜在分数（权重：1.5）
        score += (int)(status.potentialScore);
        // GD.Print($"HP差值: {hpDiff}, 召唤物: {(p2SummonDmg - p1SummonDmg) * (6)}, " +
        //   $"疾病: {status.P2IsDisease}, " +
        //   $"进度: {progressBonus }, 潜在: {status.potentialScore}");
        return score;
    }

    private int GetSpellProgressBonus(string gestureHistory)
    {
        Spell spell = spellTree.GetBestMatch(gestureHistory);
        if (spell == null) return 0;

        // 计算匹配长度（忽略无关手势）
        int matchedLength = GetMatchedLength(gestureHistory, spell.Sequence);

        // 计算进度（0到1之间）
        float progress = (float)matchedLength / spell.Sequence.Length;

        // 基础奖励：法术长度 × 2
        int baseReward = spell.Sequence.Length * 2;

        // 进度奖励：使用指数增长强化接近完成时的奖励
        // 公式：progress^3 * baseReward
        float progressBonus = MathF.Pow(progress, 3) * baseReward;

        // 总奖励 = 基础奖励 + 进度奖励
        return (int)(baseReward + progressBonus);
    }

    // 计算手势历史与法术序列的匹配长度
    private int GetMatchedLength(string gestureHistory, string spellSequence)
    {
        int matchedLength = 0;
        int spellIndex = 0;

        // 遍历手势历史，动态匹配法术序列
        for (int i = 0; i < gestureHistory.Length; i++)
        {
            if (spellIndex >= spellSequence.Length)
                break; // 法术序列已匹配完成

            if (gestureHistory[i] == spellSequence[spellIndex])
            {
                matchedLength++;
                spellIndex++; // 匹配成功，移动到下一个字符
            }
        }

        return matchedLength;
    }

   // 移动类
    public class Move
    {
        public string LeftGesture { get; }
        public string RightGesture { get; }
        public Spell LeftSpell { get; }
        public int LeftTarget { get; }
        public Spell RightSpell { get; }
        public int RightTarget { get; }

        public Move(string leftGesture, string rightGesture, Spell leftSpell, int leftTarget, Spell rightSpell, int rightTarget)
        {
            LeftGesture = leftGesture;
            RightGesture = rightGesture;
            LeftSpell = leftSpell;
            LeftTarget = leftTarget;
            RightSpell = rightSpell;
            RightTarget = rightTarget;
        }

        public override string ToString()
        {
            string left_spell = LeftSpell?.Sequence??"";
            string right_spell = RightSpell?.Sequence??"";
            string result = "";
            result += $"{LeftGesture}\n";
            result += $"{RightGesture}\n";
            result += $"{left_spell}\n"; // 
            result += $"{LeftTarget}\n"; // -1 表示未选择
            result += $"{right_spell}\n"; // 
            result += $"{RightTarget}\n"; // -1 表示未选择
            return result;
        }
    }

    class GameStatus{
        public String P1LeftHand { get; set; }
        public String P1RightHand { get; set; }
        public int P1Hp { get; set; }
        public int P1CreaturesAttacks { get; set; }
        public int P1IsDisease { get; set; }


        public String P2LeftHand { get; set; }
        public String P2RightHand { get; set; }
        public int P2Hp { get; set; }
        public int P2CreaturesAttacks { get; set; }
        public int P2IsDisease { get; set; }

        public int potentialScore=0;

        public override string ToString()
        {
            return $"Left Hand: {P1LeftHand}\n" +
                $"Right Hand: {P1RightHand}\n" +
                $"HP: {P1Hp}\n" +
                $"Creatures Attacks: {P1CreaturesAttacks}\n" +
                $"Is Disease: {P1IsDisease}\n" +
                $"Left Hand: {P2LeftHand}\n" +
                $"Right Hand: {P2RightHand}\n" +
                $"HP: {P2Hp}\n" +
                $"Creatures Attacks: {P2CreaturesAttacks}\n" +
                $"Is Disease: {P2IsDisease}\n";
        }

        public static GameStatus FromString(string input)
        {
            var lines = input.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            var gameStatus = new GameStatus();

            for (int i = 0; i < lines.Length; i++)
            {
                var line = lines[i].Trim();
                if (line.StartsWith("Left Hand: "))
                {
                    if (i < 4)
                        gameStatus.P1LeftHand = line.Substring("Left Hand: ".Length);
                    else
                        gameStatus.P2LeftHand = line.Substring("Left Hand: ".Length);
                }
                else if (line.StartsWith("Right Hand: "))
                {
                    if (i < 4)
                        gameStatus.P1RightHand = line.Substring("Right Hand: ".Length);
                    else
                        gameStatus.P2RightHand = line.Substring("Right Hand: ".Length);
                }
                else if (line.StartsWith("HP: "))
                {
                    if (i < 4)
                        gameStatus.P1Hp = int.Parse(line.Substring("HP: ".Length));
                    else
                        gameStatus.P2Hp = int.Parse(line.Substring("HP: ".Length));
                }
                else if (line.StartsWith("Creatures Attacks: "))
                {
                    if (i < 4)
                        gameStatus.P1CreaturesAttacks = int.Parse(line.Substring("Creatures Attacks: ".Length));
                    else
                        gameStatus.P2CreaturesAttacks = int.Parse(line.Substring("Creatures Attacks: ".Length));
                }
                else if (line.StartsWith("Is Disease: "))
                {
                    if (i < 4)
                        gameStatus.P1IsDisease = int.Parse(line.Substring("Is Disease: ".Length));
                    else
                        gameStatus.P2IsDisease = int.Parse(line.Substring("Is Disease: ".Length));
                }
            }

            return gameStatus;
        }
        public GameStatus Clone()
        {
            return new GameStatus
            {
                P1LeftHand = this.P1LeftHand,
                P1RightHand = this.P1RightHand,
                P1Hp = this.P1Hp,
                P1CreaturesAttacks = this.P1CreaturesAttacks,
                P1IsDisease = this.P1IsDisease,
                P2LeftHand = this.P2LeftHand,
                P2RightHand = this.P2RightHand,
                P2Hp = this.P2Hp,
                P2CreaturesAttacks = this.P2CreaturesAttacks,
                P2IsDisease = this.P2IsDisease,
                potentialScore = this.potentialScore
            };
        }
    }

    class TreeNode
    {
        public GameStatus State { get; set; }
        public TreeNode Parent { get; set; }
        public List<TreeNode> Children { get; set; }
        public List<Move> Moves { get; set; }
        public int VisitCount { get; set; }
        public double TotalScore { get; set; }
        public Move Move { get; set; } // 记录从父节点到当前节点的移动
        public bool IsCurrentPlayerMCTS { get; set; } // 当前玩家是否是 AI

        // 构造函数中传入 GameAI 实例
        public TreeNode(GameStatus state, TreeNode parent = null, Move move = null, GameAI ai = null, bool isCurrentPlayerMCTS = true)
        {
            State = state.Clone(); // 深拷贝状态
            Parent = parent;
            Move = move;
            Children = new List<TreeNode>();
            Moves = ai?.GenerateMoves(state, isCurrentPlayerMCTS);
            VisitCount = 0;
            TotalScore = 0;
            IsCurrentPlayerMCTS = isCurrentPlayerMCTS;
        }
    }
}
