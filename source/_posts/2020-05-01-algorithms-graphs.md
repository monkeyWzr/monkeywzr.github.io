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

Propositions:
1. DFS marks all vertices connected to s in time proportional to the sum of their degrees.
2. After DFS, can find vertices connected to s in constant time and can find a path to s in time proportional to its length.

### Breadth-first Search (BFS)

Typical applications:
* shortest path

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

Proposition:
1. BFS computes shortest paths (fewest number of edges) from s to all other vertices in a graph in time proportional to E + V

### Applications of DFS

#### Connected components

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

#### Cycle detection

Problem: Is a given graph acylic?

**TODO**

#### Two-colorability

Problem: Is the graph bipartite?

**TODO**

#### Symbol graphs

**TODO**

#### Degrees of separation

**TODO**

## Directed Graphs

>A directed graph (or digraph) is a set of vertices and a collection of directed edges. Each directed edge connects an ordered pair of vertices.

* *outdegree*: the number of edges going **from** it
* *indegree*: the number fo edges going **into** it
* *directed path*: a sequence of vertices in which there is a (directed) edge pointing from each vertex in the sequence to its successor in the sequence
* *directed cycle*
* *simple cycle*: a cycle with no repeated edges or vertices


### Representations

Again, use [adjacency-lists representation](#Adjacency-list-Data-structure)
* Based on iterating over vertices pointing from v
* Real-world digraphs tend to be sparse

```Java
public class Digraph {
    private final int V;
    private final Bag<Integer>[] adj;

    public Digraph(int V) {
        this.V = V;
        adj = (Bag<Integer>[]) new Bag[V];
        for (int v = 0; v < V; v++) {
            adj[v] = new Bag<Integer>[];
        }
    }

    public void addEdge(int v, int w) {
        adj[v].add(w);
    }

    public Iterable<Integer> adj(int v) {
        return adj[v];
    }
}
```

### Digraph search

Reachabiliity problem: Find all vertices reachable from s along a directed path.

We can use [the same dfs method as for undirected graphs](#Depth-first-Search-(DFS)).
* Every undirected graph is a digraph with edges in both directions.
* DFS is a digraph algorithm,

Reachability applications:
* program control-flow analysis
    - Dead-code elimination
    - infinite-loop detection
* mark-sweep garbage collector


Other DFS problems:
* Path findind
* Topological sort
* Directed cycle detection
* ...

BFS problems:
* shortest path
* multiple-source shortest paths
* web crawler application

### Topological Sort

>Topological sort: Given a digraph, put the vertices in order such that all its directed edges point from a vertix earlier in the order to a vertex later in the order (or report impossible).

A digraph has a topological order **if and only if** it is a *directed acyclic graph* (DAG).
Topological sort redraws DAG so all edges poitn upwards.

use **DFS** again. It can be proved that reverse DFS postorder of a DAG is a topological order.
(check P578 for the definition of Preorder/Postorder)

```Java
public class DepthFirstOrder {
    private boolean[] marked;
    private Stack<Integer> reversePost;

    publiv DepthFirstOrder(Digraph G) {
        reversePost = new Stack<Integer>();
        marked = new boolean[G.V()];
        for (int v = 0; v < G.V(); v++) {
            if (!marked[v]) dfs(G, v);
        }
    }

    private void dsf(Digrapg G, int v) {
        marked[v] = true;
        for (int w : G.adj(v)) {
            if (!marked[w]) dfs(G, w)
        }
        reversePost.push(v);
    }
}
```

#### Directed cycle detection

To find out if a given digraph is a DAG, we can try to find a directec cycle in the digraph.
Use DFS and a stack to track the cycle.

```Java
// TODO
```

Some very typical applications of directed cycle detection and topological sort:
(A directed cycle means the problem is infeasible)
* job schedule
* course scuedule
* inheritance
* spreadsheet
    - vertex: cell
    - edge: formula
* symbolic links

### Strong components

Vertices v and w are **strongly connected** if there is both a directed path from v to w and a directed path from w to v.
Strong connectivity is an equvicalence relation.

#### Kosaraju-Sharir Algorithm

Kosaraju-Sharir is easy to implement but difficutl to understand. It runs DFS twice:
* Given a digraph G, run DFS to compute the topological order of its reverse {% math %}G^R{% endmath %}
* Run DFS on G in the order given by first DFS

TODO: ADD Proof

[https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/KosarajuSharirSCC.java.html](https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/KosarajuSharirSCC.java.html)
```Java
public class KosarajuSharirSCC {
    private boolean[] marked;     // marked[v] = has vertex v been visited?
    private int[] id;             // id[v] = id of strong component containing v
    private int count;            // number of strongly-connected components

    /**
     * Computes the strong components of the digraph {@code G}.
     * @param G the digraph
     */
    public KosarajuSharirSCC(Digraph G) {

        // compute reverse postorder of reverse graph
        DepthFirstOrder dfs = new DepthFirstOrder(G.reverse());

        // run DFS on G, using reverse postorder to guide calculation
        marked = new boolean[G.V()];
        id = new int[G.V()];
        for (int v : dfs.reversePost()) {
            if (!marked[v]) {
                dfs(G, v);
                count++;
            }
        }
    }

    // DFS on graph G
    private void dfs(Digraph G, int v) { 
        marked[v] = true;
        id[v] = count;
        for (int w : G.adj(v)) {
            if (!marked[w]) dfs(G, w);
        }
    }

    // ...
}
```


## Minimum Spanning Trees

An edge-weighted-graph is a graph where we associate weight or costs with each edge.
A spanning tree of an undirected edge-weighted graph G is a subgraph T that is both **a tree (conneted and acyclic)** and **spanning (includes all of the vertices)**.
Given an (connected) undirected edge-weighted graph G with V vertices and E edges, the MST of it must have **V - 1** edges.
If the graph is not connceted, we compute minimum spanning forest (MST of each component).

* A *cut* in a graph is a partition of its vertices into two (nonempty) sets
* A *crossing edge* connects a vertex in one set with a vertex in the other.
* Cut property: Given any cut, the crossing edge of min weight is in the MST.

### Edge-weight Graph Data Type

Edge:
[https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/Edge.java.html](https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/Edge.java.html)

EdgeWeigthedGraph:
[https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/EdgeWeightedGraph.java.html](https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/EdgeWeightedGraph.java.html)

### **Greedy MST Algorithm:**
* Start with all edges colored gray.
* Find cut with no blacked crossing edges; color its min-weight edge black.
* Repeat until V-1 edges are colored black.

### Implementations 1: Kruskal's algorithm

For edges in ascending order of weight:
* Add next edge to Tree unless doing so would create a cycle.

To efficiently solve this problem, use union-find :
1. use a priority queue to maintain all the edges in V
2. union-find data structure:
    - maintain a set for each connected component in T.
    - if v and w are in saome set, then adding v->w would create a cycle
    - to add v>w to T, merge sets containing v and w.

TODO: Add code

### Implementations 2: Prim's algorithm

* Start with vertex 0 and greedily grow tree T.
* Add To T the min weight edge with exactly oue endpoint in T.
* Reapeat unitl V - 1 edges.

The key to solve this problem is how do we find the crossing edge of minimal weight efficiently.

A lazy solution (in time proportional to {% math %}ElogE{% endmath %}, fair enough):
1. Maintain a PQ of edges with (at least) one endpoint in T
    - Key = edge, priority = weight
2. Delete-min to determine next edge e = v->w to add to T
3. Disregard if both endpoints v and w are marked (both in T)
4. Otherwise, let w be the unmarked vertex (not in T)
    - add to PQ and edge incident to w (assuming other endpoint not in T)
    - add e to T and mark w

TODO: add code

A eager solution (in time proprotional to {% math %}ElogV{% endmath %}, better):
1. Maintain a PQ of vertices connected by an edge to T, where priority of v = weight of shortedt edge connecting v to T
2. Delete min vertex v and add its associated edge e = v->w to T
3. Update PQ by considering all edges e = v->x incident to v
    - ignore if x is already in T
    - add x to PQ if not alread on it
    - decrease priority of x if v->x becomes shortest edge connecting x to T

This solution uses an [indexed priority queue](https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/IndexMinPQ.java.html) data structure.

TODO: add code