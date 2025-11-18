"""
Planar Graph Drawing using Backtracking Search
Demonstrates the core algorithm before translating to Prolog
"""

from typing import List, Tuple, Dict, Optional, Set

class PlanarGraphDrawer:
    def __init__(self, vertices: List[str], edges: List[Tuple[str, str]], grid_size: int = 6) -> None:
        self.vertices: List[str] = vertices
        self.edges: List[Tuple[str, str]] = edges
        self.grid_size: int = grid_size
        self.positions: Dict[str, Tuple[int, int]] = {}
        self.attempt_count: int = 0
        self.max_attempts: int = 10000
        
    def solve(self) -> Optional[Dict[str, Tuple[int, int]]]:
        """Main solving predicate - find a planar drawing"""
        print(f"Solving for vertices: {self.vertices}")
        print(f"Edges: {self.edges}")
        print("-" * 50)
        
        self.attempt_count = 0
        self.positions = {}
        
        success = self._backtrack(0)
        
        if success:
            print(f"\n✓ Solution found after {self.attempt_count} attempts!")
            return self.positions
        else:
            print(f"\n✗ No solution found after {self.attempt_count} attempts")
            return None
    
    def _backtrack(self, vertex_index: int) -> bool:
        """
        Recursive backtracking search
        
        This is the CORE of the algorithm - maps directly to Prolog!
        """
        self.attempt_count += 1
        
        # Limit attempts to prevent infinite search
        if self.attempt_count > self.max_attempts:
            return False
        
        # BASE CASE: all vertices placed
        if vertex_index == len(self.vertices):
            # Final check: no crossings in complete drawing
            return not self._has_crossings(self.edges)
        
        # RECURSIVE CASE: place current vertex
        current_vertex = self.vertices[vertex_index]
        print(f"[{self.attempt_count:4d}] Placing vertex '{current_vertex}' (index {vertex_index})")
        
        # GENERATE: try all possible positions
        for x in range(self.grid_size):
            for y in range(self.grid_size):
                
                # Check if position already occupied
                if self._position_occupied(x, y):
                    continue
                
                # ASSIGN position
                self.positions[current_vertex] = (x, y)
                print(f"       Trying position ({x}, {y})")
                
                # TEST: check if position lies on any existing edge
                if self._vertex_on_edge(current_vertex):
                    print(f"       ✗ Position lies on existing edge")
                    del self.positions[current_vertex]
                    continue
                
                # TEST: check if current partial solution is valid
                positioned_edges = self._get_positioned_edges()
                
                if not self._has_crossings(positioned_edges):
                    print(f"       ✓ No crossings so far with {len(positioned_edges)} edges")
                    
                    # RECURSE: try to place next vertex
                    if self._backtrack(vertex_index + 1):
                        return True  # Solution found!
                    
                    print(f"       ↩ Backtracking from vertex '{current_vertex}'")
                else:
                    print(f"       ✗ Crossing detected, trying next position")
                
                # BACKTRACK: remove position and try next
                del self.positions[current_vertex]
        
        # No valid position found for this vertex
        return False
    
    def _position_occupied(self, x: int, y: int) -> bool:
        """Check if a position is already taken"""
        return (x, y) in self.positions.values()
    
    def _vertex_on_edge(self, vertex: str) -> bool:
        """Check if vertex position lies on any existing edge (where vertex is not an endpoint)"""
        if vertex not in self.positions:
            return False
        
        vertex_pos = self.positions[vertex]
        
        # Check all positioned edges
        for v1, v2 in self.edges:
            # Skip edges that include this vertex
            if v1 == vertex or v2 == vertex:
                continue
            
            # Only check edges where both endpoints are already positioned
            if v1 in self.positions and v2 in self.positions:
                edge_points = self._get_line_points(self.positions[v1], self.positions[v2])
                
                # Check if vertex position is on the edge (excluding endpoints)
                if vertex_pos in edge_points[1:-1]:  # Exclude first and last (endpoints)
                    return True
        
        return False
    
    def _get_positioned_edges(self) -> List[Tuple[str, str]]:
        """Get all edges where both endpoints have positions"""
        positioned: List[Tuple[str, str]] = []
        for v1, v2 in self.edges:
            if v1 in self.positions and v2 in self.positions:
                positioned.append((v1, v2))
        return positioned
    
    def _has_crossings(self, edges: List[Tuple[str, str]]) -> bool:
        """Check if any pair of edges crosses or overlaps"""
        for i, (v1, v2) in enumerate(edges):
            for v3, v4 in edges[i+1:]:
                p1 = self.positions[v1]
                p2 = self.positions[v2]
                p3 = self.positions[v3]
                p4 = self.positions[v4]
                
                if self._segments_intersect(p1, p2, p3, p4):
                    return True
                
                # Check if edges share any intermediate points (overlap)
                if self._edges_overlap(p1, p2, p3, p4):
                    return True
        return False
    
    def _edges_overlap(self, p1: Tuple[int, int], p2: Tuple[int, int],
                      p3: Tuple[int, int], p4: Tuple[int, int]) -> bool:
        """Check if two edges share any grid points (excluding shared endpoints)"""
        # Get all points on each line
        points1 = self._get_line_points(p1, p2)
        points2 = self._get_line_points(p3, p4)
        
        # Convert to sets
        set1 = set(points1)
        set2 = set(points2)
        
        # Find intersection
        shared = set1 & set2
        
        # If no shared points, no overlap
        if not shared:
            return False
        
        # Identify which points are endpoints (shared vertices between edges)
        shared_endpoints = set()
        if p1 == p3 or p1 == p4:
            shared_endpoints.add(p1)
        if p2 == p3 or p2 == p4:
            shared_endpoints.add(p2)
        
        # Remove shared endpoints from the shared points
        overlap = shared - shared_endpoints
        
        # If there are any remaining shared points, the edges overlap
        return len(overlap) > 0
    
    def _get_line_points(self, p1: Tuple[int, int], p2: Tuple[int, int]) -> List[Tuple[int, int]]:
        """Get all grid points along a line using Bresenham's algorithm"""
        points = []
        x1, y1 = p1
        x2, y2 = p2
        
        dx = abs(x2 - x1)
        dy = abs(y2 - y1)
        sx = 1 if x2 > x1 else -1
        sy = 1 if y2 > y1 else -1
        err = dx - dy
        x, y = x1, y1
        
        while True:
            points.append((x, y))
            if x == x2 and y == y2:
                break
            e2 = 2 * err
            if e2 > -dy:
                err -= dy
                x += sx
            if e2 < dx:
                err += dx
                y += sy
        
        return points
    
    # - /\/\/\/\
    def _segments_intersect(self, p1: Tuple[int, int], p2: Tuple[int, int], 
                           p3: Tuple[int, int], p4: Tuple[int, int]) -> bool:
        """
        Check if line segments (p1,p2) and (p3,p4) intersect
        Using orientation method with collinear handling
        """
        # Shared endpoints don't count as crossing
        if p1 == p3 or p1 == p4 or p2 == p3 or p2 == p4:
            return False
        
        def orientation(p: Tuple[int, int], q: Tuple[int, int], r: Tuple[int, int]) -> int:
            """
            Find orientation of ordered triplet (p, q, r)
            Returns:
                0: Collinear
                1: Clockwise
                2: Counterclockwise
            """
            val = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1])
            if val == 0:
                return 0  # Collinear
            return 1 if val > 0 else 2  # CW or CCW
        
        def on_segment(p: Tuple[int, int], q: Tuple[int, int], r: Tuple[int, int]) -> bool:
            """Check if point q lies on segment pr (assuming collinear)"""
            return (q[0] <= max(p[0], r[0]) and q[0] >= min(p[0], r[0]) and
                    q[1] <= max(p[1], r[1]) and q[1] >= min(p[1], r[1]))
        
        o1 = orientation(p1, p2, p3)
        o2 = orientation(p1, p2, p4)
        o3 = orientation(p3, p4, p1)
        o4 = orientation(p3, p4, p2)
        
        # General case: segments intersect if orientations differ
        if o1 != o2 and o3 != o4:
            return True
        
        # Special cases: collinear points
        if o1 == 0 and on_segment(p1, p3, p2):
            return True
        if o2 == 0 and on_segment(p1, p4, p2):
            return True
        if o3 == 0 and on_segment(p3, p1, p4):
            return True
        if o4 == 0 and on_segment(p3, p2, p4):
            return True
        
        return False

    def display(self, solution: Optional[Dict[str, Tuple[int, int]]]) -> None:
        """Display the graph drawing in console using ASCII art"""
        if solution is None:
            print("\nNo solution to display")
            return
        
        print("\n" + "="*60)
        print("GRAPH DRAWING (ASCII Art)")
        print("="*60)
        
        # Create a grid for display
        display_grid = [[' ' for _ in range(self.grid_size * 4)] for _ in range(self.grid_size * 3)]
        
        # Scale factor for better spacing
        scale_x = 4
        scale_y = 3
        
        # First, draw all edges
        for v1, v2 in self.edges:
            x1, y1 = solution[v1]
            x2, y2 = solution[v2]
            
            # Scale positions
            sx1, sy1 = x1 * scale_x, y1 * scale_y
            sx2, sy2 = x2 * scale_x, y2 * scale_y
            
            # Draw line between vertices
            self._draw_line(display_grid, sx1, sy1, sx2, sy2)
        
        # Then, draw vertices (so they appear on top)
        for vertex, (x, y) in solution.items():
            sx, sy = x * scale_x, y * scale_y
            # Place vertex label (will overwrite line characters)
            label = str(vertex)
            for i, char in enumerate(label):
                if sx + i < len(display_grid[0]):
                    display_grid[sy][sx + i] = char
        
        # Print the grid
        for row in display_grid:
            print(''.join(row))
        
        print("\nVertex Positions:")
        for vertex in sorted(solution.keys()):
            x, y = solution[vertex]
            print(f"  {vertex}: ({x}, {y})")
        print("="*60)
    
    def _draw_line(self, grid: List[List[str]], x1: int, y1: int, x2: int, y2: int) -> None:
        """Draw a line from (x1,y1) to (x2,y2) using ASCII characters"""
        dx = abs(x2 - x1)
        dy = abs(y2 - y1)
        
        # Determine direction
        sx = 1 if x2 > x1 else -1
        sy = 1 if y2 > y1 else -1
        
        # Choose line character based on direction
        if dx == 0:  # Vertical line
            char = '|'
        elif dy == 0:  # Horizontal line
            char = '-'
        elif (sx > 0 and sy > 0) or (sx < 0 and sy < 0):  # Diagonal \
            char = '\\'
        else:  # Diagonal /
            char = '/'
        
        # Bresenham's line algorithm
        err = dx - dy
        x, y = x1, y1
        
        while True:
            # Place character if position is valid and empty
            if 0 <= y < len(grid) and 0 <= x < len(grid[0]):
                if grid[y][x] == ' ':
                    grid[y][x] = char
            
            if x == x2 and y == y2:
                break
            
            e2 = 2 * err
            if e2 > -dy:
                err -= dy
                x += sx
            if e2 < dx:
                err += dx
                y += sy

