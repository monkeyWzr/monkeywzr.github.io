---
title: Algorithms - Maxflow and Mincut
date: 2020-05-20 09:00:00
tags:
    - Algorithms
category: notes
keywords:
    - Algorithms
    - Graphs
    - maxflow
    - mincut
mathjax: true
---

## Model

We use a flow network model which is an edge-weighted digraph with positive edge weights referred to as **capacities**. An st-flow network has two identified vertices, a source s and a sink t.

### Minimum Cut problem

An st-cut is a partition of  the vertices into two disjoint sets, which s in one set A and t in the other set B. Its capacity is the sum of the capacities of the edges from A to B.

The minimum st-cut plobem is to find a cut of minimum capacity.

### Maximum Flow problem

An st-flow is an assignment of values to the edges such that:
* Capacity constraint* 0 <= edges's capacity.
* Local equilibrium: inflow = outflow at every vertex (except s and t).

The value of a flow is the inflow at t.

The Maximum st-flow problem is to find a flow of maximum value.

## Maxflow and Mincut are dual!

* The **net flow across** a cut (A,B) is the sum of the flows on its edges from A to B minus the flows on its edges from B to A.
* **Flow-value lemma**: Let $f$ be any flow and let (A,B) be any cut. Then the net flow across (A,B) equals the values of $f$.
* **Weak duality**: Let f be any flow and let (A,B) be any cut. Then the value of the flow <= the capacity of the cut.
* **Argumenting path theorem**: A flow $f$ is a maxflow iff no argumenting paths.
* **Maxflow-mincut theorem**: Value of the maxflow = capacity of mincut. Three equivalent conditions:
  * There exists a cut whose capacity equals the values of the value of the flow f.
  * f is a maxflow.
  * There is no augmenting path with respect to f.
* To compute a mincut from maxflow f, compute A = set of vertices connected to s by an undirected path with no full forward or empty backward edges

## Ford-Fulkerson algorithm

* An **argumenting path** is an undirected path from s to t such that 
  * Can increase flow on forward edges (not full)
  * Can decrease flow on backward edge (not empty)
* The **termination** is when all paths from s to t are blocked by either a
  * Full forward edge
  * Empty backward edge

```
Start with 0 flow.
While there exists an augmenting path:
    - find an augmenting path
    - compute bottleneck capacity
    - increase flow on that path by bottleneck capacity
```

### Representation

* Flow edge data type: Associate flow $f_e$ and capacity $c_e$ 
* Residual capacity:
  - Forward edge: residual capacity = $c_e - f_e$
  - Backward edge: residual capacity = $f_e$
* Argument flow:
  * Forward edge: add $\varDelta$
  * Backward edge: subtract $\varDelta$
* Residual network: Argumenting path in original network is equivalent to directed path in residual network.
  * backward edge: **not empty**
  * forward edge: **not full**

Flow edge implementation:
[https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/FlowEdge.java.html](https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/FlowEdge.java.html)

Flow network implementation (adjacency-lists representation):
[https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/FlowNetwork.java.html](https://algs4.cs.princeton.edu/code/edu/princeton/cs/algs4/FlowNetwork.java.html)

Ford-Fulkerson implementation:
```Java
public class FordFulkerson {

  private boolean[] marked;
  private FlowEdge[] edgeTo;
  private double value;

  public FordFulkerson(FlowNetwork G, int s, int t) {
    value = 0.0;
    while(hasAugmentingPath(G, s, t)) {
      double bottle = Double.POSITICE_INFINITY;
      // calculate the bottleneck residual capacity to t
      for (int v = t; v != s; v = edgeTo[v].other(v)) {
        bottle = Math.min(bottle, edgeTo[v].residualCapacityTo(v));
      }

      // increase flow by the bottleneck
      for (int v = t; v != s; v = edgeTo[v].other(v)) {
        edgeTo[v].addResidualFlowTo(v, bottle);
      }

      value += bottle;
    }
  }

  private boolean hasAugmentingPath(FlowNetwork G, int s, int t) {
    edgeTo = new FlowEdge[G.V()];
    marked = new boolean[G.V()];

    Queue<Integer> queue = new Queue<Integer>();
    queue.enqueue(s);
    marked[s] = true;
    while(!queue.isEmpty()) {
      int v = queue.dequeue();
      for (FlowEdge e : G.adj(v)){
        int w = e.other();
        if (e.residualCapacityTo(w) > 0 && !marked[w]) {
          edgeTo[w] = e;
          marked[w] = true;
          queue.enqueue(w);
        }
      }
    }
    return marked[t];
  }
}
```

### Applications

Some applications:
* Bipartite matching
* Baseball elemination
* ...