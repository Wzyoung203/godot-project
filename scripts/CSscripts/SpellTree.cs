using Godot;
using System;
using System.Collections.Generic;

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
        AddSpell("p", new Spell("p", 5), root);
        AddSpell("sd", new Spell("sd", 10), root);
        AddSpell("pwpfsssd", new Spell("pwpfsssd", 50), root);
        AddSpell("dffdd", new Spell("dffdd", 30), root);
        AddSpell("wfp", new Spell("wfp", 8), root);
        AddSpell("wpfd", new Spell("wpfd", 12), root);
        AddSpell("fssdd", new Spell("fssdd", 40), root);
        AddSpell("sfw", new Spell("sfw", 15), root);
        AddSpell("psfw", new Spell("psfw", 20), root);
        AddSpell("fpsfw", new Spell("fpsfw", 25), root);
        AddSpell("wfpsfw", new Spell("wfpsfw", 35), root);
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