# ==============================================================
# TEST CASES
# ==============================================================

def test_simple_graph() -> None:
    """Simple planar graph (square with diagonal)"""
    print("\n" + "#"*50)
    print("TEST 1: Simple Planar Graph")
    print("#"*50)
    
    vertices = ['A', 'B', 'C', 'D']
    edges = [('A', 'B'), ('B', 'C')]
    
    drawer = PlanarGraphDrawer(vertices, edges, grid_size=4)
    solution = drawer.solve()
    drawer.display(solution)


def test_tree() -> None:
    """Tree (always planar)"""
    print("\n" + "#"*50)
    print("TEST 2: Tree Graph")
    print("#"*50)
    
    vertices = ['A', 'B', 'C', 'D', 'E']
    edges = [('A', 'B'), ('A', 'C'), ('B', 'D'), ('B', 'E')]
    
    drawer = PlanarGraphDrawer(vertices, edges, grid_size=5)
    solution = drawer.solve()
    drawer.display(solution)


def test_complex_planar() -> None:
    """More complex planar graph"""
    print("\n" + "#"*50)
    print("TEST 3: Complex Planar Graph")
    print("#"*50)
    
    vertices = ['A', 'B', 'C', 'D', 'E']
    edges = [('A', 'B'), ('B', 'C'), ('C', 'D'), ('D', 'E'), 
             ('E', 'A'), ('A', 'C'), ('A', 'D')]
    
    drawer = PlanarGraphDrawer(vertices, edges, grid_size=6)
    solution = drawer.solve()
    drawer.display(solution)


