using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
public partial class GameAI : Node
{
    private SpellTree spellTree;
    private String[] _gestures = {"f","p","s","w","d","c","o"};
    private int simulationCount = 100; // 蒙特卡罗模拟次数
    private int depth = 3; // Minimax 搜索深度
    public GameAI()
    {
        spellTree = new SpellTree();
    }

    public string FindBestMove(string gameState, int turnStage)
    {
        GameStatus status = GameStatus.FromString(gameState);
        int bestScore = int.MinValue;
        Move bestMove = null;
        if (turnStage < 10){
            return FindBestMoveMonteCarlo(status);
        } else {
            return FindBestMoveMonteCarlo(status);
        }
        

    }

    // 蒙特卡洛 算法
    private string FindBestMoveMonteCarlo(GameStatus status)
    {
        var moves = GenerateMoves(status, isMaximizingPlayer: true);
        var moveScores = new Dictionary<Move, double>();

        foreach (var move in moves)
        {
            moveScores[move] = 0;
        }

        for (int i = 0; i < simulationCount; i++)
        {
            foreach (var move in moves)
            {
                GameStatus newState = ApplyMove(status, move);
                double score = Simulate(newState);
                moveScores[move] += score;
            }
        }

        // 选择平均回报最高的策略
        Move bestMove = moves.OrderByDescending(m => moveScores[m]).First();
        return bestMove.ToString();
    }

    private double Simulate(GameStatus state)
    {
        // 随机模拟游戏进展
        int steps = 0;
        while (steps < 10) // 模拟10步
        {
            var moves = GenerateMoves(state, isMaximizingPlayer: true);
            Move randomMove = moves[new Random().Next(moves.Count)];
            state = ApplyMove(state, randomMove);
            steps++;
        }

        // 计算最终回报
        return Evaluate(state);
    }

    private string FindBestMoveMinimax(GameStatus status)
    {
        GameStatus currentState = status;
        int bestScore = int.MinValue;
        Move bestMove = null;

        foreach (var move in GenerateMoves(status, isMaximizingPlayer: true))
        {
            GameStatus newState = ApplyMove(status, move);
            int score = Minimax(newState, depth: depth, isMaximizingPlayer: false, alpha: int.MinValue, beta: int.MaxValue);
            if (score > bestScore)
            {
                bestScore = score;
                bestMove = move;
            }
        }

        return bestMove.ToString();
    }

    // Minimax 算法（带 Alpha-Beta 剪枝）
    private int Minimax(GameStatus status, int depth, bool isMaximizingPlayer, int alpha, int beta)
    {
        if (depth == 0)
        {
            return Evaluate(status);
        }

        if (isMaximizingPlayer)
        {
            int bestScore = int.MinValue;
            foreach (var move in GenerateMoves(status, isMaximizingPlayer: true))
            {
                GameStatus newState = ApplyMove(status, move);
                int score = Minimax(newState, depth - 1, false, alpha, beta);
                bestScore = Math.Max(bestScore, score);
                alpha = Math.Max(alpha, bestScore);
                if (beta <= alpha) break; // Alpha-Beta 剪枝
            }
            return bestScore;
        }
        else
        {
            int bestScore = int.MaxValue;
            foreach (var move in GenerateMoves(status, isMaximizingPlayer: false))
            {
                GameStatus newState = ApplyMove(status, move);
                int score = Minimax(newState, depth - 1, true, alpha, beta);
                bestScore = Math.Min(bestScore, score);
                beta = Math.Min(beta, bestScore);
                if (beta <= alpha) break; // Alpha-Beta 剪枝
            }
            return bestScore;
        }
    }

    // 应用移动并更新游戏状态
    private GameStatus ApplyMove(GameStatus status, Move move)
    {
        GameStatus newState = new GameStatus
        {
            P1LeftHand = status.P1LeftHand + move.LeftGesture,
            P1RightHand = status.P1RightHand + move.RightGesture,
            P1Hp = status.P1Hp,
            P1CreaturesAttacks = status.P1CreaturesAttacks,
            P2LeftHand = status.P2LeftHand + move.LeftGesture,
            P2RightHand = status.P2RightHand + move.RightGesture,
            P2Hp = status.P2Hp,
            P2CreaturesAttacks = status.P2CreaturesAttacks
        };

        // 应用法术效果
        ApplySpell(newState, move.LeftSpell, move.LeftTarget);
        ApplySpell(newState, move.RightSpell, move.RightTarget);

        return newState;
    }

    // 应用法术效果
    private void ApplySpell(GameStatus status, Spell spell, int target)
    {
        if (spell == null) return;

        switch (spell.Sequence)
        {
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
        }
    }

    private List<Move> GenerateMoves(GameStatus status, bool isMaximizingPlayer)
    {
        List<Move> moves = new List<Move>();

        // 获取玩家的手势历史
        string leftHand = isMaximizingPlayer ? status.P2LeftHand : status.P1LeftHand;
        string rightHand = isMaximizingPlayer ? status.P2RightHand : status.P1RightHand;

        // 尝试所有手势组合
        foreach (var leftGesture in _gestures)
        {
            foreach (var rightGesture in _gestures)
            {
                // 更新手势历史
                string newLeftHand = leftHand + leftGesture;
                string newRightHand = rightHand + rightGesture;

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
                        if (isMaximizingPlayer) target = 0;
                        int leftTarget = leftSpell != null?target : -1;
                        int rightTarget = rightSpell != null?target : -1;

                        moves.Add(new Move(leftGesture, rightGesture, leftSpell, leftTarget, rightSpell, rightTarget));
                    }
                }
            }
        }

        return moves;
    }


   // 评估函数
    private int Evaluate(GameStatus status)
    {
        int score = status.P2Hp - status.P1Hp;
        score += status.P2CreaturesAttacks - status.P1CreaturesAttacks;
        
        return score;
    }
    private int GetMaxGestureRepetition(string gestureSequence)
    {
        var gestureCounts = new Dictionary<char, int>();

        foreach (char gesture in gestureSequence)
        {
            if (gestureCounts.ContainsKey(gesture))
            {
                gestureCounts[gesture]++;
            }
            else
            {
                gestureCounts[gesture] = 1;
            }
        }

        return gestureCounts.Values.Max(); // 返回最大重复次数
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

        public String P2LeftHand { get; set; }
        public String P2RightHand { get; set; }
        public int P2Hp { get; set; }
        public int P2CreaturesAttacks { get; set; }

        public override string ToString()
        {
            return $"Left Hand: {P1LeftHand}\n" +
                $"Right Hand: {P1RightHand}\n" +
                $"HP: {P1Hp}\n" +
                $"Creatures Attacks: {P1CreaturesAttacks}\n" +
                $"Left Hand: {P2LeftHand}\n" +
                $"Right Hand: {P2RightHand}\n" +
                $"HP: {P2Hp}\n" +
                $"Creatures Attacks: {P2CreaturesAttacks}\n";
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
            }

            return gameStatus;
        }
    }
}
