---
title: Algorithms - Graphs
tags:
    - Algorithms
category: notes
keywords:
    - Algorithms
    - Graphs
---

## Undirected Graphs

### Some problems

* Path
* Shortest path
* Cycle
* Ehler tour: A cycle that uses each edge excatly once.
* Hamilton tour: A cycle that uses each vertex exactly once
    - classical NP-complete problem.
* Connectivity
* MST:
* Biconnectivity: A vertex whose removal disconnects the graph
* Planarity
* Graph isomorphism: Are two graphs identical?
    - No one knows so far. A lonstanding open problem

### Representations

Real-world graphs tend to be **sparse** (huge number of vertices, small average vertex degree).

* Set-of-edges representation
    - unefficient
* Adjacency-matrix representation
    - space cost is prohibitive
* Adjacency-list array representation
    - GOOD

### Adjacency-list Data structure

* Space usage proportional to V + E
* Constant time to add an edge
* Time proportional to the degree of v to iterate through vertices adjacent to v

### Depth-first Search (DFS)

Typical applications:
* Find all vertices connected to a given source vertex
* Find a path between two vertices

Algorithm:
* Use recursion (a function-call stack) or an explicit stack.
* Mark each visited vertex (and keep track of edge taken to visit it)
* Return (retrace steps) when no unvisited options

```Java
public class DepthFirstPaths{
    private blloean[] marked;
    private int[] edgeTO;
    private int s;
    public DepthFirstPaths(Graph G, int s)
    {
        // ...
        dfs(G, s);
    }

    private void dfs(Graph Gm int v)
    {
        marked[v] = true;
        for (int w : G.adj(v))
            if (!marked[v])
            {
                dfs(G, w)
                edgeTo[w] = v;
            }
    }
}
```

Algorithm:
* Put s onto a queue, and mark s as visited
* Take the next vertex v from the queue and mark it
* Put onto the queue all unmarked vertices that are adjacent to v

```Java
public class BreadthFirstPaths
{
    private boolean[] marked;
    private int[] edgeTo;
    // ...
    private void bfs(Graph G, int s)
    {
        Queue<Integer> q = new Queue<>();
        q.enqueue(s);
        marked[s] = ture;
        while (!q.isEmpty())
        {
            int v = q.dequeue();
            for (int w: G.adj(v))
            {
                if (!marked[w])
                {
                    q.enqueue(w);
                    marked[w] = true;
                    edgeTo[w] = v;
                }
            }
        }
    }
}
```

Propositions:
1. DFS marks all vertices connected to s in time proportional to the sum of their degrees.
2. After DFS, can find vertices connected to s in constant time and can find a path to s in time proportional to its length.

### Breadth-first Search (BFS)

Proposition:
1. BFS computes shortest paths (fewest number of edges) from s to all other vertices in a graph in time proportional to E + V


## Applications of DFS

### Connected components

The goal is to preprocess graph to answer queries of the form *is v connected to w?* in constant time.

The relation *is connected to* is an equivalence relation:
* Reflexive: v is connected to v
* Symmetric: if v is connected to w, then w is connected to v
* Transitive: if v connected to w and w connected to x, then v connected to x

```Java
public class CC {
    private boolean[] marked;
    private int[] id;
    private int count;

    public CC(Graph G) {
        marked = new boolean[G.V()];
        id = new int[G.V()];
        for (int v = 0, v < G.V(); v++) {
            if (!marked[v]) {
                dfs(G, v);
                count++;
            }
        }
    }

    // ...

    private void dfs(Graph G, int v) {
        marked[v] = true;
        id[v] = count;
        for (int w : G.adj(v)) {
            if (!marked[w]) {
                dfs(G, w)
            }
        }
    }
}
```

### Cycle detection

Problem: Is a given graph acylic?

**TODO**

### Two-colorability

Problem: Is the graph bipartite?

**TODO**

### Symbol graphs

**TODO**

### Degrees of separation

**TODO**