def test_k5() -> None:
    """K5 - NON-PLANAR (should fail)"""
    print("\n" + "#"*50)
    print("TEST 4: K5 (Non-Planar - Should Fail)")
    print("#"*50)
    
    vertices = ['A', 'B', 'C', 'D', 'E']
    edges = [
        ('A', 'B'), ('A', 'C'), ('A', 'D'), ('A', 'E'),
        ('B', 'C'), ('B', 'D'), ('B', 'E'),
        ('C', 'D'), ('C', 'E'),
        ('D', 'E')
    ]
    
    drawer = PlanarGraphDrawer(vertices, edges, grid_size=6)
    drawer.max_attempts = 5000  # Limit for non-planar
    solution = drawer.solve()
    drawer.display(solution)
    
    
def test_star() -> None:
    """Star graph (always planar)"""
    print("\n" + "#"*50)
    print("TEST 5: Star Graph")
    print("#"*50)
    
    vertices = ['C', 'A', 'B', 'D', 'E']
    edges = [('C', 'A'), ('C', 'B'), ('C', 'D'), ('C', 'E')]
    
    drawer = PlanarGraphDrawer(vertices, edges, grid_size=5)
    solution = drawer.solve()
    drawer.display(solution)


# ==============================================================
# MAIN
# ==============================================================

