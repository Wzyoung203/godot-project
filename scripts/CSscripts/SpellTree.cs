using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class SpellTree : Node
{
    private readonly SpellNode root;
    private readonly List<Spell> spellList;

    public SpellTree()
    {
        root = new SpellNode();
        spellList = new List<Spell>();
        CreateSpellTree();
        PreloadTrie();
    }

    // 创建法术树
    private void CreateSpellTree()
    {
    // 基础防御法术（核心战略）
    AddSpell("p", new Spell("p", 0), root); // 阻挡召唤物和sd
    
    // 直接伤害法术（按伤害效率调整）
    AddSpell("sd", new Spell("sd", 5), root);        // 2手势/1伤害=4效率
    AddSpell("wfp", new Spell("wfp", 10), root);     // 3手势/2伤害=5效率
    AddSpell("wpfd", new Spell("wpfd", 15), root);   // 4手势/3伤害=4.5效率 
    AddSpell("dffdd", new Spell("dffdd", 25), root); // 5手势/5伤害=4.4效率
    AddSpell("fssdd", new Spell("fssdd", 25), root);  // 5手势/5伤害=4效率（因与dffdd重复稍降）
    
    // 召唤物法术（按预期总伤害估值）
    AddSpell("sfw", new Spell("sfw", 25), root);     // 预期存活2回合：1x2=2
    AddSpell("psfw", new Spell("psfw", 40), root);   // 预期2x2=4
    AddSpell("fpsfw", new Spell("fpsfw", 50), root); // 预期3x2=6
    AddSpell("wfpsfw", new Spell("wfpsfw", 55), root);// 预期4x2=8
    
    // 治疗/解状态法术
    AddSpell("dfw", new Spell("dfw", 10), root);     // 1治疗=抵消1伤害
    AddSpell("dfpw", new Spell("dfpw", 20), root);   // 2治疗+解疾病（战略价值高）
    
    // 特殊效果法术
    AddSpell("swwc", new Spell("swwc", 20), root);   // 高风险AOE（5伤害-自伤风险）
    AddSpell("dsfffc", new Spell("dsfffc", 60), root);// 延迟击杀（7回合=约3.5预期回合）
    
    // 终极法术
    AddSpell("pwpfsssd", new Spell("pwpfsssd", 50), root); // 实际触发率极低，不宜过高
    }

    // 添加法术到字典树中（优化为非递归实现）
    private void AddSpell(string sequence, Spell spell, SpellNode node)
    {
        foreach (char c in sequence)
        {
            if (!node.Children.TryGetValue(c, out var child))
            {
                child = new SpellNode(c);
                node.Children[c] = child;
            }
            node = child;
        }
        node.SetSpell(spell); // 设置法术
    }

    public float GetProgress(string sequence)
    {
        Spell bestSpell = GetBestMatch(sequence);
        if (bestSpell == null) return 0f;
        
        // 计算已匹配长度（取序列长度和法术长度的最小值）
        int matchedLength = Math.Min(sequence.Length, bestSpell.Sequence.Length);
        return (float)matchedLength / bestSpell.Sequence.Length;
    }

    public Spell GetBestMatch(string sequence)
    {
        if (string.IsNullOrEmpty(sequence))
            return null;

        SpellNode currentNode = root;
        Spell bestSpell = null;
        int maxPotentialLength = 0;

        // 1. 遍历现有输入序列
        for (int i = 0; i < sequence.Length; i++)
        {
            char c = sequence[i];
            if (!currentNode.Children.TryGetValue(c, out var child))
                break; // 路径中断，无法继续匹配

            currentNode = child;

            // 记录当前路径上的所有可能法术（即使未完成）
            if (currentNode.Spell != null && currentNode.Spell.Sequence.Length > maxPotentialLength)
            {
                bestSpell = currentNode.Spell;
                maxPotentialLength = bestSpell.Sequence.Length;
            }
        }

        // 2. 寻找当前节点下可能的最长法术（即使未完成）
        Spell potentialSpell = FindDeepestSpell(currentNode);
        if (potentialSpell != null && potentialSpell.Sequence.Length > maxPotentialLength)
        {
            return potentialSpell;
        }

        return bestSpell; // 返回已匹配的最长法术
    }

    // 深度优先搜索寻找子树中最长法术
    private Spell FindDeepestSpell(SpellNode node)
    {
        Spell deepestSpell = null;
        var stack = new Stack<SpellNode>();
        stack.Push(node);

        while (stack.Count > 0)
        {
            var current = stack.Pop();
            
            // 更新最长法术
            if (current.Spell != null && 
            (deepestSpell == null || current.Spell.Sequence.Length > deepestSpell.Sequence.Length))
            {
                deepestSpell = current.Spell;
            }
            
            // 优先探索更长的路径
            foreach (var child in current.Children.Values.OrderByDescending(n => n.Spell?.Sequence.Length ?? 0))
            {
                stack.Push(child);
            }
        }
        
        return deepestSpell;
    }
    // 遍历字典树，加载所有法术
    private void PreloadTrie()
    {
        var queue = new Queue<(SpellNode, string)>();
        queue.Enqueue((root, ""));

        while (queue.Count > 0)
        {
            var (currentNode, prefix) = queue.Dequeue();

            foreach (var child in currentNode.Children.Values)
            {
                var newPrefix = prefix + child.Value;
                queue.Enqueue((child, newPrefix));

                if (child.Spell != null)
                {
                    spellList.Add(child.Spell);
                }
            }
        }
    }

    // 根据输入序列查找法术
    public Spell Search(string sequence)
    {
        var currentNode = root;
        foreach (char c in sequence)
        {
            if (!currentNode.Children.TryGetValue(c, out var child))
            {
                return null; // 未找到匹配的法术
            }
            currentNode = child;
        }
        return currentNode.Spell;
    }

    // 查找输入序列的所有有效法术（必须匹配到结尾）
    public List<Spell> SearchValidSpells(string sequence)
    {
        List<Spell> validSpells = new List<Spell>();

        // 从输入序列的末尾开始逐步缩短序列
        for (int i = sequence.Length; i > 0; i--)
        {
            string subSequence = sequence.Substring(sequence.Length - i); // 获取后缀子序列
            Spell spell = Search(subSequence); // 使用 Search 方法查找法术

            if (spell != null)
            {
                validSpells.Add(spell); // 如果找到法术，添加到结果列表
            }
        }

        return validSpells;
    }

    // 打印所有法术及其分数
    public void PrintSpells()
    {
        Console.WriteLine("法术数据库加载完成:");
        foreach (var spell in spellList)
        {
            Console.WriteLine($"法术: {spell.Sequence}, 分数: {spell.Score}");
        }
    }


}

// Trie树的节点
public class SpellNode
{
    public char Value { get; }
    public Dictionary<char, SpellNode> Children { get; }
    public Spell Spell { get; private set; }

    public SpellNode(char value = '\0')
    {
        Value = value;
        Children = new Dictionary<char, SpellNode>();
    }

    public void SetSpell(Spell spell)
    {
        Spell = spell;
    }
}


// 法术类
public class Spell
{
    public string Sequence { get; }
    public int Score { get; }

    public Spell(string sequence, int score)
    {
        Sequence = sequence;
        Score = score;
    }

}