def get_line_points(self, p1: Tuple[int, int], p2: Tuple[int, int]) -> List[Tuple[int, int]]:
    """Get all grid points along a line using Bresenham's algorithm"""
    points = []
    x1, y1 = p1
    x2, y2 = p2
    
    dx = abs(x2 - x1)
    dy = abs(y2 - y1)
    sx = 1 if x2 > x1 else -1
    sy = 1 if y2 > y1 else -1
    err = dx - dy
    while True:
        points.append((x1, y1))
        if x1 == x2 and y1 == y2:
            break
        e2 = 2 * err
        print(e2)
        if e2 > -dy:
            err -= dy
            x1 += sx
        if e2 < dx:
            err += dx
            y1 += sy
    
    return points

if __name__ == "__main__":
    print("""
╔════════════════════════════════════════════════════════╗
║  PLANAR GRAPH DRAWING - BACKTRACKING ALGORITHM        ║
║  Demonstrates core concepts before Prolog translation  ║
╚════════════════════════════════════════════════════════╝
    """)
    
    # Run tests
    test_simple_graph()
    # test_tree()
    # test_complex_planar()
    # test_k5()  # This will fail - non-planar!
    # test_star()
    
    print("\n" + "="*50)
    print("DONE! Study the backtracking patterns above.")
    print("="*50)
    
    